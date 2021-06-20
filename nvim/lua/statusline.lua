local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {'LuaTree','vista','dbui'}

local colors = {
	bg = '#282c34',
	yellow = '#fabd2f',
	cyan = '#008080',
	darkblue = '#081633',
	green = '#afd700',
	orange = '#FF8800',
	purple = '#5d4d7a',
	magenta = '#d16d9e',
	grey = '#c0c0c0',
	blue = '#0087d7',
	red = '#ec5f67',
	violet = '#6860e7'
}

local buffer_not_empty = function()
	if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
		return true
	end
	return false
end

-- Start of line
gls.left[1] = {
	FirstElement = {
		provider = function() return '▋' end,
		highlight = {colors.blue,colors.yellow}
	},
}
-- Vim mode
gls.left[2] = {
	ViMode = {
		provider = function()
			local alias = {n = 'NORMAL ',i = 'INSERT ',c= 'COMMAND ',V= 'VISUAL ', [''] = 'VISUAL '}
			return alias[vim.fn.mode()]
		end,
		separator = '',
		separator_highlight = {colors.yellow,function()
			if not buffer_not_empty() then
				return colors.purple
			end
			return colors.darkblue
		end},
		highlight = {colors.violet,colors.yellow,'bold'},
	},
}
-- File Icon
gls.left[3] ={
	FileIcon = {
		provider = 'FileIcon',
		condition = buffer_not_empty,
		highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.darkblue},
	},
}
-- File Name
gls.left[4] = {
	FileName = {
		provider = {'FileName'},
		condition = buffer_not_empty,
		separator = '',
		separator_highlight = {colors.purple,colors.darkblue},
		highlight = {colors.magenta,colors.darkblue}
	}
}
-- GIT
gls.left[5] = {
	GitIcon = {
		provider = function() return '  ' end,
		condition = buffer_not_empty,
		highlight = {colors.orange,colors.purple},
	}
}
gls.left[6] = {
	GitBranch = {
		provider = 'GitBranch',
		condition = buffer_not_empty,
		highlight = {colors.grey,colors.purple},
	}
}

local vcs = require('galaxyline.provider_vcs')

local is_file_diff = function ()
	if vcs.diff_add() ~= nil or vcs.diff_modified() ~= nil or vcs.diff_remove() ~= nil then
		return ''
	end
end

gls.left[7] = {
	GitModified = {
		provider = is_file_diff,
		highlight = {colors.green,colors.purple},
	}
}
gls.left[8] = {
	LeftEnd = {
		provider = function() return '' end,
		separator = '',
		separator_highlight = {colors.purple,colors.bg},
		highlight = {colors.purple,colors.purple}
	}
}

local lsp_diag_error = function() 
	local diagnostics = require('lsp-status/diagnostics')
	local buf_diagnostics = diagnostics()

	if buf_diagnostics.errors and buf_diagnostics.errors > 0 then
		return buf_diagnostics.errors .. ' '
	end
end
local lsp_diag_warn = function() 
	local diagnostics = require('lsp-status/diagnostics')
	local buf_diagnostics = diagnostics()

	if buf_diagnostics.warnings and buf_diagnostics.warnings > 0 then
		return buf_diagnostics.warnings .. ' '
	end
end
local lsp_diag_info = function() 
	local diagnostics = require('lsp-status/diagnostics')
	local buf_diagnostics = diagnostics()

	if buf_diagnostics.info and buf_diagnostics.info > 0 then
		return buf_diagnostics.info .. ' '
	end
end
local has_lsp = function ()
	return #vim.lsp.buf_get_clients() > 0
end

local has_curent_func = function ()
	if not has_lsp then
		return false
	end
	local current_function = vim.b.lsp_current_function
	return current_function and current_function ~= ''
end
local lsp_current_func = function ()
	local current_function = vim.b.lsp_current_function
	if current_function and current_function ~= '' then
		return '(' .. current_function .. ') '
	end
end


gls.right[1] = {
	LspText = {
		provider = function() return '' end,
		separator = '',
		separator_highlight = {colors.darkblue,colors.bg},
		highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[2] = {
	LspError = {
		provider = lsp_diag_error,
		condition = has_lsp,
		icon = ' ',
		highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[3] = {
	LspWarning = {
		provider = lsp_diag_warn,
		condition = has_lsp,
		icon = ' ',
		highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[4] = {
	LspInfo = {
		provider = lsp_diag_info,
		condition = has_lsp,
		icon = ' ',
		highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[5] = {
	LspCurrentFunc = {
		provider = lsp_current_func,
		condition = has_current_func,
		icon = '𝒇',
		highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[6]= {
	FileFormat = {
		provider = 'FileFormat',
		separator = '',
		separator_highlight = {colors.darkblue,colors.purple},
		highlight = {colors.grey,colors.purple},
	}
}
gls.right[7] = {
	LineInfo = {
		provider = 'LineColumn',
		separator = ' | ',
		separator_highlight = {colors.darkblue,colors.purple},
		highlight = {colors.grey,colors.purple},
	},
}
gls.right[8] = {
	PerCent = {
		provider = 'LinePercent',
		separator = '',
		separator_highlight = {colors.darkblue,colors.purple},
		highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[9] = {
	ScrollBar = {
		provider = 'ScrollBar',
		highlight = {colors.yellow,colors.purple},
	}
}
