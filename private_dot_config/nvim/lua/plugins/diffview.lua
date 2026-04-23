return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  -- stylua: ignore
  keys = {
    { '<leader>go', '<cmd>DiffviewOpen<cr>',          desc = 'Diff: current changes' },
    { '<leader>gO', '<cmd>DiffviewOpen HEAD~1<cr>',   desc = 'Diff: vs prev commit' },
    { '<leader>gf', '<cmd>DiffviewFileHistory<cr>',   desc = 'Git: repo log' },
    { '<leader>gF', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git: file history' },
    { '<leader>gx', '<cmd>DiffviewClose<cr>',         desc = 'Diff: close' },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default      = { layout = 'diff2_horizontal' },
      file_history = { layout = 'diff2_horizontal' },
    },
  },
}
