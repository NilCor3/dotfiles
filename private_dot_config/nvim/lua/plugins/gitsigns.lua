return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(l, r, desc)
          vim.keymap.set('n', l, r, { buffer = bufnr, desc = desc })
        end
        map(']h', gs.next_hunk, 'Next Hunk')
        map('[h', gs.prev_hunk, 'Prev Hunk')
        map('<leader>ghs', gs.stage_hunk, 'Stage Hunk')
        map('<leader>ghr', gs.reset_hunk, 'Reset Hunk')
        map('<leader>ghp', gs.preview_hunk, 'Preview Hunk')
      end,
    },
  },
}
