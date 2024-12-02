require("required")

vim.opt.termguicolors = true
require'colorizer'.setup()

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

-- save the position of the cursor
vim.api.nvim_exec([[
  augroup remember_cursor_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  augroup END
]], false)

print("I use Arch BTW")
