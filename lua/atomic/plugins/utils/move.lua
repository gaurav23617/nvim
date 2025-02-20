return {
	"echasnovski/mini.move",
	version = false,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("mini.move").setup({
			-- module mappings. use `''` (empty string) to disable one.
			mappings = {
				-- move visual selection in visual mode. defaults are alt (meta) + hjkl.
				left = "<m-h>",
				right = "<m-l>",
				down = "<m-j>",
				up = "<m-k>",

				-- move current line in normal mode
				line_left = "<m-h>",
				line_right = "<m-l>",
				line_down = "<m-j>",
				line_up = "<m-k>",
			},

			-- options which control moving behavior
			options = {
				-- automatically reindent selection during linewise vertical move
				reindent_linewise = true,
			},
		})
	end,
}
