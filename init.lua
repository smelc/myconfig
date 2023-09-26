local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

require("lazy").setup({
    "mfussenegger/nvim-jdtls",
    "joshdick/onedark.vim", -- onedark
    "EdenEast/nightfox.nvim", -- nightfox
    "tpope/vim-commentary", -- gc to comment a line
    "vim-airline/vim-airline", -- nice status bar
    "junegunn/fzf",

    "nvim-lua/plenary.nvim", -- for haskell-tools
    "nvim-telescope/telescope.nvim", -- for haskell-tools
    "mfussenegger/nvim-dap", -- for haskell-tools
    { "mrcjkb/haskell-tools.nvim", branch = "1.x.x" },

    "luc-tielen/telescope_hoogle",
    "nvim-treesitter/nvim-treesitter", -- recommended by haskell-tools

    "neovim/nvim-lspconfig",

    "BurntSushi/ripgrep", -- for telescope.nvim
})

require('nvim-treesitter.configs').setup {
    ensure_installed = "haskell", -- "all" or at least "haskell"
    highlight = {
        enable = true, -- important
    },
}

vim.cmd.colorscheme("nightfox")

-- https://neovim.io/doc/user/lua-guide.html#lua-guide-using-Lua

-- Change leader key to space
vim.g.mapleader = " "

-- https://neovim.io/doc/user/api.html#nvim_set_keymap()
vim.api.nvim_set_keymap('n', '<S-l>', "<cmd>:tabn<CR>", {})
vim.api.nvim_set_keymap('n', '<S-h>', "<cmd>:tabp<CR>", {})

-- Alias :FZF to Ctrl-P (vscode style)
-- vim.api.nvim_set_keymap('n', '<C-p>', "<cmd>:FZF<CR>", {})

local tb = require('telescope.builtin')
vim.keymap.set('n', '\\ff', tb.find_files, {})
vim.keymap.set('n', '\\fg', tb.live_grep, {})

-- vim.api.nvim_set_keymap('n', '<leader-g>', "<cmd>:Grepper -tool ag<CR>", {})

-- Do not autoreload files on change, ask for confirmation instead
vim.opt.autoread = false
-- Do not write .swp files, which I've never benefited of
vim.opt.swapfile = false
