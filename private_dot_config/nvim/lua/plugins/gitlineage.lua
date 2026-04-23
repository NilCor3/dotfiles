return {
  'LionyxML/gitlineage.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- stylua: ignore
  keys = {
    { '<leader>gL', function() require('gitlineage').open() end,
      mode = { 'n', 'v' }, desc = 'Git: line history' },
  },
  opts = {
    -- open the selected commit's full diff in diffview.nvim
    open_in_diffview = true,
  },
}
