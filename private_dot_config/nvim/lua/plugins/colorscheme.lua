return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = 'dark'
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme 'gruvbox-material'

      -- Override JSX/HTML tag highlight groups so tags pop in .tsx/.jsx files.
      -- Scoped to ColorScheme autocmd so overrides survive :colorscheme reloads.
      local function set_tag_highlights()
        -- React components (<Generic/>, <MyButton>): purple — distinct from JS functions
        vim.api.nvim_set_hl(0, '@tag', { fg = '#d3869b', bold = true })
        -- HTML tags (div, span, button…): bold orange
        vim.api.nvim_set_hl(0, '@tag.builtin', { fg = '#e78a4e', bold = true })
        -- <, >, </,  />: aqua — visible punctuation, doesn't compete with the name
        vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#89b482' })
        -- Props (className, onClick…): yellow italic — distinct from the tag name
        vim.api.nvim_set_hl(0, '@tag.attribute', { fg = '#d8a657', italic = true })
      end

      set_tag_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', { callback = set_tag_highlights })
    end,
  },
}
