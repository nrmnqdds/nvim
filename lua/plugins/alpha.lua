return {}

-- return {
--   {
--     "goolord/alpha-nvim",
--     -- dependencies = { 'echasnovski/mini.icons' },
--     dependencies = { 'nvim-tree/nvim-web-devicons' },
--   },
--   config = function()
--     local alpha = require("alpha")
--     local dashboard = require("alpha.themes.dashboard")
--
--     local logo = [[
--
--     ███╗   ██╗ ██████╗ ████████╗    ██╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗
--     ████╗  ██║██╔═══██╗╚══██╔══╝    ██║   ██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝
--     ██╔██╗ ██║██║   ██║   ██║       ██║   ██║███████╗██║     ██║   ██║██║  ██║█████╗
--     ██║╚██╗██║██║   ██║   ██║       ╚██╗ ██╔╝╚════██║██║     ██║   ██║██║  ██║██╔══╝
--     ██║ ╚████║╚██████╔╝   ██║        ╚████╔╝ ███████║╚██████╗╚██████╔╝██████╔╝███████╗
--     ╚═╝  ╚═══╝ ╚═════╝    ╚═╝         ╚═══╝  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
--
--     ]]
--
--
--     -- Set header
--     dashboard.section.header.val = vim.split(logo, "\n")
--
--     -- Set menu
--     dashboard.section.buttons.val = {
--       dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
--       dashboard.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
--       dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
--       dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
--       dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
--     }
--
--     -- Send config to alpha
--     alpha.setup(dashboard.opts)
--
--     -- Disable folding on alpha buffer
--     vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
--   end
-- }
