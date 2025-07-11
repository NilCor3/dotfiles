---@type LazyPluginSpec[]
return {
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      ---@type LspsagaConfig
      local settings = {
        lightbulb = {
          sign = false,
        },
        ui = {
          code_action = '',
        },
      }

      require('lspsaga').setup(settings)

      -- Code
      vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
      vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>')
      vim.keymap.set('n', '<leader>cr', '<cmd>Lspsaga rename<CR>')

      -- Peek
      vim.keymap.set('n', '<leader>cd', '<cmd>Lspsaga peek_definition<CR>')
      vim.keymap.set('n', '<leader>ct', '<cmd>Lspsaga peek_type_definition<CR>')
      vim.keymap.set('n', '<leader>cf', '<cmd>Lspsaga finder<CR>')
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },
}
