vim.opt.termguicolors = true -- wider color palette

vim.cmd("colorscheme habamax")

-- needs to be after `vim.opt.termguicolors = true`
require'colorizer'.setup()

vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#b9b9b9" })
