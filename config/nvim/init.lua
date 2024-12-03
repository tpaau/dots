-- initialize plugins
require("required")

-- vim cmd settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.o.showmode = false

-- it needs to be after `vim.opt.termguicolors = true`
require'colorizer'.setup()

-- save the position of the cursor
vim.api.nvim_exec([[
  augroup remember_cursor_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  augroup END
]], false)

-- I use Arch BTW
print("I use Arch BTW")
