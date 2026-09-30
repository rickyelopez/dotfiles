local M = {}

local checked_repositories = {}
local loaded_configs = {}

local function load_for(path)
  local stat = vim.uv.fs_stat(path)
  local directory = stat and stat.type == "directory" and path or vim.fs.dirname(path)
  if not directory then
    return
  end

  local git_marker = vim.fs.find(".git", { path = directory, upward = true })[1]
  if not git_marker then
    return
  end

  local repository = vim.fs.dirname(git_marker)
  if checked_repositories[repository] then
    return
  end
  checked_repositories[repository] = true

  local result = vim
    .system({
      "git",
      "-C",
      repository,
      "config",
      "--local",
      "--path",
      "--get",
      "nvim.projectConfig",
    }, { text = true })
    :wait()
  if result.code ~= 0 then
    return
  end

  local config_path = vim.trim(result.stdout or "")
  if config_path == "" or loaded_configs[config_path] then
    return
  end

  local config, load_error = loadfile(config_path)
  if not config then
    vim.notify(load_error, vim.log.levels.ERROR)
    return
  end

  local ok, config_error = pcall(config)
  if not ok then
    vim.notify(config_error, vim.log.levels.ERROR)
    return
  end

  loaded_configs[config_path] = true
end

function M.setup()
  load_for(vim.fn.getcwd())

  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("project-config", { clear = true }),
    callback = function(event)
      load_for(event.match)
    end,
  })
end

return M
