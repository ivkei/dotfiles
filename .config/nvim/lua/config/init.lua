require("config.lazy")

-- Remaps
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.g.netrw_banner = 0             -- Disable the banner

-- LSP
-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

--Folds
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = { "*" },
  callback = function()
    vim.opt.foldlevel=99
    vim.opt.foldlevelstart=99
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
    vim.opt.number = true
    vim.opt.foldcolumn = "0"
    vim.opt.foldopen = "undo,tag"
    -- Close all folds without touching foldlevel
    vim.keymap.set("n", "zM", ":%foldclose<CR>", { silent = true, desc = "Fold everything without changing foldlevel" })
  end
})

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- Snippets
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
	mapping = {
		['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		['<C-Space>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
	},
})

-- Enable error descriptions to the right of the text in buffer
vim.diagnostic.config({
  virtual_text = {
    prefix = '⚙', -- Icon or symbol to show before the text (optional)
    spacing = 16,  -- Space between the line and virtual text
  },
  signs = true, -- Show signs in the gutter
  underline = true, -- Underline errors in the code
  update_in_insert = true, -- Update diagnostics while in insert mode
  float = {
    border = "rounded", -- Rounded border for the floating window
    source = "always",  -- Show the source of the diagnostic
    header = "",        -- Optional header
    prefix = "",        -- Optional prefix
  },
})

-- Go to error descriptions
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap = true, silent = true })

-- Setup LSPs
require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = { "clangd", "pyright", "hls" },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  }
})

--Format
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set({'n', 'x'}, 'gq', function()
      vim.lsp.buf.format({async = false, timeout_ms = 10000})
    end, opts)
  end
})

--Disable auto comment on next line
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

--Inlay hints
vim.keymap.set('n', '<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)
