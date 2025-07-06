-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    --{ import = "plugins" },
    {
	    "folke/tokyonight.nvim",
	    lazy = false,
	    priority = 1000,
	    opts = {},
    },
    {
	    'nvim-telescope/telescope.nvim', tag = '0.1.8',
	    -- or                              , branch = '0.1.x',
	    dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
	    "nvim-treesitter/nvim-treesitter",
	    build = ":TSUpdate",
	    config = function () 
		    local configs = require("nvim-treesitter.configs")

		    configs.setup({
			    ensure_installed = { "c", "lua", "cpp", "c_sharp", "python", "haskell", "glsl", "cmake", "markdown" },
			    sync_install = false,
			    highlight = { enable = true },
			    indent = { enable = true },  
		    })
	    end
    },
    {
      "neovim/nvim-lspconfig", 
    },
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {
    	"williamboman/mason.nvim",
    	"williamboman/mason-lspconfig.nvim",
    	"neovim/nvim-lspconfig",
    },
    { 'echasnovski/mini.files', version = '*' },
    { 'echasnovski/mini.icons', version = '*' },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false },
})

require('mini.files').setup({
  -- Customization of shown content
  content = {
    -- Predicate for which file system entries to show
    filter = nil,
    -- What prefix to show to the left of file system entry
    prefix = nil,
    -- In which order to show file system entries
    sort = nil,
  },

  -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = false,
    -- Whether to use for editing directories
    use_as_default_explorer = false,
  },

  -- Customization of explorer windows
  windows = {
    max_number = 3,
    preview = false,
    width_focus = 30,
    width_nofocus = 20,
    side = 'left',
  },
})
vim.keymap.set('n', '<leader>mf', function()
  require('mini.files').open()
end, { desc = 'Open mini.files' })

require('mini.icons').setup()

-- Colorscheme
vim.cmd.colorscheme "tokyonight-night"

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = auto,
    --component_separators = { left = '', right = ''},
    component_separators = { left = '|', right = '||'},
    --section_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    --lualine_a = {'mode'},
    lualine_a = {},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        "filename",
        file_status = true,
        path = 1,
        shorting_target = 0,
      }
    },
    --lualine_x = {'encoding'},
    --lualine_y = {'location'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
    --lualine_z = {
    --  {
    --    function()
    --      return os.date("%I:%M:%S")
    --    end,
    --    --color = { fg = "#FFFFFF", bg = nil },
    --    --separator = '',
    --    --padding = 0,
    --  }
    --},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    --lualine_x = {'location'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

--Set indent size of enter
-- Set up the autocommand using Treesitter for detection
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
      vim.bo.expandtab = true
    end
})
