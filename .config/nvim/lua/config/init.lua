require("config.lazy")

-- Remaps
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.g.netrw_banner = 0             -- Disable the banner

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })

-- LSP
-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

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
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
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

-- Close the floating windows on escape or mini.files
vim.keymap.set("n", "<esc>", function()
    -- Check if mini.files is active
    local ok, mini_files = pcall(require, "mini.files")
    if ok and mini_files.is_open then
        mini_files.close() -- Close mini.files if it's open
    else
        -- Close floating windows
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative ~= "" then
                vim.api.nvim_win_close(win, false)
            end
        end
    end
end)

-- Setup LSPs
require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = { "omnisharp", "clangd", "pyright", "hls" },
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
