-- Import the LSP and completion modules
local nvim_lsp = require('lspconfig')
local cmp = require('cmp')

-- Set up nvim-cmp for autocompletion
cmp.setup({
  snippet = {
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body)  -- Ensure you have vsnip installed for snippets
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['CR>'] = cmp.mapping.complete(),
  },
  sources = {
    { name = 'nvim_lsp' },  -- LSP source for autocompletion
    { name = 'buffer' },    -- Buffer source for autocompletion
  },
})

-- Define a simple `on_attach` function to be used with LSPs
local on_attach = function(client, bufnr)
  -- Set up buffer-specific key mappings, commands, etc.
  local opts = { noremap = true, silent = true }

  -- Example key mappings for LSP functionality
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)  -- Go to definition
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)       -- Hover information
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)  -- Go to references
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts) -- Rename symbol

  -- Enable formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
end

-- List of LSP servers to configure (including clangd for C/C++)
local servers = { 'pyright', 'ts_ls', 'clangd' }

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({
    on_attach = on_attach,  -- Attach the custom on_attach function
    flags = {
      debounce_text_changes = 150,
    },
  })
end

-- Custom highlight for Function (LSP)
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, 'Function', { fg = '#7a9d9d', ctermfg = 14 })
    vim.api.nvim_set_hl(0, 'Operator', { fg = '#ab96ba', ctermfg = 14 })
    vim.api.nvim_set_hl(0, '@variable', { fg = '#B1B5B4', ctermfg = 14 })
    vim.api.nvim_set_hl(0, 'Type', { fg = '#87AFD7', ctermfg = 14 })
    vim.api.nvim_set_hl(0, 'TSFunction', { fg = '#7a9d9d', ctermfg = 14 })
    vim.api.nvim_set_hl(0, 'LspFunction', { fg = '#7a9d9d', ctermfg = 14 })
  end,
})

-- Additional configurations for clangd (optional)
nvim_lsp.clangd.setup({
  on_attach = on_attach,  -- Use the same on_attach function
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { "clangd", "--background-index" },  -- Example: you can add extra flags here
  filetypes = { "c", "cpp", "objc", "objcpp" },  -- Ensure clangd handles C/C++ files
})
