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
			preselect = cmp.PreselectMode.None,
			---@diagnostic disable-next-line: missing-fields
			completion = {
				completeopt = "menu,menuone,noinsert",
        -- TODO: refactor for swift
				--get_trigger_characters = function()
				-- return { "(" }
				-- end,
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			matching = {
				disallow_fuzzy_matching = true,
				disallow_prefix_unmatching = false,
				disallow_partial_fuzzy_matching = true,
				disallow_fullfuzzy_matching = false,
				disallow_partial_matching = false,
			},
			mapping = {
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
				["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
				["<C-y>"] = cmp.config.disable,
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<C-a"] = cmp.mapping(
					cmp.mapping.complete({
						reason = cmp.ContextReason.Auto,
					}),
					{ "i", "c" }
				),
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
			},
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				fields = { "kind", "abbr", "menu" },
				expandable_indicator = false,
				format = function(entry, vim_item)
					local label = vim_item.abbr
					local truncated_label = vim.fn.strcharpart(label, 0, 45)
					if truncated_label ~= label then
						vim_item.abbr = truncated_label .. "…"
					end
					vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						nvim_lua = "[NVIM]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
					})[entry.source.name]
					return vim_item
				end,
			},
			sources = {
				{
					name = "nvim_lsp",
          -- TODO: Refactor for swift
					--entry_filter = function(entry, _)
					--  if entry.completion_item.label == "()" then
					--    return false
					--  else
					--    return true
					--  end
					--end
				},
				{ name = "nvim_lua" },
				{ name = "luasnip" },
				{ name = "buffer" },
			},
			experimental = {
				native_menu = false,
				ghost_text = true,
			},
			---@diagnostic disable-next-line: missing-fields
			view = {
				docs = {
					auto_open = false,
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
		})
		---@diagnostic disable-next-line: missing-fields
		cmp.setup.cmdline(":", {
			preselect = cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.cmdline(),

			---@diagnostic disable-next-line: missing-fields
			completion = {
				completeopt = "menu,menuone,noinsert,noselect",
			},
			sources = {
				{ name = "path" },
				{ name = "cmdline" },
			},
		})
	end,
}
