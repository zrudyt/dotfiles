-- [[ Setting options ]]
-- a description of vim options can be seen with the following commands:
--     :help vim.o
-- or:
--     :help options.txt
-- or online at:
--     https://vimhelp.org/options.txt.html

-- ----------------------------------------------------------------------
-- These are from kickstart.nvim
-- ----------------------------------------------------------------------

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = ''  -- was 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = false   -- was true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250    -- TODO what makes more sense, 250 or 50
vim.wo.signcolumn = 'yes'

vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- ----------------------------------------------------------------------
-- These are from ThePrimeagen (duplicates from above have been deleted)
-- ----------------------------------------------------------------------

vim.opt.guicursor = ""            -- keep fat cursor when in insert mode

vim.opt.number = true             -- show line number in front of each line
vim.opt.relativenumber = true     -- line numbers relative to cursor

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.autoindent = true         -- options.txt recommends this w/smartindent

vim.opt.wrap = false
vim.opt.sidescroll = 5
-- vim.opt.listchars += precedes:<,extends:>

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("XDG_STATE_DIR") .. "/nvim/undodir"
vim.opt.undofile = false

-- dupe vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
-- dupe vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
-- dupe vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
