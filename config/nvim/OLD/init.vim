call plug#begin('~/.vim/plugged')

" Syntax Highlighting and linting
Plug 'dense-analysis/ale'
Plug 'norcalli/nvim-colorizer.lua'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'neovim/nvim-lspconfig'

" Commenting
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdcommenter'
call plug#end()

" Save and restore cursor position when reopening a file
augroup remember_cursor_position
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" ALE config
let g:ale_enabled = 1
let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_linters['asm'] = []
let g:ale_linters_explicit = 1

" neovim config
set number
set linebreak
set scrolloff=15
set termguicolors
set shiftwidth=4
set expandtab
autocmd VimEnter * echo "I use Arch BTW"
filetype plugin on
colorscheme habamax

" lua scripts
lua << EOF
local nvim_lsp = require('lspconfig')
local cmp = require('cmp')
require'colorizer'.setup()

cmp.setup(
{
  snippet = 
  {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = 
  {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = 
  {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }
})

-- Setup LSP servers
local servers = { 'pyright', 'tsserver', 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup 
  {
    on_attach = on_attach,
    flags = 
    {
      debounce_text_changes = 150,
    }
  }
end
EOF

nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ; l

vnoremap j h
vnoremap k j
vnoremap l k
vnoremap ; l

onoremap j h
onoremap k j
onoremap l k
onoremap ; l

let g:ale_linters = {
    \ 'python': ['flake8', 'pylint'],
    \ 'cpp': ['cppcheck', 'clangtidy']
    \ }
