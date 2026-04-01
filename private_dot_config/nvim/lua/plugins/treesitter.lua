return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- CRUCIAL for Neovim 0.12.0
    build = ':TSUpdate',
    config = function(_, opts)
      require('nvim-treesitter').setup(opts)

      -- Recommended for 0.12.0: Let Neovim's core handle the high-speed
      -- highlighting trigger instead of the old plugin-based one.
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
    opts = {
      ensure_installed = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline',
        'query', 'vim', 'vimdoc', 'regex', 'go', 'gowork', 'css', 'csv',
        'dockerfile', 'editorconfig', 'gomod', 'gosum', 'gotmpl', 'graphql',
        'http', 'javascript', 'typescript', 'json', 'php', 'sql', 'yaml',
        'tsx', 'java', 'rust', 'xml', 'toml',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Helix-style text objects (maf, mif, etc.)
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main', -- Must match the parent branch
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  -- Auto-close and auto-rename paired JSX/HTML tags
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
}

