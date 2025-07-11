return {
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    -- stylua: ignore
    keys = {
      -- resizing splits
      { '<A-h>', function() require('smart-splits').resize_left() end, mode = 'n', desc = 'Resize split left' },
      { '<A-j>', function() require('smart-splits').resize_down() end, mode = 'n', desc = 'Resize split down' },
      { '<A-k>', function() require('smart-splits').resize_up() end, mode = 'n', desc = 'Resize split up' },
      { '<A-l>', function() require('smart-splits').resize_right() end, mode = 'n', desc = 'Resize split right' },

      -- moving between splits
      { '<C-h>', function() require('smart-splits').move_cursor_left() end, mode = 'n', desc = 'Move to left split' },
      { '<C-j>', function() require('smart-splits').move_cursor_down() end, mode = 'n', desc = 'Move to down split' },
      { '<C-k>', function() require('smart-splits').move_cursor_up() end, mode = 'n', desc = 'Move to up split' },
      { '<C-l>', function() require('smart-splits').move_cursor_right() end, mode = 'n', desc = 'Move to right split' },
      { '<C-\\>', function() require('smart-splits').move_cursor_previous() end, mode = 'n', desc = 'Move to previous split' },

      -- swapping buffers
      { '<leader><leader>h', function() require('smart-splits').swap_buf_left() end, mode = 'n', desc = 'Swap buffer left' },
      { '<leader><leader>j', function() require('smart-splits').swap_buf_down() end, mode = 'n', desc = 'Swap buffer down' },
      { '<leader><leader>k', function() require('smart-splits').swap_buf_up() end, mode = 'n', desc = 'Swap buffer up' },
      { '<leader><leader>l', function() require('smart-splits').swap_buf_right() end, mode = 'n', desc = 'Swap buffer right' },
    },
  },
}
