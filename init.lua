require('packer').startup(function(use)
  use("wbthomason/packer.nvim")

  use('psliwka/vim-smoothie') -- smooth scrolling when using <C-d> and <C-u>
  use({ 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { {'nvim-lua/plenary.nvim'} } })
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
  use("romgrk/nvim-treesitter-context") -- show sticky context lines add the top of the buffer
  use({'dracula/vim', as = 'dracula'}) -- vim theme
  use('farmergreg/vim-lastplace') -- restore last position when opening a buffer
  use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }})
  use('neovim/nvim-lspconfig') -- default configuration for most LSP servers
  use('kylechui/nvim-surround') -- adds some motions to work with parenthesis, quotes, brackets etc.
  use('tpope/vim-fugitive') -- git wrapper to use git from within vim
  use('airblade/vim-gitgutter') -- show git diff information in the sign column
  use('numToStr/Comment.nvim') -- add/toggle comments
  use({"NTBBloodbath/rest.nvim", requires = { "nvim-lua/plenary.nvim" }}) -- REST client for http files

  -- autocompletion
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-nvim-lua')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-cmdline')
  use('hrsh7th/cmp-vsnip')
  use('hrsh7th/vim-vsnip')
end)

-- theme configuration
vim.opt.termguicolors = true
vim.g.dracula_colorterm = false
vim.cmd[[colorscheme dracula]]

-- use 2 spaces for tabs
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 2 -- Number of insterted spaces when <TAB> or <Bs> are used
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Expend tabs to spaces

-- hybrid line numbers (absolute line number for the current line and relative for the others)
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Misc
vim.opt.hlsearch = false -- Do not highlight search matches
vim.opt.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor
vim.opt.swapfile = false -- Do not use swapfiles
vim.opt.updatetime = 100 -- update gitgutter info every 100ms

vim.g.mapleader = " "

vim.keymap.set('i', 'kj', '<ESC>') -- When in insert mode, type kj instead of <ESC> to go back to normal mode

 -- Some azerty fixes
vim.keymap.set('n', ';', '.')
vim.keymap.set('n', '.', ';')
vim.keymap.set({'n', 'v', 'o'}, 'm', '$')
vim.keymap.set({'n', 'v', 'o'}, 'é', '^')
vim.keymap.set({'n', 'v', 'o'}, 'à', '}')
vim.keymap.set({'n', 'v', 'o'}, 'ç', '{')
vim.keymap.set('n', '<C-ù>', '<C-]>')

-- Move between buffers using Ctrl-[h-l]
vim.keymap.set('n', '<C-h>', ':bp<CR>')
vim.keymap.set('n', '<C-l>', ':bn<CR>')

local kimlai = vim.api.nvim_create_augroup('kimlai', {})
-- Remove trailing spaces on save
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  group = kimlai,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})
-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = kimlai,
  pattern = "*",
  command = 'lua vim.lsp.buf.formatting_sync()',
})

-- highlight yanked texted
local yank = vim.api.nvim_create_augroup('yank', {})
vim.api.nvim_create_autocmd('TextYankPost', {
    group = yank,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 60,
        })
    end,
})

-- Misc plugins setup
require('Comment').setup()
require('treesitter-context').setup({ max_lines = -1 }) -- unlimited context lines
require('lspconfig').tsserver.setup({}) -- javascript LSP support
require('nvim-treesitter.configs').setup({ highlight = { enable = true } }) -- better syntax highlighting
require('rest-nvim').setup()
require('nvim-surround').setup()

-- Telescope mappings
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope grep_string<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n', '<leader>fR', '<cmd>Telescope lsp_references<cr>')
vim.keymap.set('n', '<leader>fi', '<cmd>Telescope lsp_implementations<cr>')
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope lsp_definitions<cr>')
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope commands<cr>')
require('telescope').setup({
  defaults = {
    path_display = function(opts, path)
      local substitutions = {
        ["scala/com/bestmile"] = "s/c/bm",
        ["resources/com/bestmile"] = "r/c/bm",
        ["infrastructure"] = "infra",
      }
      for k,v in pairs(substitutions) do
        path = string.gsub(path, k, v)
      end
      return path
    end,
    mappings = {
      i = {
        ["<C-k>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
      },
      n = {
        ["kj"] = "close"
      },
    }
  }
})

-- LSP mappings
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

------------------------------
-- Scala support using metals
------------------------------
vim.opt_global.shortmess:remove("F"):append("c")

metals = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach({ metals_config })
  end,
  group = metals,
})

-------------------------------------------------------------------------------------------------
-- status line
-- https://unix.stackexchange.com/questions/224771/what-is-the-format-of-the-default-statusline
-------------------------------------------------------------------------------------------------

local function metals_status()
  return vim.g["metals_status"] or ""
end

local function fugitive_status()
  local _, _, fugitive_status =  string.find(vim.api.nvim_eval('FugitiveStatusline()'), '%[Git%((.+)%)%]')
  return fugitive_status or ''
end

function status_line()
  return table.concat({
    '%1* ' .. fugitive_status() .. ' %* ',
    '%f ', -- buffer name (path to a file, or something)
    '%h', -- help flag
    '%w', -- preview flag
    '%m', -- modified flag
    '%r', -- readonly flag
    metals_status(),
    '%=', -- separator between the left and the right parts
    '%y ', -- filetype
    '%l,%c', -- line,column
    '%V ', -- virtual column
    '%p%%' -- percentage
  })
end

vim.opt.statusline = "%!luaeval('status_line()')"
-- those colors are hardcoded from the Dracula theme
vim.cmd[[highlight StatusLine guibg=#282A36 guifg=#6272A4]]
vim.cmd[[highlight StatusLineNC guibg=#282A36 guifg=#6272A4]]
vim.cmd[[highlight User1 guibg=#6272A4]]

vim.keymap.set('n', '<leader>fd', '<cmd>lua vim.lsp.buf.definition()<cr>')
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

----------------------------------
-- autocompletion using nvim-cmp
----------------------------------
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer', keyword_length = 3 },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  experimental = {
    ghost_text = true
  }
})

vim.keymap.set('n', '<leader>rh', '<Plug>RestNvim')
