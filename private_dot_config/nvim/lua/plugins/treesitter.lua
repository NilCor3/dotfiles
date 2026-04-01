return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- CRUCIAL for Neovim 0.12.0
    build = ':TSUpdate',
    config = function()
      -- New main-branch API: setup() only accepts install_dir.
      -- ensure_installed / auto_install / highlight / indent are old API (master branch)
      -- and are silently ignored here — we manage everything explicitly below.
      require('nvim-treesitter').setup()

      local parsers = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline',
        'query', 'vim', 'vimdoc', 'regex', 'go', 'gowork', 'css', 'csv',
        'dockerfile', 'editorconfig', 'gomod', 'gosum', 'gotmpl', 'graphql',
        'http', 'javascript', 'typescript', 'json', 'php', 'sql', 'yaml',
        'tsx', 'java', 'rust', 'xml', 'toml',
      }

      -- Install any missing parsers asynchronously (idempotent: skips already-installed).
      vim.defer_fn(function()
        require('nvim-treesitter').install(parsers)
      end, 0)

      -- Enable nvim's native treesitter highlighting per filetype.
      -- Scoped to known parsers so start() doesn't error on unsupported filetypes.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
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

