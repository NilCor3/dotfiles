return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {},
  },
  -- Native LSP setup — no external plugin, uses nvim 0.12 vim.lsp.config API
  {
    name = 'lsp-native',
    dir = vim.fn.stdpath 'config',
    event = 'VimEnter',
    dependencies = {
      'saghen/blink.cmp',
      'b0o/schemastore.nvim',
    },
    config = function()
      -- Global capabilities for all servers
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      vim.lsp.config('gopls', {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.mod', 'go.sum', '.git' },
      })

      vim.lsp.config('rust_analyzer', {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
      })

      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
        settings = {
          Lua = {
            format = { enable = false },
            completion = { callSnippet = 'Replace' },
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim', 'lazy' },
              disable = { 'missing-fields' },
            },
          },
        },
      })

      vim.lsp.config('vtsls', {
        cmd = { 'vtsls', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'tsconfig.json', 'package.json', '.git' },
        settings = {
          typescript = {
            preferences = { preferTypeOnlyAutoImports = true },
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = { completeFunctionCalls = true },
          },
          javascript = {
            preferences = { preferTypeOnlyAutoImports = true },
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = { completeFunctionCalls = true },
          },
          vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMoveToFileCodeAction = true,
            experimental = {
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
        },
      })

      vim.lsp.config('eslint', {
        cmd = { 'vscode-eslint-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'eslint.config.js', 'eslint.config.mjs', '.eslintrc.js', '.eslintrc.json', '.eslintrc.cjs', 'package.json', '.git' },
        settings = {
          -- nodePath must be explicit null (not absent/undefined) so the LSP guard
          -- `settings.nodePath !== null` correctly short-circuits. When undefined,
          -- path.isAbsolute(undefined) throws TypeError -32603.
          nodePath = vim.NIL,
          -- auto-detect working directory from project root indicators
          workingDirectory = { mode = 'auto' },
          validate = 'on',
          run = 'onType',
        },
      })

      vim.lsp.config('cssls', {
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'less', 'scss' },
        root_markers = { 'package.json', '.git' },
      })

      vim.lsp.config('cssmodules_ls', {
        cmd = { 'cssmodules-language-server' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'package.json', '.git' },
      })

      vim.lsp.config('marksman', {
        cmd = { 'marksman', 'server' },
        filetypes = { 'markdown' },
        root_markers = { '.marksman.toml', '.git' },
      })

      vim.lsp.config('sqlls', {
        cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
        filetypes = { 'sql', 'mysql' },
        root_markers = { '.sqllsrc.json', '.git' },
      })

      vim.lsp.config('jsonls', {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { 'package.json', '.git' },
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config('intelephense', {
        cmd = { 'intelephense', '--stdio' },
        filetypes = { 'php' },
        root_markers = { 'composer.json', 'composer.lock', '.git' },
      })

      vim.lsp.config('bashls', {
        cmd = { 'bash-language-server', 'start' },
        filetypes = { 'sh', 'bash' },
        root_markers = { '.git' },
      })

      vim.lsp.config('dockerls', {
        cmd = { 'docker-langserver', '--stdio' },
        filetypes = { 'dockerfile' },
        root_markers = { 'Dockerfile', 'docker-compose.yml', 'docker-compose.yaml', '.git' },
      })

      vim.lsp.enable { 'gopls', 'rust_analyzer', 'vtsls', 'eslint', 'cssls', 'cssmodules_ls', 'marksman', 'sqlls', 'lua_ls', 'jsonls', 'intelephense', 'bashls', 'dockerls' }

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = false,
        signs = vim.g.have_nerd_fonts and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('<leader>cc', vim.lsp.codelens.run, 'Run Codelens', { 'n', 'v' })
          map('<leader>cC', vim.lsp.codelens.refresh, 'Refresh Codelens')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
              local hl_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = hl_group,
                callback = vim.lsp.buf.document_highlight,
              })
              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = hl_group,
                callback = vim.lsp.buf.clear_references,
              })
              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(e)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
                end,
              })
            end
            if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
              map('<leader>uh', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, 'Toggle Inlay Hints')
            end
          end
        end,
      })
    end,
  },
}
