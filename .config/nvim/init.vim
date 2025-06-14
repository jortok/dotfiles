" =============================================================================
" # NEOVIM CONFIGURATION - MODO DIOS
" =============================================================================

" -----------------------------------------------------------------------------
" # LEADER & GLOBAL SHORTCUTS
" -----------------------------------------------------------------------------
let mapleader =","
map ,, :keepp /<++><CR>ca<
imap ,, <esc>:keepp /<++><CR>ca<

" -----------------------------------------------------------------------------
" # PLUGIN MANAGER (VIM-PLUG)
" -----------------------------------------------------------------------------
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

" --- Core Functionality ---
Plug 'tpope/vim-surround'
Plug 'junegunn/goyo.vim'
Plug 'TimUntersberger/neogit' " Replaces vimagit

" --- UI & Colorscheme ---
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lewis6991/gitsigns.nvim'

" --- Development & Syntax ---
Plug 'numToStr/Comment.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'norcalli/nvim-colorizer.lua'

" --- Fuzzy Finder (Telescope) ---
Plug 'nvim-lua/plenary.nvim' " Dependency for Telescope and others
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

" --- LSP & Autocompletion ---
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" --- AI Assistant ---
Plug 'MunifTanjim/nui.nvim' " Dependency for ChatGPT
Plug 'jackMort/ChatGPT.nvim'

call plug#end()


" -----------------------------------------------------------------------------
" # CORE OPTIONS
" -----------------------------------------------------------------------------
filetype plugin on
syntax on
set encoding=utf-8
set title
set mouse=a
set clipboard+=unnamedplus " Requires `xclip` on Arch Linux
set splitbelow splitright
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" -----------------------------------------------------------------------------
" # UI SETTINGS
" -----------------------------------------------------------------------------
set termguicolors
set background=dark

set number relativenumber
set nohlsearch
set wildmode=longest,list,full

set noshowmode
set noruler
set laststatus=0
set noshowcmd

" -----------------------------------------------------------------------------
" # KEY MAPPINGS
" -----------------------------------------------------------------------------
" Split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" --- Telescope (Fuzzy Finder) ---
" Find files in your project
map <leader>ff <cmd>Telescope find_files<cr>
" Grep for a string in your project
map <leader>fg <cmd>Telescope live_grep<cr>
" List open buffers
map <leader>fb <cmd>Telescope buffers<cr>
" Search help tags
map <leader>fh <cmd>Telescope help_tags<cr>

" --- Neogit ---
" Open the Git TUI
map <leader>gg <cmd>Neogit<cr>

" --- Other Tools ---
map <leader>n :NvimTreeToggle<CR>
map <leader>f :Goyo<CR>
map <leader>o :setlocal spell! spelllang=en_us<CR>
map <leader>v :VimwikiIndex<CR>
map <leader>s :!clear && shellcheck -x %<CR>
map <leader>b :vsp<space>$BIB<CR>
map <leader>r :vsp<space>$REFER<CR>
map <leader>c :w! \| !compiler "%:p"<CR>
map <leader>p :!opout "%:p"<CR>
nnoremap S :%s//g<Left><Left>
map Q gq

" -----------------------------------------------------------------------------
" # PLUGIN CONFIGURATION
" -----------------------------------------------------------------------------

" --- Catppuccin Colorscheme ---
lua << EOF
require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
    integrations = {
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        mason = true,
        telescope = true,
    }
})
EOF

" --- Telescope ---
lua << EOF
require('telescope').setup({
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'top',
    },
  },
})
EOF

" --- Neogit ---
lua << EOF
require('neogit').setup({})
EOF

" --- ChatGPT ---
lua << EOF
require('chatgpt').setup({
  -- Tip: For a more robust setup, set an environment variable
  -- instead of using a file. In your .zshrc or .bashrc add:
  -- export OPENAI_API_KEY="your_key_here"
  -- The plugin will pick it up automatically.
  -- api_key_cmd = "cat ~/.config/openai_api_key",
})
EOF

" --- gitsigns ---
lua << EOF
require('gitsigns').setup()
EOF

" --- nvim-tree ---
lua << EOF
require("nvim-tree").setup({ disable_netrw = true, hijack_netrw = true, view = { width = 30, side = "left" }, renderer = { group_empty = true, icons = { show = { file = true, folder = true, folder_arrow = true, git = true }}}, git = { enable = true, ignore = false }})
EOF

" --- lualine ---
lua << EOF
require('lualine').setup { options = { theme = 'auto', component_separators = { left = '', right = ''}, section_separators = { left = '', right = ''}, disabled_filetypes = { 'NvimTree' }}}
EOF

" --- nvim-treesitter ---
lua << EOF
require'nvim-treesitter.configs'.setup { ensure_installed = { "bash", "c", "cpp", "css", "html", "javascript", "json", "latex", "lua", "markdown", "markdown_inline", "python", "vim", "vimdoc" }, highlight = { enable = true }, indent = { enable = true }}
EOF

" --- Comment.nvim ---
lua << EOF
require('Comment').setup()
EOF

" --- nvim-colorizer ---
lua << EOF
require('colorizer').setup()
EOF

" --- Mason & LSP Config (RESTRUCTURED AND FIXED) ---
lua << EOF
-- Step 1: Setup Mason
require("mason").setup({ ui = { border = "rounded", width = 0.8, height = 0.8 }})

-- Step 2: Tell mason-lspconfig which servers to install
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls", "bashls", "pyright", "ts_ls", "cssls",
    "html", "jsonls", "clangd", "texlab", "marksman"
  }
})

-- Step 3: Setup lspconfig separately for each server
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
  local map = vim.keymap.set
  local opts = { noremap=true, silent=true, buffer=bufnr }
  map('n', 'K', vim.lsp.buf.hover, opts)
  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
  map('n', '<leader>e', vim.diagnostic.open_float, opts)
end

-- List of servers to configure
local servers = { "lua_ls", "bashls", "pyright", "ts_ls", "cssls", "html", "jsonls", "clangd", "texlab", "marksman" }

-- Loop through the servers and setup each one
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
EOF

" --- nvim-cmp Autocompletion ---
lua << EOF
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})
EOF

" --- vimwiki ---
let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

" -----------------------------------------------------------------------------
" # AUTOCOMMANDS & FUNCTIONS
" -----------------------------------------------------------------------------
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
autocmd VimLeave *.tex !latexmk -c %
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePost * call cursor(currPos[1], currPos[2])
autocmd BufWritePost bm-files,bm-dirs !shortcuts
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }
cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
silent! source ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/shortcuts.vim
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1; set noshowmode; set noruler; set laststatus=0; set noshowcmd
    else
        let s:hidden_all = 0; set showmode; set ruler; set laststatus=2; set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>
autocmd VimEnter * silent! colorscheme catppuccin-mocha
