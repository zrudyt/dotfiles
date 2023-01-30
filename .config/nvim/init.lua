local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set <space> as the leader key
-- See `:help mapleader`
-- WARNING: Must happen before plugins are required (otherwise wrong leader will be used)
--
-- Note: leader key times out after about a second
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- load contents of nvim/lua/plugins/init.lua
-- Lazy will automatically load and merge any other lua files
-- in  nvim/lua/plugins/init.lua into the main plugin specification
require('lazy').setup('plugins')

require('options')
require('keybindings')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == 'help' then vim.cmd.wincmd("L") end
  end
})

----------------------------------------------------------------------------
 -- Ex command :write! myfile.txt
 -- vim.cmd('write! myfile.txt')
 -- vim.cmd { cmd = 'write', args = { "myfile.txt" }, bang = true }
 -- vim.cmd.write { args = { "myfile.txt" }, bang = true }
 -- vim.cmd.write { "myfile.txt", bang = true }

-- autocmd BufWritePost *.sh '!chmod +x %'

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = vim.api.nvim_create_augroup("RunCommandOnWrite", {}),
--   pattern = { "*.sh" },
--   callback = function()
--     '!chmod +x %'
--   end
-- })

-- local augroup = vim.api.nvim_create_augroup
-- local myChmodGroup = augroup('ChmodGroup', {})
-- 
-- local autocmd = vim.api.nvim_create_autocmd
-- 
-- autocmd('BufWritePost', {

-- Enable Comment.nvim
----------------------------------------------------------------------------

require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,

}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Set colorscheme
-- vim.cmd [[colorscheme onedark]]
vim.cmd('colorscheme onedark')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'bash', 'html', 'json', 'lua', 'perl', 'python', 'help', 'vim' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}


-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  sumneko_lua = {
     Lua = {
       workspace = { checkThirdParty = false },
       telemetry = { enable = false },
     },
   },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

--------------------------------------------------

-- local augroup = vim.api.nvim_create_augroup
-- local myChmodGroup = augroup('ChmodGroup', {})
-- 
-- local autocmd = vim.api.nvim_create_autocmd
-- 
-- autocmd('BufWritePost', {
--     group = myChmodGroup,
--     pattern = '*',
--     callback = function()
--         vim.highlight.on_yank({
--             higroup = 'IncSearch',
--             timeout = 40,
--         })
--     end,
-- })
-- 
-- autocmd({"BufWritePre"}, {
--     group = ThePrimeagenGroup,
--     pattern = "*",
--     command = [[%s/\s\+$//e]],
-- })
-- 
-- local myHelpGroup = augroup('HelpGroup', {})
-- autocmd FileType help wincmd L
-- 
-- augroup my_filetype_settings
-- autocmd!
-- autocmd FileType help if winnr('$') > 2 | wincmd K | else | wincmd L | endif
-- augroup END
-- 

-- --
-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25

--------------------------------------------------


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
