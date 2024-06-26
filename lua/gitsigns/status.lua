local api = vim.api

--- @class (exact) Gitsigns.StatusObj
--- @field added? integer
--- @field removed? integer
--- @field changed? integer
--- @field head? string
--- @field root? string
--- @field gitdir? string

local M = {}

--- @param bufnr integer
local function autocmd_update(bufnr)
  api.nvim_exec_autocmds('User', {
    pattern = 'GitSignsUpdate',
    modeline = false,
    data = { buffer = bufnr },
  })
end

--- @param bufnr integer
--- @param status Gitsigns.StatusObj
function M:update(bufnr, status)
  if not api.nvim_buf_is_loaded(bufnr) then
    return
  end
  local bstatus = vim.b[bufnr].gitsigns_status_dict
  if bstatus then
    status = vim.tbl_extend('force', bstatus, status)
  end
  vim.b[bufnr].gitsigns_head = status.head or ''
  vim.b[bufnr].gitsigns_status_dict = status

  local config = require('gitsigns.config').config

  vim.b[bufnr].gitsigns_status = config.status_formatter(status)

  autocmd_update(bufnr)
end

function M:clear(bufnr)
  if not api.nvim_buf_is_loaded(bufnr) then
    return
  end
  vim.b[bufnr].gitsigns_head = nil
  vim.b[bufnr].gitsigns_status_dict = nil
  vim.b[bufnr].gitsigns_status = nil
  autocmd_update(bufnr)
end

return M
