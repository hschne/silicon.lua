local init = {}

init.setup = function(opts)
	require("silicon.config").setup(opts)
end

-- For backwards compatibility
-- Generates image of selected
---@param show_buf boolean whether to show buffer
---@param highlight boolean whether to show hightlight
---@param to_clip boolean whether to show clipboard
init.visualise = function(show_buf, highlight, to_clip)
	init.visualise_api({ show_buf = show_buf, highlight = highlight, to_clip = to_clip })
	vim.notify(
		string.format(
			[[
Calling require("silicon").visualise(%s, %s) is deprecated and will be removed soon
Try using require("silicon").visualise_api({show_buf = %s, to_clip = %s})
  ]],
			show_buf,
			to_clip,
			show_buf,
			to_clip
		),
		vim.log.levels.WARN
	)
end

-- Similar to visualise
--- Generates image of selected region
---[[
-- show_buf boolean whether to show buffer
-- highlight boolean whether to highlight lines
-- to_clip boolean whether to show clipboard
-- visible boolean whether to render visible buffer
-- cmdline boolean whether to work around cmdline issues
---]]
---@param opts? table containing the options
init.visualise_api = function(opts)
	opts = opts or {}
	local range
	if opts.visible then
		range = { vim.fn.getpos("w0")[2], vim.fn.getpos("w$")[2] }
	elseif opts.cmdline then -- deal with `lua` leaving visual before executing
		range = { vim.api.nvim_buf_get_mark(0, "<")[1], vim.api.nvim_buf_get_mark(0, ">")[1] }
	else
		range = { vim.fn.getpos("v")[2], vim.fn.getpos(".")[2] }
	end
	require("silicon.request").exec(range, opts.show_buf or false, opts.to_clip or false, opts.highlight or false)
end

--- Generates image of selected region
--- But enforce cmdline workaround
---[[
-- show_buf boolean whether to show buffer
-- highlight boolean whether to highlight lines
-- to_clip boolean whether to show clipboard
-- visible boolean whether to render visible buffer
---]]
---@param opts? table containing the options
init.visualise_cmdline = function(opts)
	opts = opts or {}
	opts = vim.tbl_extend("keep", { cmdline = true }, opts)
	init.visualise_api(opts)
end

return init
