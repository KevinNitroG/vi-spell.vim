local total = 0
local completed = 0

---@type ViSpell.Opts
local default_opts = {
	use_default = true,
}

---@type ViSpell.Opts
local opts = vim.tbl_deep_extend("force", default_opts, vim.g.vi_spell_opts or {})

---@type table<string, string>
local lists = opts.use_default
		and {
			["ibus-bamboo"] = "https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/refs/heads/master/data/vietnamese.cm.dict",
			["hungspell-vi"] = "https://raw.githubusercontent.com/1ec5/hunspell-vi/refs/heads/main/dictionaries/vi-DauMoi.dic",
		}
	or {}
if opts.extra then
	vim.list_extend(lists, opts.extra)
end

total = #lists

local function build_spell_with_neovim()
	local files = table.concat(vim.tbl_keys(lists), " ")
	local cmd = {
		"nvim",
		"-u",
		"NONE",
		"--headless",
		"-c",
		string.format("mkspell! ./spell/vi %s", files),
		"-c",
		"qa",
	}
	vim.fn.jobstart(cmd, {
		on_exit = function(_, code, _)
			vim.schedule(function()
				if code == 0 then
					vim.notify("Build Vietnamese spell succesfully!")
				else
					vim.notify("Build Vietnamese spell fail!", vim.log.levels.ERROR)
				end
			end)
		end,
	})
end

---@type fun(err?: string, response?: { body: boolean })
local function download_callback(err, response)
	completed = completed + 1
	if err then
		vim.schedule(function()
			vim.notify(err, vim.log.levels.ERROR)
		end)
	end
	-- if response.body == false then
	-- 	vim.schedule(function()
	-- 		coroutine.yield({ "Create a downloaded spell file failed", vim.log.levels.ERROR })
	-- 	end)
	-- end
	if completed == total then
		build_spell_with_neovim()
	end
end

---@param name string
---@param url string
local function download(name, url)
	local outpath = string.format("word_lists/%s", name)
	vim.net.request(url, { outpath = outpath }, download_callback)
end

for name, url in pairs(lists) do
	download(name, url)
end
