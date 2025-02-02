return {
  {
    'vyfor/cord.nvim',
    -- build = './build',
    build = ':Cord update',
    event = 'VeryLazy',
    opts = {
      log_level = vim.log.levels.ERROR,
      editor = {
        image = 'https://styles.redditmedia.com/t5_30kix/styles/communityIcon_n2hvyn96zwk81.png', -- Image ID or URL in case a custom client id is provided. Default: nil
        client = 'neovim',                                                                        -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
        tooltip = 'The Superior Text Editor',                                                     -- Text to display when hovering over the editor's image
      },
    }
  },
}
