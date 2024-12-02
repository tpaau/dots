-- Import the LSP and completion modules
local nvim_lsp = require('lspconfig')
local cmp = require('cmp')

-- Set up nvim-cmp for autocompletion
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)  -- Ensure you have vsnip installed for snippets
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
})

-- Define a simple `on_attach` function to be used with LSPs
local on_attach = function(client, bufnr)
  -- Set up buffer-specific key mappings, commands, etc.
  -- Example: LSP-specific mappings
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {})
  -- Add more configurations as needed
end

-- LSP server setup
local servers = { 'pyright', 'ts_ls', 'clangd' }

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

-- Custom highlight for Function (TS or LSP)
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, 'Function', { fg = '#7AA3AB', ctermfg = 14 })
    vim.api.nvim_set_hl(0, '@variable', { fg = '#B1B5B4', ctermfg = 14 })
    vim.api.nvim_set_hl(0, 'TSFunction', { fg = '#7F9384', ctermfg = 14 })
    vim.api.nvim_set_hl(0, 'LspFunction', { fg = '#7F9384', ctermfg = 14 })
  end,
})

