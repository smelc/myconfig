-- Linked to from .config/nvim/ftplugin/haskell.lua
--
-- From Mateuzs:
-- https://gist.github.com/carbolymer/f0e10a3bbd07a022f8eccf1c52e65356

local telescope = require 'telescope'
telescope.load_extension('hoogle')

local tb = require 'telescope.builtin'
local ht = require('haskell-tools')

local def_opts = { noremap = true, silent = true, }
ht.start_or_attach {
  hls = {
    on_attach = function(client, bufnr)
      -- local_on_attach(client, bufnr)
      local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr, })
      -- haskell-language-server relies heavily on codeLenses,
      -- so auto-refresh (see advanced configuration) is enabled by default
      vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)
      -- vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, bufopts) Doesn't work :-(
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)

      vim.keymap.set('n', '<leader>go', tb.lsp_outgoing_calls, bufopts)
      vim.keymap.set('n', '<leader>gi', tb.lsp_incoming_calls, bufopts)
      vim.keymap.set('n', '<leader>rf', tb.lsp_references, bufopts)
      vim.keymap.set('n', '<leader>ad',  tb.diagnostics)

      -- vscode style
      vim.keymap.set('n', '<F8>', vim.diagnostic.goto_next, bufopts)
      vim.keymap.set('n', '<Shift-F8>', vim.diagnostic.goto_prev, bufopts)
      vim.keymap.set('n', '<F12>', tb.lsp_definitions, bufopts)

      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

      -- haskell-tools specific
      vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
      -- vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
    end,
    cmd = { 'haskell-language-server', '--lsp' },
    default_settings = {
      formattingProvider = "stylish",
    },
  },
}

-- Suggested keymaps that do not depend on haskell-language-server:
local bufnr = vim.api.nvim_get_current_buf()
-- set buffer = bufnr in ftplugin/haskell.lua
local opts = { noremap = true, silent = true, buffer = bufnr }

-- Toggle a GHCi repl for the current package
vim.keymap.set('n', '<leader>rp', ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set('n', '<leader>rb', function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, def_opts)
-- Quit repl
vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)

-- Detect nvim-dap launch configurations
-- (requires nvim-dap and haskell-debug-adapter)
ht.dap.discover_configurations(bufnr)
