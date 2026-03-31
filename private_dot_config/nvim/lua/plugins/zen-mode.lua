return {
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = {
      { '<leader>uz', '<cmd>ZenMode<cr>', desc = 'Zen mode' },
    },
    opts = {
      window = { width = 0.85 },
      plugins = {
        tmux = { enabled = true },
      },
    },
  },
}
