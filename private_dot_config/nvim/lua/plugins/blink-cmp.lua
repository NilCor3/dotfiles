return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        -- Manually trigger copilot popup only (not during normal typing)
        ['<C-a>'] = { function() require('blink.cmp').show({ providers = { 'copilot' } }) end },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true },
        menu = {
          draw = {
            columns = { { 'kind_icon', 'kind', gap = 1 }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 1 },
          lsp = { score_offset = 10 },
          snippets = {
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= 'trigger_character'
            end,
            score_offset = 1,
          },
          path = {
            score_offset = 8,
          },
          buffer = {
            score_offset = 8,
          },
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Use the Lua fuzzy matcher (no Rust binary download needed)
      fuzzy = { implementation = 'lua', sorts = { 'score', 'exact', 'sort_text' } },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
