return {
  {
    'echasnovski/mini.nvim',
    -- for ai.gen_spec.treesitter() to work, the treesitter queries for things
    -- like @block or @function need to be added for each lanuage. These are not
    -- provided by default, so we'll use nvim-treesitter-textobjects's collection
    -- of queries. note: it also has an alternative method of textobject creation,
    -- but we will use mini.ai's instead.
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    version = false,
    config = function()
      local ai = require 'mini.ai'
      require('mini.ai').setup {
        -- Table with textobject id as fields, textobject specification as values.
        -- Also use this to disable builtin textobjects. See |MiniAi.config|.
        custom_textobjects = {
          o = ai.gen_spec.treesitter { -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          p = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },
          u = ai.gen_spec.function_call(), -- u for "Usage" (function CALL)
          U = ai.gen_spec.function_call { name_pattern = '[%w_]' }, -- same as 'u' but without dot in function name

          -- These are too spotty / unsupported across language queries to reliably replace the regex-based defaults
          -- ['='] = ai.gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.inner' }),
          -- a = ai.gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),

          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          d = { '%f[%d]%d+' }, -- digits
          e = { -- snake_case, camelCase, PascalCase, etc; all capitalizations
            -- Lua 5.1 character classes and the undocumented frontier pattern:
            -- https://www.lua.org/manual/5.1/manual.html#5.4.1
            -- http://lua-users.org/wiki/FrontierPattern
            {
              -- Matches a single uppercase letter followed by 1+ lowercase
              -- letters. This covers:
              -- - PascalCaseWords (or the latter part of camelCaseWords)
              '%u[%l%d]+%f[^%l%d]', -- An uppercase letter, 1+ lowercase letters, to end of lowercase letters

              -- Matches lowercase letters up until not lowercase letter.
              -- This covers:
              -- - start of camelCaseWords (just the `camel`)
              -- - snake_case_words in lowercase
              -- - regular lowercase words
              '%f[^%s%p][%l%d]+%f[^%l%d]', -- after whitespace/punctuation, 1+ lowercase letters, to end of lowercase letters
              '^[%l%d]+%f[^%l%d]', -- after beginning of line, 1+ lowercase letters, to end of lowercase letters

              -- Matches uppercase or lowercase letters up until not letters.
              -- This covers:
              -- - SNAKE_CASE_WORDS in uppercase
              -- - Snake_Case_Words in titlecase
              -- - regular UPPERCASE words
              -- (it must be both uppercase and lowercase otherwise it will
              -- match just the first letter of PascalCaseWords)
              '%f[^%s%p][%a%d]+%f[^%a%d]', -- after whitespace/punctuation, 1+ letters, to end of letters
              '^[%a%d]+%f[^%a%d]', -- after beginning of line, 1+ letters, to end of letters
            },
            -- original version from mini.ai help file:
            -- '%u[%l%d]+%f[^%l%d]',
            -- '%f[%S][%l%d]+%f[^%l%d]',
            -- '%f[%P][%l%d]+%f[^%l%d]',
            -- '^[%l%d]+%f[^%l%d]',
            '^().*()$',
          },
          -- i = LazyVim.mini.ai_indent, -- requires mini.indent
          g = function() -- Whole buffer
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line '$',
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,

          -- By default, closing and opening bracket types differ, where closing bracket includes whitespace
          -- in the textobject and opening doesn't. I hate that, I wan't them to behave the same and always
          -- include whitespace.
          ['('] = { '%b()', '^.().*().$' },
          [')'] = { '%b()', '^.().*().$' },
          ['['] = { '%b[]', '^.().*().$' },
          [']'] = { '%b[]', '^.().*().$' },
          ['{'] = { '%b{}', '^.().*().$' },
          ['}'] = { '%b{}', '^.().*().$' },
          ['<'] = { '%b<>', '^.().*().$' },
          ['>'] = { '%b<>', '^.().*().$' },
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Main textobject prefixes
          around = 'a',
          inside = 'i',

          -- Next/last textobjects
          around_next = 'an',
          inside_next = 'in',
          around_last = 'al',
          inside_last = 'il',

          -- Move cursor to corresponding edge of `a` textobject
          goto_left = 'g[',
          goto_right = 'g]',
        },

        -- Number of lines within which textobject is searched
        n_lines = 500,

        -- How to search for object (first inside current line, then inside
        -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
        -- 'cover_or_nearest', 'next', 'prev', 'nearest'.
        search_method = 'cover_or_next',

        -- Whether to disable showing non-error feedback
        -- This also affects (purely informational) helper messages shown after
        -- idle time if user input is required.
        silent = false,
      }

      require('mini.surround').setup {
        -- Use vim-surround-style keys so `s` is free for flash.nvim
        mappings = {
          add = 'ys',
          delete = 'ds',
          replace = 'cs',
          find = '',
          find_left = '',
          highlight = '',
          update_n_lines = '',
        },
      }
      require('mini.operators').setup()
      require('mini.statusline').setup { use_icons = true }
      require('mini.icons').setup {
        default = {},
        extension = {},
        lsp = {
          ['snippets'] = { glyph = '', hl = 'MiniIconsRed' },
          ['copilot'] = { glyph = '', hl = 'MiniIconsAzure' },
        },
      }
      require('mini.comment').setup {
        options = {
          ignore_blank_line = true,
        },
      }
    end,
  },
}
