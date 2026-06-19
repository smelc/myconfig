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
    "tpope/vim-fugitive", -- https://github.com/tpope/vim-fugitive
    "tpope/vim-commentary", -- gc to comment a line
    "vim-airline/vim-airline", -- nice status bar
    "junegunn/fzf",

    "nvim-lua/plenary.nvim", -- for haskell-tools
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap", -- for haskell-tools
    {
      "ndmitchell/ghcid",
      config = function(plugin)
        vim.opt.rtp:append(plugin.dir .. "/plugins/nvim")
      end,
    },

    -- "luc-tielen/telescope_hoogle", I don't use it

    "neovim/nvim-lspconfig",

    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main", -- main supports Neovim 0.12; master is legacy (older Neovim only)
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").install({
          "bash", "lua", "ocaml", "ocaml_interface", "haskell",
          "sql", "json", "yaml", "markdown", "markdown_inline",
          "dockerfile", "vim", "vimdoc",
        })
        -- The main branch does not auto-enable highlighting; start it per buffer.
        -- pcall guards filetypes that have no installed parser.
        vim.api.nvim_create_autocmd("FileType", {
          callback = function(args)
            pcall(vim.treesitter.start, args.buf)
          end,
        })
      end,
    },

    "BurntSushi/ripgrep", -- for telescope.nvim

    "simrat39/symbols-outline.nvim"
})

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
-- \fg in VISUAL mode: open live_grep prefilled with the current selection
vim.keymap.set('x', '\\fg', function()
  local sel = table.concat(
    vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = vim.fn.mode() }),
    '\n'
  )
  tb.live_grep({ default_text = sel })
end, {})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ocamllsp
-- LSP keybindings (active when a language server attaches)
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  -- Tab-like completion: cycle the popup menu when visible, plain <Tab> otherwise
  vim.keymap.set('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
  end, { buffer = bufnr, expr = true })
  vim.keymap.set('i', '<S-Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
  end, { buffer = bufnr, expr = true })
  -- <C-Space> triggers LSP omni-completion (same as <C-x><C-o>).
  -- Many terminals send <C-Space> as <C-@>/<Nul>, so map both.
  vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { buffer = bufnr })
  vim.keymap.set('i', '<C-@>', '<C-x><C-o>', { buffer = bufnr })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- go to definition
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- hover documentation
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- find references
  vim.keymap.set('n', '\\rn', vim.lsp.buf.rename, opts) -- <space>rn renames symbol
  vim.keymap.set('n', '\\ca', vim.lsp.buf.code_action, opts) -- <space>ca code-action (quickfixes)
  vim.keymap.set('n', '\\t', vim.lsp.buf.type_definition, opts) -- <space>t show type definition
  vim.keymap.set('n', '\\nf', function() vim.lsp.buf.format() end, opts) -- \nf format buffer via LSP
end

vim.lsp.config('ocamllsp', { on_attach = on_attach })
vim.lsp.enable('ocamllsp')

vim.diagnostic.config({ virtual_text = true })

-- vim.api.nvim_set_keymap('n', '<leader-g>', "<cmd>:Grepper -tool ag<CR>", {})

-- Do not autoreload files on change, ask for confirmation instead
vim.opt.autoread = false
-- Do not write .swp files, which I've never benefited of
vim.opt.swapfile = false
-- Overwrite files in place on save (preserve inode) so single-file bind mounts
-- in the devcontainer reflect host edits live
vim.opt.backupcopy = "yes"
-- Insert spaces instead of tabs
vim.opt.expandtab = true
