local M = {}

M.map = function(lhs, rhs, modes, opts)
    modes = modes or {"n"}
    opts = opts or { noremap = true, silent = true }
    vim.keymap.set(modes, lhs, rhs, opts)
end

M.tablePrint = function(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.tablePrint(v) .. ','
      end
      print(s .. '} ')
   else
      return tostring(o)
   end
end

return M
