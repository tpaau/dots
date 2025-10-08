local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

npairs.setup({ map_bs = false, map_cr = false })
vim.g.coq_settings = { keymap = { recommended = false } }
