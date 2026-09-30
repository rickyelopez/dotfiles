local M = {}

local overrides_by_root = {}
local client_baselines = {}
local initialized_clients = {}
local editor_windows_by_root = {}
local setup_complete = false

local default_cfgs = { "debug_assertions", "miri" }

local markers = {
  enabled = "+",
  disabled = "-",
  inherited = " ",
}

local states = {
  ["+"] = "enabled",
  ["-"] = "disabled",
  [" "] = "inherited",
}

local function client_root(client)
  if not client.root_dir then
    return nil
  end
  return vim.uv.fs_realpath(client.root_dir) or client.root_dir
end

local function feature_from_cfg(cfg)
  local value = cfg:match("^!?feature=(.+)$")
  if not value then
    return nil
  end

  local ok, feature = pcall(vim.json.decode, value)
  if ok and type(feature) == "string" then
    return feature
  end
  return value
end

local function feature_cfg(feature, state)
  local prefix = state == "disabled" and "!" or ""
  return prefix .. "feature=" .. feature
end

local function client_baseline(client)
  if client_baselines[client.id] then
    return client_baselines[client.id]
  end

  local rust_analyzer = (client.settings or {})["rust-analyzer"] or {}
  local cargo = rust_analyzer.cargo or {}
  local baseline = {
    has_cfgs = cargo.cfgs ~= nil,
    cfgs = vim.deepcopy(cargo.cfgs or default_cfgs),
  }
  client_baselines[client.id] = baseline
  return baseline
end

