require('lualine').setup({
    icons_enabled = true,
    options = {
        theme = "catppuccin-nvim",
    },
    tabline = {
        lualine_a = { 'buffers' },
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'tabs' }
    },
})
