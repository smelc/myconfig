-- OCaml: build with dune, wired into vim-dispatch's quickfix list.
--
-- Linked to from .config/nvim/after/ftplugin/ocaml.lua
--
-- Launch Neovim from the repo root (the dune-project directory) so dune's
-- repo-root-relative paths (e.g. code/src/sgc/foo.ml) resolve when you jump
-- from the quickfix list.

vim.opt_local.makeprg = "dune build"

-- Parse dune's OCaml diagnostics: a `File "...", line L, characters C-...:`
-- header (three shapes it emits) followed by the Error:/Warning: body.
vim.opt_local.errorformat = table.concat({
  [[%EFile "%f"\, line %l\, characters %c-%*[0-9]:]],
  [[%EFile "%f"\, line %l\, characters %c-%*[0-9] (end at line %*[0-9]\, character %*[0-9]):]],
  [[%EFile "%f"\, line %l:]],
  [[%C%m]],
  [[%Z]],
}, ",")

-- A bare :Dispatch builds the whole project (fast type-check-only pass).
vim.b.dispatch = "dune build @check"

-- Buffer-local keymaps (\ prefix, matching the rest of the config).
local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { buffer = true, desc = desc })
end
-- dune build all
map("\\da", "<cmd>Make @check<cr>", "dune: check the whole project (all errors -> quickfix)")
-- dune build package
map("\\dp", "<cmd>Make %:.:h<cr>", "dune: build this file's directory")
map("\\co", "<cmd>Copen<cr>", "open the dispatch quickfix window")
-- dune test package
map("\\dtp", "<cmd>Dispatch dune runtest %:.:h<cr>", "dune: run this file's directory tests")

-- switch interface: toggle between foo.ml and foo.mli
map("\\si", function()
  local file = vim.fn.expand("%:p")
  local other = file:match("%.mli$") and file:sub(1, -2) or file .. "i"
  vim.cmd.edit(vim.fn.fnameescape(other))
end, "ocaml: switch between .ml and .mli")
