" Initialize vim-plug
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'
Plug 'norcalli/nvim-colorizer.lua'

" Autocompletion plugin
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'neovim/nvim-lspconfig'

call plug#end()

" Save and restore cursor position when reopening a file
augroup remember_cursor_position
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

colorscheme habamax
"colorscheme slate

" Enable ALE
let g:ale_enabled = 1

set linebreak
set scrolloff=15
set termguicolors
set shiftwidth=4
set expandtab

autocmd VimEnter * echo "I use Arch BTW"



lua << EOF
local nvim_lsp = require('lspconfig')
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
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
  }
})

-- Setup LSP servers
local servers = { 'pyright', 'tsserver', 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" Enable colorizer
lua << EOF
require'colorizer'.setup()
EOF

" Remap jkl; to hjkl for normal mode
nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ; l

" Remap jkl; to hjkl for visual mode
vnoremap j h
vnoremap k j
vnoremap l k
vnoremap ; l

" Remap jkl; to hjkl for operator-pending mode
onoremap j h
onoremap k j
onoremap l k
onoremap ; l

" Configure ALE linters
let g:ale_linters = {
    \ 'python': ['flake8', 'pylint'],
    \ 'cpp': ['cppcheck', 'clangtidy']
    \ }

" Set line numbers
set number