local function configured_cfgs(client, overrides)
  local baseline = client_baseline(client)
  local managed = {}
  local cfgs = {}

  for feature, state in pairs(overrides) do
    if state ~= "inherited" then
      managed[feature] = true
    end
  end

  for _, cfg in ipairs(baseline.cfgs) do
    local feature = feature_from_cfg(cfg)
    if not feature or not managed[feature] then
      cfgs[#cfgs + 1] = cfg
    end
  end

  local features = vim.tbl_keys(managed)
  table.sort(features)
  for _, feature in ipairs(features) do
    cfgs[#cfgs + 1] = feature_cfg(feature, overrides[feature])
  end

  if #features == 0 and not baseline.has_cfgs then
    return nil
  end
  return cfgs
end

local function apply_to_client(client, overrides)
  local cfgs = configured_cfgs(client, overrides)
  client.settings = vim.deepcopy(client.settings or {})
  client.settings["rust-analyzer"] = client.settings["rust-analyzer"] or {}
  local rust_analyzer = client.settings["rust-analyzer"]
  rust_analyzer.cargo = rust_analyzer.cargo or {}
  rust_analyzer.cargo.cfgs = cfgs

  client:notify("workspace/didChangeConfiguration", {
    settings = client.settings,
  })
  vim.defer_fn(function()
    if client:is_stopped() then
      return
    end
    client:request("rust-analyzer/reloadWorkspace", nil, function(err)
      if err then
        vim.notify("Failed to reload rust-analyzer workspace: " .. tostring(err), vim.log.levels.ERROR)
      end
    end, 0)
  end, 100)
end

local function apply_to_root(root)
  local applied = false
  for _, client in ipairs(vim.lsp.get_clients({ name = "rust_analyzer" })) do
    if client_root(client) == root then
      apply_to_client(client, overrides_by_root[root] or {})
      applied = true
    end
  end
  return applied
end

local function format_line(feature, state)
  return string.format("[%s] %s", markers[state], feature)
end

local function has_explicit_overrides(overrides)
  for _, state in pairs(overrides) do
    if state ~= "inherited" then
      return true
    end
  end
  return false
end

local function parse_lines(lines)
  local overrides = {}
  for line_number, line in ipairs(lines) do
    if vim.trim(line) ~= "" then
      local marker, feature = line:match("^%[(.)%]%s*(.-)%s*$")
      local state = marker and states[marker]
      if not state then
        return nil, string.format("Line %d must start with [+], [-], or [ ]", line_number)
      end
      if feature == "" then
        return nil, string.format("Line %d is missing a feature name", line_number)
      end
      if feature:find("%s") or feature:find("%c") or feature:find("=", 1, true) then
        return nil, string.format("Invalid feature name: %s", feature)
      end
      if overrides[feature] then
        return nil, string.format("Feature appears more than once: %s", feature)
      end
      overrides[feature] = state
    end
  end
  return overrides
end

local function set_marker(bufnr, marker)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
  local feature = line:match("^%[.%]%s*(.*)$") or vim.trim(line)
  vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, {
    string.format("[%s] %s", marker, feature),
  })
end

local function cycle_marker(bufnr)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
  local marker = line:match("^%[(.)%]")
  local next_marker = marker == "+" and "-" or marker == "-" and " " or "+"
  set_marker(bufnr, next_marker)
end

local function add_line(bufnr, before)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local index = before and row - 1 or row
  vim.api.nvim_buf_set_lines(bufnr, index, index, false, { "[+] " })
  vim.api.nvim_win_set_cursor(0, { index + 1, 4 })
  vim.cmd("startinsert!")
end

local function notify_state(root, overrides)
  local active = {}
  for feature, state in pairs(overrides) do
    if state == "enabled" then
      active[#active + 1] = "+" .. feature
    elseif state == "disabled" then
      active[#active + 1] = "-" .. feature
    end
  end
  table.sort(active)

  local message = #active == 0 and "Rust feature overrides cleared"
    or "Rust feature overrides: " .. table.concat(active, ", ")
  vim.notify(message .. " (" .. vim.fs.basename(root) .. ")", vim.log.levels.INFO)
end

local function open_editor()
  local client = vim.lsp.get_clients({ bufnr = 0, name = "rust_analyzer" })[1]
  local root = client and client_root(client)
  if not root then
    vim.notify("No rust-analyzer client is attached to this buffer", vim.log.levels.ERROR)
    return
  end

  local existing_winid = editor_windows_by_root[root]
  if existing_winid and vim.api.nvim_win_is_valid(existing_winid) then
    vim.api.nvim_set_current_win(existing_winid)
    return
  end

  local current = overrides_by_root[root] or {}
  local features = vim.tbl_keys(current)
  table.sort(features)

  local lines = {}
  for _, feature in ipairs(features) do
    lines[#lines + 1] = format_line(feature, current[feature])
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].filetype = "rust_features"
  vim.bo[bufnr].swapfile = false
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  local width = math.max(1, math.min(72, vim.o.columns - 4))
  local height = math.max(1, math.min(20, math.max(4, #lines), vim.o.lines - 4))
  local winid = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    style = "minimal",
    border = "rounded",
    title = " Rust feature overrides ",
    title_pos = "center",
    footer = " Space cycle  o add  Enter apply  q cancel ",
    footer_pos = "center",
  })
  editor_windows_by_root[root] = winid
  vim.wo[winid].cursorline = true

  local function close()
    editor_windows_by_root[root] = nil
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_close(winid, true)
    end
  end

  local function apply()
    local overrides, parse_error = parse_lines(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
    if not overrides then
      vim.notify(parse_error, vim.log.levels.ERROR)
      return
    end

    overrides_by_root[root] = overrides
    apply_to_root(root)
    close()
    notify_state(root, overrides)
  end

  local map_options = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<Space>", function()
    cycle_marker(bufnr)
  end, map_options)
  vim.keymap.set("n", "+", function()
    set_marker(bufnr, "+")
  end, map_options)
  vim.keymap.set("n", "-", function()
    set_marker(bufnr, "-")
  end, map_options)
  vim.keymap.set("n", "0", function()
    set_marker(bufnr, " ")
  end, map_options)
  vim.keymap.set("n", "o", function()
    add_line(bufnr, false)
  end, map_options)
  vim.keymap.set("n", "O", function()
    add_line(bufnr, true)
  end, map_options)
  vim.keymap.set("n", "<CR>", apply, map_options)
  vim.keymap.set("n", "q", close, map_options)
  vim.keymap.set("n", "<Esc>", close, map_options)
end

function M.setup()
  if setup_complete then
    return
  end
  setup_complete = true

  vim.api.nvim_create_user_command("RustFeatures", open_editor, {
    desc = "Edit rust-analyzer feature overrides",
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("rust-feature-overrides", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client or client.name ~= "rust_analyzer" or initialized_clients[client.id] then
        return
      end

      local root = client_root(client)
      if not root then
        return
      end

      initialized_clients[client.id] = true
      overrides_by_root[root] = overrides_by_root[root] or {}
      if has_explicit_overrides(overrides_by_root[root]) then
        vim.schedule(function()
          if not client:is_stopped() then
            apply_to_client(client, overrides_by_root[root])
          end
        end)
      end
    end,
  })
end

return M
