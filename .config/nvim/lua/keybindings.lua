-- vim to nvim guides
-- https://github.com/nanotee/nvim-lua-guide
-- https://kinbiko.com/posts/2021-08-23-rewriting-vimrc-in-lua/

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- exit to netrw screen
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ff", vim.cmd.Ex)

-- move Visual highlighted lines up and down as a block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in the same place when using j to append
vim.keymap.set("n", "J", "mzJ`z")

-- scroll Down/Up half a page and center current line in window
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- goto next/previous match and center current line in window
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever - paste highlighted word and keep it in register to paste again
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland - paste in global system clipboard to be used outside nvim
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- don't ever press Q - this ensures nothing will happen if you do
vim.keymap.set("n", "Q", "<nop>")
-- go to tmux, then do Ctrl-A L to get back via tmux previous session
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Quick Fix list / Quick Fix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- quick little s/a/b/ type menu pre-filled with the word we're on as replacement
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- run chmod +x on current file - this is genius!
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- from kickstart.nvim

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- With "smart home", pressing the Home key moves the cursor to the first
-- nonblank character on the line, or, if already at that position, to the
-- start of the line. 
-- https://vim.fandom.com/wiki/Smart_home

-- The first line is an expression mapping for normal, visual, and operator
-- pending modes. The right-hand side of the mapping is an expression that is
-- evaluated each time Home is pressed. The expression gives a string, and
-- the result is as if the characters in the string had been pressed. The
-- expression compares col('.') (the cursor column position, where 1 is
-- the first column) and match(getline('.'),'\S')+1 (the index of the first
-- non-whitespace character in the current line; 1 is added because the index
-- starts at 0). If both sides of "==" are equal, the result is '0' (move
-- to start of line); otherwise it is '^' (move to first nonblank character).
-- 
-- In insert mode, the second line applies and if Home is pressed the result
-- is Ctrl-O followed by Home. In insert mode, pressing Ctrl-O executes what
-- follows as a normal-mode command, so the Home which follows invokes the
-- normal mode mapping.
-- 
-- The simple mappings have two deficiencies:
--
--   - If there are no non-whitespace characters, match() returns −1 which
--     becomes 0 after adding 1, and that value never equals the result from
--     col('.'). Therefore the mapping always performs ^.
--     
--   - The mapping does not account for the case where the 'wrap' option is
--     on and long lines are wrapped. In that case, pressing Home will jump
--     to the first nonblank character or the start of the line, whereas
--     moving to the start of the screen line may be wanted.

-- vim.cmd "noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'"
-- vim.cmd "imap <silent> <Home> <C-O><Home>"

-----------------------------------------------------------------------------
-- converting noremap to lua - https://www.youtube.com/watch?v=w7i4amO_zaE
-- ---------------------------------------------------------------------------
-- :s/\(.\)noremap(/vim.keymap.set""\1", [Enter]
-- ---------------------------------------------------------------------------
--
-- Then take the contents of your old .vimrc and wrap them inside
-- vim.cmd([[
-- <contents of .vimrc goes here>
-- ]])
--
-- In Lua, [[ and ]] enclose a multi-line string, so you’ve probably
-- guessed that the above code just evaluates the string (your old VimL
-- config) as VimL. This will most likely work out of the box. Indeed, if you
-- struggle to find the native Lua API for the change you want to do, you can
-- call vim.cmd('<some snippet>') at any time. Commit now, and you’ll have a
-- lot smaller and more obvious commits going forward.

vim.cmd([[
    noremap <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
    noremap <expr> <End> (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
    vnoremap <expr> <End> (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
    imap <Home> <C-o><Home>
    imap <End> <C-o><End>
]])
