-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Meeting notes: an unnamed buffer gets saved as <cwd>/YYYY-MM-DD.md the first time
-- you leave insert mode (or enter visual mode), then keeps autosaving after that.
local function autosave_notes(ev)
  local buf = ev.buf
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then
    return
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if table.concat(lines):match("^%s*$") then
      return
    end
    local base = vim.fn.getcwd() .. "/" .. os.date("%Y-%m-%d")
    local path, n = base .. ".md", 2
    while vim.uv.fs_stat(path) do
      path, n = base .. "-" .. n .. ".md", n + 1
    end
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent write " .. vim.fn.fnameescape(path))
      vim.cmd("filetype detect")
    end)
    vim.b[buf].autosave_notes = true
    vim.notify("Saved as " .. vim.fn.fnamemodify(path, ":~:."))
  elseif vim.b[buf].autosave_notes and vim.bo[buf].modified then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent update")
    end)
  end
end

local notes_group = vim.api.nvim_create_augroup("autosave_notes", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
  group = notes_group,
  callback = autosave_notes,
})
vim.api.nvim_create_autocmd("ModeChanged", {
  group = notes_group,
  pattern = "*:[vV\22]*",
  callback = autosave_notes,
})
