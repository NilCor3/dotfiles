return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below

    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>f', group = '[F]ind' },
      { '<leader>b', group = '[B]uffers' },
      { '<leader>g', group = '[G]oto' },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>a', group = '[A]I' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>t', group = '[T]est' },
      { '<leader>u', group = '[U]i' },
      { '<leader>q', group = '[Q]uicklists' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
