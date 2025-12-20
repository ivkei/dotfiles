require("config")

-- Transparent Background
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })

-- Folds
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.number = true

-- Sets
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.smarttab = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.mapleader = " "

vim.opt.signcolumn = 'no'

-- Split on startup
--vim.api.nvim_create_augroup("StartupSplits", { clear = true })
--vim.api.nvim_create_autocmd("VimEnter", {
--  group = "StartupSplits",
--  callback = function()
--    vim.cmd("vsplit")
--    vim.cmd("wincmd h")
--    vim.cmd("vertical resize 105")
--  end,
--})

vim.keymap.set('n', '<Tab>', '<C-w>w', { noremap = true, silent = true })

local function open_header_or_source()
    local current = vim.fn.expand('%:t')         -- filename.ext
    local dir = vim.fn.expand('%:p:h')           -- full directory
    local ext = vim.fn.expand('%:e')             -- extension
    local base = vim.fn.expand('%:t:r')          -- filename (no extension)
    local target = nil

    local curwin = vim.api.nvim_get_current_win()
    --vim.cmd('wincmd w')

    if ext == 'cpp' or ext == 'c' then
        target = dir .. '/' .. base .. '.h'
    elseif ext == 'h' then
        local cpp_target = dir .. '/' .. base .. '.cpp'
        local c_target = dir .. '/' .. base .. '.c'
        
        if vim.fn.filereadable(cpp_target) == 1 then
          target = cpp_target
        else
          target = c_target
        end
    end

    if target and vim.fn.filereadable(target) == 1 then
        vim.cmd('edit ' .. target)
    else
        print('Counterpart file not found: ' .. (target or 'unknown'))
    end

    vim.api.nvim_set_current_win(curwin)
end

--Allows to open .h from .cpp or vice versa either in next pane or in current, if none are open except for current
vim.keymap.set('n', '<leader>hh', open_header_or_source, { noremap = true, silent = true, desc = "Switch between .cpp/.h in vsplit" })

-- Enable persistent undo and set a directory for undo files
vim.cmd('set undofile')
vim.cmd('set undodir=~/.nvim/undodir')
