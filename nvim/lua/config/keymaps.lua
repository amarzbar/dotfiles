-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Terminal windows: jump straight from terminal mode into visual mode.
-- <C-v> = visual, <C-x> = plain normal mode (then v / V / <C-v> as usual).
-- <Esc><Esc> (LazyVim default) and <C-\><C-n> also leave terminal mode.
-- Press i or a in the terminal buffer to type into the shell again.
vim.keymap.set("t", "<C-v>", [[<C-\><C-n>v]], { desc = "Terminal: visual mode" })
vim.keymap.set("t", "<C-x>", [[<C-\><C-n>]], { desc = "Terminal: normal mode" })
