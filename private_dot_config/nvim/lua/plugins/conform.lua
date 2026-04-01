return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre', 'BufWritePost' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cF',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      -- format_after_save is async (fires on BufWritePost) — never blocks Neovim.
      -- prettierd keeps Node warm so first-format latency is ~50ms instead of ~500ms.
      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return { lsp_format = 'fallback' }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        go = { 'goimports' },
        -- Web: prettierd (daemon) keeps Node warm for near-instant formatting
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        html = { 'prettierd' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        markdown = { 'prettierd' },
        -- Shell
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        -- SQL
        sql = { 'sql_formatter' },
        -- PHP
        php = { 'php_cs_fixer' },
      },
    },
  },
}
