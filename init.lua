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
    "vim-airline/vim-airline"
})

vim.cmd.colorscheme("onedark")

vim.keymap.set('n', '<Shift>-l', "<cmd>tabn<cr>")
vim.keymap.set('n', '<Shift>-h', "<cmd>tabp<cr>")

-- Do not autoreload files on change, ask for confirmation instead
vim.opt.autoread = false
-- Do not write .swp files, which I've never benefited of
vim.opt.swapfile = false
