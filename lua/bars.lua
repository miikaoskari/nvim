return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		show_tab_indicators = false,
		show_close_icon = false,
		show_buffer_close_icons = false,
		separator_style = "thin",
		always_show_buffer_name = true,
		icons = {
			filetype = {
				enabled = false,
			},
			gitsigns = {
				added = { enabled = true, icon = "+" },
				changed = { enabled = true, icon = "~" },
				deleted = { enabled = true, icon = "-" },
			},
		},
		-- Set the filetypes which barbar will offset itself for
		sidebar_filetypes = {
			-- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
			NvimTree = true,
			-- Or, specify the text used for the offset:
			undotree = {
				text = "undotree",
				align = "center", -- *optionally* specify an alignment (either 'left', 'center', or 'right')
			},
			-- Or, specify the event which the sidebar executes when leaving:
			["neo-tree"] = { event = "BufWipeout" },
			-- Or, specify all three
			Outline = { event = "BufWinLeave", text = "symbols-outline", align = "right" },
		},
	},
	version = "^1.0.0", -- optional: only update when a new 1.x version is released
}
