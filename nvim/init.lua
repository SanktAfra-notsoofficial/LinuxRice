-- SOURCE: YouTube - typecraft - Neovim for Newbs - https://www.youtube.com/watch?v=zHTeCSVAFNY&list=PLsz00TDipIffreIaUNk64KxTIkQaGguqn&index=2
vim.wo.number = true
-- vim.cmd('set expandtab')
-- vim.cmd('set tabstop=2')
-- vim.cmd('set softtabstop=2')
-- vim.cmd('set shiftwidth=2') 
vim.g.mapleader = ' '


vim.keymap.set('n', 'U', ':w <CR> :! pdflatex %<CR><CR>', {})
vim.keymap.set('n', 'B', ':w <CR> :! nohup zathura %:r.pdf<CR> &', {})

-- Plugin Manager Lazy
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

-- List of Plugins
local plugins = {
  -- Theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- Telescope for searching files
  {     
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
     dependencies = { 'nvim-lua/plenary.nvim' }
  },
  -- LSP (Language-Server-Protocol) Manager Mason
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },
  -- Ensure these LSP's are installed when starting nvim
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        -- List all used LSP's
        ensure_installed = { 'pylsp', 'lua_ls', 'texlab', 'ltex' }
      })
    end
  },
  -- Configure nvim to use LSP's / set keybindings & enable server communication
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Require all used LSP's
      lspconfig.pylsp.setup({
        capabilities = capabilities
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.texlab.setup({
        capabilities = capabilities
      })

      -- Custom keybindings for LSP's
      vim.keymap.set('n', 'I', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },
  -- Autocompletion
  {
    'hrsh7th/cmp-nvim-lsp' -- extend snippets sources by asking LSP's
  },
  {
    'L3MON4D3/LuaSnip'
  },
  {
    'saadparwaiz1/cmp_luasnip'
  },
  {
    'rafamadriz/friendly-snippets' -- VSCode snippets
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require'cmp'
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          -- Snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          -- { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },
  -- VimTex
  {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtext_compiler_method = "latexmk"
	end,
  },
  {
	"valentjn/ltex-ls"
  },
  {
	"jlaurens/synctex"
  },
  {
    'sirver/ultisnips',
    -- init = function()
      -- vim.g.UltiSnipsExpandTrigger = '<tab>'
      -- vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
      -- vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
    -- end
  }
}
local opts = {}

-- Requiring the installed Plugins
require('lazy').setup(plugins, opts)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })

require('catppuccin').setup()
vim.cmd.colorscheme 'catppuccin'
