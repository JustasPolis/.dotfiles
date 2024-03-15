local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local kind_icons = {
	Text = "󰊄",
	Method = "m",
	Function = "󰊕",
	Constructor = "",
	Field = "",
	Variable = "󰫧",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "󰌆",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "󰉺",
}

return {
	"hrsh7th/nvim-cmp",
	lazy = true,
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			opts = {
				history = true,
				delete_check_events = "TextChanged",
			},
		},
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"rafamadriz/friendly-snippets",
		"windwp/nvim-autopairs",
	},
	config = function()
		local borderstyle = {
			scrollbar = false,
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
		}
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()
		---@diagnostic disable-next-line: missing-fields
		cmp.setup({
			---@diagnostic disable-next-line: missing-fields
			performance = {
				max_view_entries = 30,
				debounce = 60,
				fetching_timeout = 500,
				throttle = 30,
			},
			preselect = cmp.PreselectMode.None,
			---@diagnostic disable-next-line: missing-fields
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
				["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(1) then
						luasnip.jump(1)
					elseif check_backspace() then
						fallback()
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
				["<C-g>"] = cmp.mapping(function()
					if cmp.visible_docs() then
						cmp.close_docs()
					else
						cmp.open_docs()
					end
				end, {
					"i",
					"s",
				}),
			}),
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				expandable_indicator = false,
				format = function(_, vim_item)
					local label = vim_item.abbr
					local truncated_label = vim.fn.strcharpart(label, 0, 45)
					if truncated_label ~= label then
						vim_item.abbr = truncated_label .. "…"
					end
					vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
					local menu_label = vim_item.menu

					if menu_label == nil then
						return vim_item
					end

					local truncated_menu_label = vim.fn.strcharpart(menu_label, 0, 45)
					if truncated_menu_label ~= menu_label then
						vim_item.menu = truncated_menu_label .. "…"
					end
					return vim_item
				end,
			},
			sources = {
				{
					name = "nvim_lsp",
					max_item_count = 20,
				},
				{ name = "nvim_lua" },
				{ name = "luasnip" },
				{ name = "buffer" },
			},
			experimental = {
				native_menu = false,
				ghost_text = false,
			},
			---@diagnostic disable-next-line: missing-fields
			view = {
				docs = {
					auto_open = true,
				},
			},
			window = {
				---@diagnostic disable-next-line: missing-fields
				completion = borderstyle,
				documentation = borderstyle,
			},
		})
		---@diagnostic disable-next-line: missing-fields
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},

			formatting = {
				expandable_indicator = false,
				fields = { "abbr" },
				format = function(_, vim_item)
					vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
					return vim_item
				end,
			},
		})
		---@diagnostic disable-next-line: missing-fields
		cmp.setup.cmdline(":", {
			preselect = cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.cmdline(),
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				expandable_indicator = false,
			},
			---@diagnostic disable-next-line: missing-fields
			completion = {
				completeopt = "menu,menuone,noinsert,noselect",
			},
			sources = {
				{ name = "path" },
				{ name = "cmdline" },
			},
		})
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
