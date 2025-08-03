local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")

---@type ViSpell.Opts
local default_opts = {
	use_default = true,
}

---@type ViSpell.Opts
local opts = vim.tbl_deep_extend("force", default_opts, vim.g.vi_spell_opts or {})

---@type table<string, string>
local lists = opts.use_default
		and {
			["vi_VN1.dic"] = "https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/refs/heads/master/data/vietnamese.cm.dict",
			["vi_VN2.dic"] = "https://raw.githubusercontent.com/1ec5/hunspell-vi/refs/heads/main/dictionaries/vi-DauMoi.dic",
		}
	or {}
if opts.extra then
	vim.list_extend(lists, opts.extra)
end

---@param path string
local function mkdir(path)
	path = vim.fs.joinpath(root, path)
	local stat = vim.uv.fs_stat(path)
	if not stat then
		vim.uv.fs_mkdir(path, 493)
	end
end

---@param path string
local function rmdir(path)
	path = vim.fs.joinpath(root, path)
	local stat = vim.uv.fs_stat(path)
	if stat then
		vim.uv.fs_rmdir(path)
	end
end

local function mkspell(names)
	local files = table.concat(
		vim.tbl_map(function(name)
			return vim.fs.joinpath(root, string.format("word_lists/%s", name))
		end, names),
		" "
	)
	local cmd = string.format("mkspell! %s %s", vim.fs.joinpath(root, "spell/vi"), files)
	vim.print(cmd)
	vim.cmd(cmd)
end

---@param name string
---@param url string
local function download(name, url)
	local outpath = vim.fs.joinpath(root, string.format("word_lists/%s", name))
	local result = vim.system({
		"curl",
		"-fLo",
		outpath,
		"--create-dirs",
		url,
	}, { text = true }):wait()

	if result.code == 0 then
		return true
	else
		vim.print("Download failed:", name, "code:", result.code, "stderr:", result.stderr)
		return false
	end
end

local function main()
	mkdir("word_lists")
	local downloaded = {} ---@type string[]
	for name, url in pairs(lists) do
		local result = download(name, url) ---@cast result boolean
		if result then
			downloaded[#downloaded + 1] = name
		end
	end
	vim.print(downloaded)
	mkspell(downloaded)
	rmdir("word_lists")
end

main()
