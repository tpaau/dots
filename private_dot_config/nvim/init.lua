vim.loader.enable()

-- initialize plugins
require "required"

-- vim cmd settings
vim.opt.number = true -- show line number
vim.opt.tabstop = 4 -- space characters in a tab
vim.opt.shiftwidth = 4 -- space characters when doing << or >>
vim.o.showmode = false -- looks weird with lualine
vim.opt.scrolloff = 8 -- the minimum amounts of lines visible
vim.opt.relativenumber = true -- relative line numbers
vim.opt.clipboard:append "unnamedplus"

-- Show which line your cursor is on
vim.o.cursorline = true
vim.cmd("highlight CursorLine ctermbg=236 guibg=#1f1f1f")

-- configure line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.o.breakindent = true

-- configure folding
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- configure spell
vim.o.spell = true
vim.o.spelllang = "en_us"

vim.opt.mouse = ""

-- Ask whether to save a file instead of throwing an error
vim.o.confirm = true

-- save undo history in a file
vim.o.undofile = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
