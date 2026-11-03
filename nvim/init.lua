-- Options
vim.opt.number = true
vim.opt.relativenumber = true

-- Terminal mode: jump between windows with Ctrl+h/j/k/l
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- Plugins (vim-plug)
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug('nvim-treesitter/nvim-treesitter', { ['branch'] = 'master', ['do'] = ':TSUpdate' })
Plug('windwp/nvim-autopairs')
vim.call('plug#end')

-- Plugin setup (skipped quietly if a plugin isn't installed yet)
local ok, ts = pcall(require, 'nvim-treesitter.configs')
if ok then
  ts.setup {
    ensure_installed = { 'python', 'javascript', 'html', 'rust' },
    highlight = { enable = true },
  }
end

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
})
vim.lsp.enable('rust_analyzer')

local ok2, autopairs = pcall(require, 'nvim-autopairs')
if ok2 then
  autopairs.setup {}
end
