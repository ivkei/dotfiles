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
	    end,
    },
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {
    	"williamboman/mason.nvim",
    	"williamboman/mason-lspconfig.nvim",
    },
    {
    	"neovim/nvim-lspconfig",
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    { 'echasnovski/mini.files', version = '*' },
    { 'echasnovski/mini.icons', version = '*' },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false },
})

-- Colorscheme
vim.cmd.colorscheme "retrobox"

require('mini.files').setup()
vim.keymap.set('n', '<leader>mf', function()
  require('mini.files').open()
end, { desc = 'Open mini.files' })

require('mini.icons').setup()

local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)
local colors = {
  --BG = '#16181b', -- Dark background
  BG = string.format("#%06x", normal_hl.background or 0x000000),
  --FG = '#c5c4c4', -- Light foreground for contrast
  FG = string.format("#%06x", normal_hl.foreground or 0xFFFFFF),
  YELLOW = '#e8b75f', -- Vibrant yellow
  CYAN = '#00bcd4', -- Soft cyan
  DARKBLUE = '#2b3e50', -- Deep blue
  GREEN = '#00e676', -- Bright green
  ORANGE = '#ff7733', -- Warm orange
  VIOLET = '#7a3ba8', -- Strong violet
  MAGENTA = '#d360aa', -- Deep magenta
  BLUE = '#4f9cff', -- Light-medium blue
  RED = '#ff3344', -- Strong red
}

local theme = {
  -- Define the common active mode colors
  active_sections = {
      a = { fg = colors.FG, bg = colors.BG, gui = "bold" },
      b = { fg = colors.FG, bg = colors.BG },
      c = { fg = colors.FG, bg = colors.BG },
      x = { fg = colors.FG, bg = colors.BG },
      y = { fg = colors.FG, bg = colors.BG },
      z = { fg = colors.FG, bg = colors.BG },
  },
}

-- Use a loop to apply the 'active_sections' to all active modes
for _, mode in ipairs({"normal", "insert", "visual", "replace", "command", "inactive"}) do
    theme[mode] = theme.active_sections
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = theme,
    --component_separators = { left = '', right = ''},
    --component_separators = { left = '|', right = '||'},
    component_separators = { left = '|', right = '|'},
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
    lualine_b = {},
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
    lualine_z = {
      {
        'branch',
        icon = '',
      },
      {
        'diff',
        symbols = { added = '+', modified = '~', removed = '-' },
        diff_color = {
          added = { fg = colors.GREEN },
          modified = { fg = colors.YELLOW },
          removed = { fg = colors.RED },
        },
      },
      'diagnostics'
    },
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

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
      vim.bo.expandtab = true
    end
})
