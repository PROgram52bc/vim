require("lean").setup({ mappings = true })

-- [d / ]d (Neovim defaults) jump to all diagnostics including warnings.
-- Add [e / ]e to jump only between errors.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lean",
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }
    vim.keymap.set("n", "]e", function()
      vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
    end, vim.tbl_extend("force", opts, { desc = "Next error" }))
    vim.keymap.set("n", "[e", function()
      vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
    end, vim.tbl_extend("force", opts, { desc = "Previous error" }))
  end,
})
