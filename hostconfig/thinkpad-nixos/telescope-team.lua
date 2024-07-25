local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local team_picker = function(opts)
	opts = opts or {}
	return pickers
		.new(opts, {
			prompt_title = "Team member",
			finder = finders.new_table({
				results = {
					[[Quentin Boyer "<quentin.boyer@***REMOVED***>"]],
					[[Mathieu Barbe "<mathieu.barbe@***REMOVED***>"]],
					[[Philippe Dutrueux "<philippe.dutrueux@***REMOVED***>"]],
					[[Sylvain Goudeau "<sylvain.goudeau@***REMOVED***>"]],
					[[Jonathan Espié--Caullet "<jonathan.espiecaullet@***REMOVED***>"]],
					[[Damien Bergamini "<damien.bergamini@***REMOVED***>"]],
					[[Pedro Martins Basso "<pedro.martinsbasso@***REMOVED***>"]],
					[[Yoann Heitz "<yoann.heitz@***REMOVED***>"]],
					[[Clément Mathieu--Drif "<clement.mathieu--drif@***REMOVED***>"]],
				},
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

return function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local member = team_picker()

	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { member })
end
