local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local work_domain = vim.env.WORK_DOMAIN

local team_picker = function(opts)
	opts = opts or {}
	return pickers
		.new(opts, {
			prompt_title = "Team member",
			finder = finders.new_table({
				results = vim.tbl_map(function(s) return string.format(s, work_domain) end, {
					[[Quentin Boyer "<quentin.boyer@%s>"]],
					[[Philippe Dutrueux "<philippe.dutrueux@%s>"]],
					[[Sylvain Goudeau "<sylvain.goudeau@%s>"]],
					[[Jonathan Espié--Caullet "<jonathan.espiecaullet@%s>"]],
					[[Damien Bergamini "<damien.bergamini@%s>"]],
					[[Clément Mathieu--Drif "<clement.mathieu--drif@%s>"]],
					[[Marie Badaroux "<marie.badaroux@%s>"]],
				}),
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
