-- Scales the saturation of every color gruvbox-material defines.
-- 1.0 = stock, lower = more muted. Neutrals are unaffected (they have no saturation).
local SATURATION = 0.9

local function scale_saturation(hex, factor)
	local rr, gg, bb = hex:match("^#(%x%x)(%x%x)(%x%x)$")
	if not rr then
		return hex
	end
	local r, g, b = tonumber(rr, 16) / 255, tonumber(gg, 16) / 255, tonumber(bb, 16) / 255

	local max, min = math.max(r, g, b), math.min(r, g, b)
	local l = (max + min) / 2
	if max == min then
		return hex
	end

	local d = max - min
	local s = l > 0.5 and d / (2 - max - min) or d / (max + min)
	local h
	if max == r then
		h = (g - b) / d + (g < b and 6 or 0)
	elseif max == g then
		h = (b - r) / d + 2
	else
		h = (r - g) / d + 4
	end
	h, s = h / 6, s * factor

	local q = l < 0.5 and l * (1 + s) or l + s - l * s
	local p = 2 * l - q
	local function hue2rgb(t)
		t = t % 1
		if t < 1 / 6 then
			return p + (q - p) * 6 * t
		elseif t < 1 / 2 then
			return q
		elseif t < 2 / 3 then
			return p + (q - p) * (2 / 3 - t) * 6
		end
		return p
	end

	return string.format(
		"#%02x%02x%02x",
		math.floor(hue2rgb(h + 1 / 3) * 255 + 0.5),
		math.floor(hue2rgb(h) * 255 + 0.5),
		math.floor(hue2rgb(h - 1 / 3) * 255 + 0.5)
	)
end

return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
	init = function()
		vim.g.gruvbox_material_enable_italic = true
		vim.g.gruvbox_material_transparent_background = 1
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "gruvbox-material",
			callback = function()
				vim.api.nvim_set_hl(0, "@comment.todo", { fg = "#d8a657", bold = true })
				vim.api.nvim_set_hl(0, "Todo", { fg = "#d8a657", bold = true })
			end,
		})
	end,
	config = function()
		if SATURATION ~= 1.0 then
			local cfg = vim.fn["gruvbox_material#get_configuration"]()
			local stock = vim.fn["gruvbox_material#get_palette"](cfg.background, cfg.foreground, vim.empty_dict())
			local override = {}
			for name, color in pairs(stock) do
				if type(color) == "table" and type(color[1]) == "string" then
					override[name] = { scale_saturation(color[1], SATURATION), color[2] }
				end
			end
			vim.g.gruvbox_material_colors_override = override
		end
		vim.cmd.colorscheme("gruvbox-material")
	end,
}
