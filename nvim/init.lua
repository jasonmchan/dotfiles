vim.fn['plug#begin'](vim.fn.stdpath('data') .. '/plugged')

local plug = vim.fn['plug#']
plug('nvim-treesitter/nvim-treesitter', { ['do'] = 'TSUpdate' })
plug('neovim/nvim-lspconfig')
plug('nvim-lua/plenary.nvim')
plug('nvim-telescope/telescope.nvim')
plug('hrsh7th/nvim-cmp')
plug('hrsh7th/vim-vsnip')
plug('hrsh7th/cmp-nvim-lsp')
plug('windwp/nvim-autopairs')
plug('lewis6991/gitsigns.nvim')
plug('rhysd/conflict-marker.vim')
plug('ruifm/gitlinker.nvim')

vim.fn['plug#end']()

vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:2'
vim.opt.clipboard:append('unnamedplus')
vim.opt.expandtab = true
vim.opt.foldenable = false
vim.opt.gdefault = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.laststatus = 0
vim.opt.mouse = 'a'
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.shortmess:append('c')
vim.opt.showbreak = '\226\134\179'
vim.opt.showmatch = true
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = -1
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true

vim.g.mapleader = ' '
vim.g.netrw_banner = 0
vim.g.tex_flavor = 'latex'

vim.cmd('colorscheme paper')

local group = vim.api.nvim_create_augroup('settings', {})

vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  callback = function()
    vim.cmd('checktime')
  end,
  group = group,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  callback = function()
    vim.notify(vim.fn.expand('%:t'))
  end,
  group = group,
})

vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = group,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'go', 'tex' },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
  group = group,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'markdown', 'tex' },
  callback = function()
    vim.bo.textwidth = 80
  end,
  group = group,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit' },
  callback = function()
    vim.bo.textwidth = 72
  end,
  group = group,
})

require('nvim-autopairs').setup({
  disable_filetype = { 'TelescopePrompt', 'tex' },
})

require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  ignore_install = { 'phpdoc' },
  highlight = { enable = true, disable = { 'cpp' } },
  indent = { enable = true },
})

require('gitlinker').setup({
  mappings = '<leader>l',
})

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      return vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  },
  sources = { { name = 'nvim_lsp' } },
  window = {
    documentation = cmp.config.window.bordered(),
  },
})

local gitsigns = require('gitsigns')
gitsigns.setup()
vim.keymap.set('n', ']c', gitsigns.next_hunk)
vim.keymap.set('n', '[c', gitsigns.prev_hunk)
vim.keymap.set({ 'n', 'v' }, '<leader>hs', gitsigns.stage_hunk)
vim.keymap.set({ 'n', 'v' }, '<leader>hr', gitsigns.reset_hunk)
vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer)
vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk)
vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer)
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk)
vim.keymap.set('n', '<leader>hb', gitsigns.blame_line)
vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk)

require('telescope').setup({
  defaults = require('telescope.themes').get_ivy({ previewer = false }),
  pickers = {
    buffers = { initial_mode = 'normal', sort_mru = true },
    resume = { initial_mode = 'normal' },
    git_status = { initial_mode = 'normal' },
  },
})

local pickers = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', pickers.builtin)
vim.keymap.set('n', '<leader>f', pickers.find_files)
vim.keymap.set('n', '<leader>a', pickers.git_files)
vim.keymap.set('n', '<leader>s', pickers.git_status)
vim.keymap.set('n', '<leader>g', pickers.live_grep)
vim.keymap.set('n', '<leader>t', pickers.treesitter)
vim.keymap.set('n', '<leader>;', pickers.buffers)
vim.keymap.set('n', "<leader>'", pickers.resume)
vim.keymap.set('n', '<leader>w', pickers.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', 'gr', pickers.lsp_references)
vim.keymap.set('n', 'gm', pickers.lsp_implementations)

local s = {}

s.on_attach = function(client, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'g=', vim.lsp.buf.formatting, opts)
  if client.name == 'clangd' then
    vim.keymap.set('n', 'gs', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
  end
end

s.capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

s.settings = {
  texlab = {
    build = {
      onSave = true,
      args = {
        '-pdf',
        '-output-directory=out',
        '-interaction=nonstopmode',
        '-synctex=1',
        '%f',
      },
    },
    chktex = { onOpenAndSave = true, onEdit = true },
  },
}

local lspconfig = require('lspconfig')
lspconfig.clangd.setup(s)
lspconfig.gopls.setup(s)
lspconfig.pyright.setup(s)
lspconfig.texlab.setup(s)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)

vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float({ border = 'rounded' })
end)

vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev({ float = { border = 'rounded' } })
end)

vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next({ float = { border = 'rounded' } })
end)

local diagnostics_state = true
vim.keymap.set('n', '<leader>i', function()
  if diagnostics_state then
    vim.diagnostic.disable()
    diagnostics_state = false
  else
    vim.diagnostic.enable()
    diagnostics_state = true
  end
end)

vim.keymap.set('n', 'ga', '<cmd>b#<cr>', { silent = true })
