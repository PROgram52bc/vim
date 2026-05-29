-- LSP go-to mappings under the `go*` prefix.
-- Buffer-local: only active in buffers with an LSP attached.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local function map(lhs, fn, desc)
      vim.keymap.set("n", lhs, fn, { buffer = args.buf, silent = true, desc = desc })
    end
    map("god", vim.lsp.buf.definition,     "Go to definition")
    map("gor", vim.lsp.buf.references,     "Go to references")
    map("goi", vim.lsp.buf.implementation, "Go to implementation")
  end,
})
