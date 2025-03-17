local M = {}

--- start the server
--- @param path? string path to the listen socket
function M.start(path)
  path = path or "~/.local/state/nvim/nvimsocket"
  path = vim.fn.expand(path)

  local has_lsof = vim.system({ "which", "lsof" }):wait()

  if has_lsof.code ~= 0 then
    -- if the file exists and the system doesn't have lsof, we can't do anything so just exit
    vim.notify("server socket exists and system does not have lsof", vim.log.levels.ERROR)
    return
  end

  local lsof_out = vim.system({ "lsof", "-U" }):wait()

  if lsof_out.code ~= 0 then
    vim.notify("Error running lsof: " .. lsof_out.stderr, vim.log.levels.ERROR)
    return
  end

  if lsof_out.stdout:match(path) then
    -- the file is open, meaning another nvim process has already started a server
    return
  end

  local ls_out = vim.system({ "ls", path }):wait()

  if ls_out.code == 0 then
    -- the file exists, but is not open so it is probably a dead socket. delete it
    local rm_out = vim.system({ "rm", path }):wait()

    if rm_out.code ~= 0 then
      vim.notify("Error when deleting dead socket: " .. rm_out.stderr, vim.log.levels.ERROR)
      return
    end
  end

  -- if we've made it to this point, we should be good to start the server
  vim.fn.serverstart(path)
  -- vim.fn.serverstop(path)
end

return M
