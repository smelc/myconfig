local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- https://github.com/folke/lazy.nvim
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Change leader key to space
vim.g.mapleader = " "

require("lazy").setup({
    "joshdick/onedark.vim", -- onedark
    "tpope/vim-commentary", -- gc to comment a line
    "vim-airline/vim-airline",

    "nvim-lua/plenary.nvim", -- for haskell-tools
    "nvim-telescope/telescope.nvim", -- for haskell-tools
    "mfussenegger/nvim-dap", -- for haskell-tools
    { "mrcjkb/haskell-tools.nvim", branch = "1.x.x" },

    "neovim/nvim-lspconfig",
})

vim.cmd.colorscheme("onedark")

-- https://neovim.io/doc/user/lua-guide.html#lua-guide-using-Lua

-- https://neovim.io/doc/user/api.html#nvim_set_keymap()
vim.api.nvim_set_keymap('n', '<S-l>', "<cmd>:tabn<CR>", {})
vim.api.nvim_set_keymap('n', '<S-h>', "<cmd>:tabp<CR>", {})

-- Reload config file
vim.api.nvim_set_keymap('n', '<Leader><Leader>', ":source $MYVIMRC<CR>", {})

-- Do not autoreload files on change, ask for confirmation instead
vim.opt.autoread = false
-- Do not write .swp files, which I've never benefited of
vim.opt.swapfile = false

-- LSP configuration, from https://github.com/neovim/nvim-lspconfig#suggested-configuration
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
