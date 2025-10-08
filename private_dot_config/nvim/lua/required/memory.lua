-- Remember some stuff when you exit neovim

-- cursor position
vim.api.nvim_exec([[
    augroup remember_cursor_position
        autocmd!
        autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
]], false)

-- folds
vim.api.nvim_exec([[
    set viewoptions-=options
    augroup remember_folds
        autocmd!
        autocmd BufWinLeave *.* mkview
        autocmd BufWinEnter *.* silent! loadview
    augroup END
]], false)
