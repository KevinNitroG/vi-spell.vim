local M = {}

M.default_opts = {
	toggle = {
		filetypes = {
			"markdown",
			"text",
		},
		add = true,
	},
}

function M.setup(opts)
	opts = vim.tbl_deep_extend("force", M.default_opts, opts or {})
	local group = vim.api.nvim_create_augroup("vi-spell", {})
	vim.api.nvim_create_autocmd("FileType", {
		pattern = opts.toggle.filetypes,
		command = string.format("setlocal spelllang%s=vi", opts.toggle.add and "+" or ""),
		group = group,
	})
end

return M
