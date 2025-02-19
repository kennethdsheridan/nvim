-- Put this somewhere in your config (e.g., after/plugin/lsp_codelens.lua)
vim.cmd([[
  augroup LspCodeLens
    autocmd!
    autocmd BufEnter,CursorHold,InsertLeave *.rs lua vim.lsp.codelens.refresh()
  augroup END
]])
