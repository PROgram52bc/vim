-- Taken from https://github.com/Julian/lean.nvim/wiki/Getting-Started-From-the-Ground-Up

-- local cmp = require 'cmp'
-- cmp.setup{
--     mapping = cmp.mapping.preset.insert({
--       -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--       -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
--       -- ['<C-Space>'] = cmp.mapping.complete(),
--       ['<C-e>'] = cmp.mapping.abort(),
--       ['<CR>'] = cmp.mapping.confirm({ select = true }),
--     }),
--     sources = cmp.config.sources({
--       { name = 'nvim_lsp' },
--       { name = 'path' },
--       { name = 'buffer' },
--     })
-- }

local function on_attach(_, bufnr)
    local function cmd(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, buffer = true })
    end

    -- Autocomplete using the Lean language server
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Support for triggering code actions (e.g. "Try this:" suggestions from `simp?`)
    cmd('n', '<leader>a', vim.lsp.buf.code_action)
    cmd('i', '<C-a>', vim.lsp.buf.code_action)

    -- <leader>n will jump to the next Lean line with a diagnostic message on it
    -- <leader>N will jump backwards
    cmd('n', '<leader>n', function() vim.diagnostic.goto_next{popup_opts = {show_header = false}} end)
    cmd('n', '<leader>N', function() vim.diagnostic.goto_prev{popup_opts = {show_header = false}} end)

    -- <leader>K will show all diagnostics for the current line in a popup window
    cmd('n', '<leader>K', function() vim.diagnostic.open_float(0, { scope = "line", header = false, focus = false }) end)

    -- <leader>q will load all errors in the current lean file into the location list
    -- (and then will open the location list)
    -- see :h location-list if you don't generally use it in other vim contexts
    cmd('n', '<leader>q', vim.diagnostic.setloclist)
end

require('lean').setup{
  -- Enable the Lean language server(s)?
  --
  -- false to disable, otherwise should be a table of options to pass to `leanls`
  -- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#leanls for details.
  lsp = {
    on_attach = on_attach,
    init_options = {
      -- See Lean.Lsp.InitializationOptions for details and further options.

      -- Time (in milliseconds) which must pass since latest edit until elaboration begins.
      -- Lower values may make editing feel faster at the cost of higher CPU usage.
      -- Note that lean.nvim changes the Lean default for this value!
      editDelay = 0,

      -- Whether to signal that widgets are supported.
      -- Enabled by default, as support for most widgets is implemented in lean.nvim.
      hasWidgets = true,
    }
  },

  ft = {
    -- A list of patterns which will be used to protect any matching
    -- Lean file paths from being accidentally modified (by marking the
    -- buffer as `nomodifiable`).
    nomodifiable = {
        -- by default, this list includes the Lean standard libraries,
        -- as well as files within dependency directories (e.g. `_target`)
        -- Set this to an empty table to disable.
    }
  },

  -- Abbreviation support
  abbreviations = {
    -- Enable expanding of unicode abbreviations?
    enable = true,
    -- additional abbreviations:
    extra = {
      -- Add a \wknight abbreviation to insert ♘
      --
      -- Note that the backslash is implied, and that you of
      -- course may also use a snippet engine directly to do
      -- this if so desired.
      wknight = '♘',
    },
    -- Change if you don't like the backslash
    -- (comma is a popular choice on French keyboards)
    leader = '\\',
  },

  -- Enable suggested mappings?
  --
  -- false by default, true to enable
  mappings = false,

  -- Infoview support
  infoview = {
    -- Automatically open an infoview on entering a Lean buffer?
    -- Should be a function that will be called anytime a new Lean file
    -- is opened. Return true to open an infoview, otherwise false.
    -- Setting this to `true` is the same as `function() return true end`,
    -- i.e. autoopen for any Lean file, or setting it to `false` is the
    -- same as `function() return false end`, i.e. never autoopen.
    autoopen = true,

    -- Set infoview windows' starting dimensions.
    -- Windows are opened horizontally or vertically depending on spacing.
    width = 50,
    height = 20,

    -- Put the infoview on the top or bottom when horizontal?
    -- top | bottom
    horizontal_position = "bottom",

    -- Always open the infoview window in a separate tabpage.
    -- Might be useful if you are using a screen reader and don't want too
    -- many dynamic updates in the terminal at the same time.
    -- Note that `height` and `width` will be ignored in this case.
    separate_tab = false,

    -- Show indicators for pin locations when entering an infoview window?
    -- always | never | auto (= only when there are multiple pins)
    indicators = "auto",
  },

  -- Progress bar support
  progress_bars = {
    -- Enable the progress bars?
    enable = true,
    -- What character should be used for the bars?
    character = '│',
    -- Use a different priority for the signs
    priority = 10,
  },

  -- Redirect Lean's stderr messages somehwere (to a buffer by default)
  stderr = {
    enable = true,
    -- height of the window
    height = 5,
    -- a callback which will be called with (multi-line) stderr output
    -- e.g., use:
    --   on_lines = function(lines) vim.notify(lines) end
    -- if you want to redirect stderr to `vim.notify`.
    -- The default implementation will redirect to a dedicated stderr
    -- window.
    on_lines = nil,
  },
}
