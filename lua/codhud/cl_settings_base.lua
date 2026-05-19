CoDHUD = CoDHUD or {}
CoDHUDMenu = CoDHUDMenu or {}
CoDHUD.SettingsTable = CoDHUD.SettingsTable or {}

-- Global API for third-party sounds and addons
CoDHUDMenu.Sounds = CoDHUDMenu.Sounds or {}
CoDHUDMenu.SoundProfiles = CoDHUDMenu.SoundProfiles or {}
CoDHUDMenu.AddonEntries = CoDHUDMenu.AddonEntries or {}

function CoDHUDMenuSound(data)
    if not istable(data) then return end
    if not isstring(data.name) then return end
    if not istable(data.sounds) then return end

    local id = data.name

    -- Prevent accidental overwrite (optional)
    if CoDHUDMenu.Sounds[id] then
        return
    end

    -- Store sounds
    CoDHUDMenu.Sounds[id] = data.sounds

    -- Store display info
    CoDHUDMenu.SoundProfiles[id] = {
        displayname = data.displayname or id
    }
end

function CoDHUDAddon(rows)
	if not istable(rows) then return end

	local block = {}

	for _, row in ipairs(rows) do
		if istable(row) then
			table.insert(block, row)
		end
	end

	if #block > 0 then
		table.insert(CoDHUDMenu.AddonEntries, block)
	end
end

-- Sounds Table
CoDHUDMenu.Music = {
    ["cod4"] = "codhud/menu/cod4/HGW_Gameshell_v10.mp3",
    ["waw"] = "codhud/menu/waw/mx_underscore_brave_soldat_mod.mp3",
    ["mw2"] = "codhud/menu/mw2/hz_t_oilrig_themestealth_v1.mp3",
    ["bo1"] = "codhud/menu/bo1/mus_mp_frontend_lp_l.mp3",
    ["mw3"] = "codhud/menu/mw3/bt_mp_menumusic.mp3",
    ["bo2"] = "codhud/menu/bo2/mpl_mus_frontend.SL65.pc.snd.mp3",
}

CoDHUDMenu.Sounds = {
    ["cod4"] = {
        menuopen = "codhud/menu/cod4/ui_screen_in1.mp3",
        menuclose = "codhud/menu/cod4/ui_screen_out1.mp3",
        hover = "codhud/menu/cod4/ui_over_v1.mp3",
        confirm = "codhud/menu/cod4/ui_select_v1.mp3",
        clickopen = "codhud/menu/cod4/ui_select_v1.mp3",
    },
    ["waw"] = {
        hover = "codhud/menu/waw/2nd_click_fnt.mp3",
        confirm = "codhud/menu/waw/slider_rear.mp3",
        clickopen = "codhud/menu/waw/main_click_fnt.mp3",
    },
    ["mw2"] = {
        menuopen = "codhud/menu/mw2/ui_screen_in1.mp3",
        menuclose = "codhud/menu/mw2/ui_screen_out1.mp3",
        hover = "codhud/menu/mw2/ui_over_v2.mp3",
        confirm = "codhud/menu/mw2/ui_select_hz_1.mp3",
        clickopen = "codhud/menu/mw2/ui_select_hz_1.mp3",
    },
    -- ["bo1"] = {
        -- menuopen = "codhud/menu/mw2/ui_screen_in1.mp3",
        -- menuclose = "codhud/menu/mw2/ui_screen_out1.mp3",
        -- hover = "codhud/menu/mw2/ui_over_v2.mp3",
        -- confirm = "codhud/menu/mw2/ui_select_hz_1.mp3",
        -- clickopen = "codhud/menu/mw2/ui_select_hz_1.mp3",
    -- },
    ["mw3"] = {
        menuopen = "codhud/menu/mw3/ui_screen_in1.mp3",
        menuclose = "codhud/menu/mw3/ui_screen_out1.mp3",
        hover = "codhud/menu/mw3/nav_hover.mp3",
        confirm = "codhud/menu/mw3/nav_positive.mp3",
        clickopen = "codhud/menu/mw3/nav_positive.mp3",
    },
    ["bo2"] = {
        menuopen = "codhud/menu/bo2/cac_globe_draw.LN65.pc.snd.mp3",
        menuclose = "codhud/menu/bo2/cac_screen_fade.LN65.pc.snd.mp3",
        hover = "codhud/menu/bo2/cac_main_nav.LN65.pc.snd.mp3",
        confirm = "codhud/menu/bo2/cac_enter.LN65.pc.snd.mp3",
        clickopen = "codhud/menu/bo2/cac_enter.LN65.pc.snd.mp3",
    },
}

-- Store all menus globally
CoDHUDMenu.Menus = CoDHUDMenu.Menus or {}

function CoDHUD.PlayerCanSeeSetting(st)
	if st.sp and not game.SinglePlayer() then
		return false
	end
	
	if st.developer then
		local ply = LocalPlayer()
		if not IsValid(ply) then return false end
		if GetConVar("developer"):GetInt() < 1 then return false end
	end
	
	if st.sv or st.admin then
		local ply = LocalPlayer()
		if not IsValid(ply) then return false end
		if not ply:IsAdmin() and not ply:IsSuperAdmin() then
		-- if ply:IsAdmin() and ply:IsSuperAdmin() then -- Reverse for debugging
			return false
		end
	end
	return true
end

-- Filtering logic similar to ARC9
function CoDHUD.ShouldDrawSetting(st)
	if not CoDHUD.PlayerCanSeeSetting(st) then
		return false
	end

	if st.showfunc and st.showfunc() == false then return false end
	if st.cond and st.cond() == false then return false end

	if st.requireparentconvarvariable then
		local c = GetConVar(st.requireparentconvarvariable)
		if c then
			local value = c:GetString()
			local allowed = st.requireparentconvarvalue or st.requireparentconvarvariable -- fallback

			local active
			if istable(allowed) then
				active = table.HasValue(allowed, value)
			else
				active = (value == allowed)
			end

			if st.parentinvert then active = not active end
			if not active then return false end
		end

	elseif st.requireparentconvar then
		local c = GetConVar(st.requireparentconvar)
		if c then
			local v = c:GetBool()
			if st.parentinvert then v = not v end
			if not v then return false end
		end

	elseif st.parentconvar then
		local c = GetConVar(st.parentconvar)
		if c then
			local v = c:GetBool()
			if st.parentinvert then v = not v end
			if not v then return false end
		end
	end

	if st.requireconvar then
		local c = GetConVar(st.requireconvar)
		if c and not c:GetBool() then return false end
	end

	if st.requireconvaroff then
		local c = GetConVar(st.requireconvaroff)
		if c and c:GetBool() then return false end
	end

	return true
end

-- Returns a table of lines and the font used based on the text and max width
function CoDHUDTextSplit(text, maxWidth, baseFont, altFont)
    baseFont = baseFont or "CoDHUD_Settings_Main"
    altFont = altFont or "CoDHUD_Settings_Sec"
    
    local paragraphs = string.Split(text, "\n")
    local wrappedLines = {}

    for _, paragraph in ipairs(paragraphs) do
        if paragraph == "" then
            table.insert(wrappedLines, "")
        else
            for _, line in ipairs(CoDHUD_WrapText(paragraph, baseFont, maxWidth)) do
                table.insert(wrappedLines, line)
            end
        end
    end

    local chosenFont = #wrappedLines >= 3 and altFont or baseFont
    return wrappedLines, chosenFont
end

-- Helper to draw wrapped text inside a panel
local function DrawWrappedText(panel, text, maxWidth, x, y, center, altfont, altsmallfont, textcol)
    local wrappedLines, font = CoDHUDTextSplit(text, maxWidth, altfont or nil, altsmallfont or nil)
    surface.SetFont(font)
    local _, lineHeight = surface.GetTextSize("A")
    local totalHeight = lineHeight * #wrappedLines
    local startY = y or (panel:GetTall() - totalHeight) / 2
    local color = textcol or Color(255, 255, 255, panel:GetAlpha() or 255)
	local center = center and TEXT_ALIGN_CENTER or TEXT_ALIGN_LEFT

    for i, line in ipairs(wrappedLines) do
        -- draw.DrawText(line, font, x or 10, startY + (i-1)*lineHeight, color, center)
		draw.SimpleTextOutlined(line, font, x or 10, startY + (i-1)*lineHeight, color, center, TEXT_ALIGN_LEFT, 1.5, color_black)
    end
end

-- Returns required height for given text and max width
local function GetDynamicTall(text, maxWidth, baseFont, altFont)
    local lines, font = CoDHUDTextSplit(text, maxWidth, baseFont, altFont)
    surface.SetFont(font)
    local _, lineHeight = surface.GetTextSize("A")
    local padding = 0 -- optional padding
    return (#lines * lineHeight) + padding
end

-- Custom Dropdown panel
local CoDHUDDropdown = {}

function CoDHUDDropdown:Init()
	self:SetTall(CoDHUD_S(28))
	self:SetCursor("hand")

	self.Open = false
	self.Value = nil
	self.Choices = {}

	self.Button = vgui.Create("DButton", self)
	self.Button:Dock(FILL)
	self.Button:SetText("")
	self.Button.DoClick = function()
		self:Toggle()
	end

	self.Button.Paint = function(btn, w, h)
		DrawWrappedText(self, self.Value or "???", self:GetWide(), w * 0.5, nil, true, "CoDHUD_Settings_Tri", "CoDHUD_Settings_Tri")
		draw.SimpleTextOutlined( self.Open and "▲" or "▼", "CoDHUD_Settings_Tri", w - 14, h*0.45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )
		
		-- draw.SimpleText( self.Value or "???", "CoDHUD_Settings_Sec", 12, h * 0.45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		-- draw.SimpleText( self.Open and "▲" or "▼", "CoDHUD_Settings_Sec", w - 14, h * 0.45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function CoDHUDDropdown:AddChoice(text, data)
	table.insert(self.Choices, {text = CoDHUDString(text), data = data})
end

function CoDHUDDropdown:SetValue(text, data)
	self.Value = CoDHUDString(text)
	self.Data = data
end

function CoDHUDDropdown:Toggle()
	if self.Open then
		self:CloseList()
	else
		self:OpenList()
	end
end

function CoDHUDDropdown:OpenList()
	if IsValid(self.List) then return end
	self.Open = true

	-- Create dropdown panel
	self.List = vgui.Create("DPanel", self:GetParent())
	self.List:SetWide(self:GetWide())
	self.List:MakePopup()
	self.List:SetKeyboardInputEnabled(false)

	-- Track globally
	CoDHUDMenu.OpenDropdowns = CoDHUDMenu.OpenDropdowns or {}
	table.insert(CoDHUDMenu.OpenDropdowns, self.List)

	self.List.OnRemove = function(pnl)
		for i, v in ipairs(CoDHUDMenu.OpenDropdowns) do
			if v == pnl then
				table.remove(CoDHUDMenu.OpenDropdowns, i)
				break
			end
		end
	end

	local x, y = self:LocalToScreen(0, self:GetTall() + 2)

	-- Determine menu boundaries
	local menu = self:GetParent()
	while IsValid(menu:GetParent()) do
		menu = menu:GetParent()
	end
	local mx, my = menu:LocalToScreen(0, 0)
	local mw, mh = menu:GetSize()

	-- local maxHeight = #self.Choices * 26
	local maxHeight = CoDHUD_SY(40 * #self.Choices)
	local spaceBelow = (my + mh) - y
	local spaceAbove = y - my
	local listHeight = math.min(maxHeight, 260)

	-- Flip dropdown if not enough space below
	if listHeight > spaceBelow and spaceAbove > spaceBelow then
		listHeight = math.min(listHeight, spaceAbove - 4)
		y = y - listHeight - 2
	else
		listHeight = math.min(listHeight, spaceBelow - 4)
	end

	self.List:SetSize(self:GetWide(), listHeight)
	self.List:SetPos(x, y)

	-- Close on click outside dropdown
	self.List._wasMouseDown = false
	self.List.Think = function(pnl)
		if not IsValid(self) then pnl:Remove() return end

		local mouseDown = input.IsMouseDown(MOUSE_LEFT)
		if pnl._wasMouseDown and not mouseDown then
			local mx, my = gui.MousePos()
			local bx, by = self:LocalToScreen(0, 0)
			local bw, bh = self:GetSize()

			-- Check if inside dropdown
			local inList = false
			for _, pnl2 in ipairs(CoDHUDMenu.OpenDropdowns or {}) do
				if IsValid(pnl2) then
					local px, py = pnl2:LocalToScreen(0, 0)
					local pw, ph = pnl2:GetSize()
					if mx >= px and mx <= px + pw and my >= py and my <= py + ph then
						inList = true
						break
					end
				end
			end

			local inButton = mx >= bx and mx <= bx + bw and my >= by and my <= by + bh

			if not inList and not inButton then
				self:CloseList()
			end
		end

		pnl._wasMouseDown = mouseDown
	end

	-- Background
	self.List.Paint = function(p, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 240))
	end

	-- Scroll panel
	local scroll = vgui.Create("DScrollPanel", self.List)
	scroll:Dock(FILL)
	scroll:DockMargin(4, 4, 4, 4)
	scroll.OnMouseWheeled = function(pnl, delta)
		pnl:GetVBar():AddScroll(-delta * 1)
		return true
	end

	-- Options
	for _, v in ipairs(self.Choices) do
		local opt = scroll:Add("DButton")
		opt:SetTall(CoDHUD_S(32))
		opt:Dock(TOP)
		opt:DockMargin(0, 0, 0, 2)
		opt:SetText("")

		function opt:PerformLayout()
			local text = v.text
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(CoDHUD_S(32), GetDynamicTall(text, w, "CoDHUD_Settings_Tri", "CoDHUD_Settings_Tri"))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		
		opt.Paint = function(btn, w, h)
			local hovered = btn:IsHovered()
			draw.RoundedBox(6, 0, 0, w, h, hovered and Color(80, 80, 80, 220) or Color(60, 60, 60, 200))
			DrawWrappedText(self, v.text, self:GetWide(), w * 0.5, h * 0.05, true, "CoDHUD_Settings_Tri", "CoDHUD_Settings_Tri")
		end

		opt.DoClick = function()
			self:SetValue(v.text, v.data)
			if self.OnSelect then
				self:OnSelect(v.text, v.data)
			end
			self:CloseList()
		end
	end

	-- Fix default display text if not set
	if not self.Value and #self.Choices > 0 then
		self:SetValue(self.Choices[1].text, self.Choices[1].data)
	end
end

function CoDHUDDropdown:CloseList()
	self.Open = false
	if IsValid(self.List) then
		self.List:Remove()
	end
end

vgui.Register("CoDHUDCombo", CoDHUDDropdown, "DPanel")

-- Build one setting (label / bool / slider / combo / button)
function CoDHUD.BuildSetting(parent, st, descPanel, promptBar)
	local function GetDisplayText()
		local prefix = ""

		local parentName
		local checkType

		if st.requireparentconvarvariable then
			parentName = st.requireparentconvarvariable
			checkType = "string"
		elseif st.requireparentconvarfloat then
			parentName = st.requireparentconvarfloat
			checkType = "float"
		else
			parentName = st.parentconvar or st.requireparentconvar
			checkType = "bool"
		end
		
		if st.showprefix then prefix = "	> " end
		
		if parentName then
			local cv = GetConVar(parentName)
			if cv then
				local active

				if checkType == "float" then
					active = cv:GetFloat() > 0
				elseif checkType == "string" then
					local value = cv:GetString()
					local allowed = st.requireparentconvarvalue or st.requireparentconvarvariable

					if istable(allowed) then
						active = table.HasValue(allowed, value)
					else
						active = (value == allowed)
					end
				else
					active = cv:GetBool()
				end

				if st.parentinvert then active = not active end
				if st.showprefix then active = true end

				if active then
					prefix = "	> "
				end
			end
		end
		
		if st.noprefix then prefix = "" end

		return prefix .. CoDHUDString(st.text)
	end
	
	-- if st is an information panel
	if st.type == "info" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 2)
		p:SetPaintBackground(false)

		local rawText = CoDHUDString(st.text or "") or ""
		rawText = CoDHUDReplaceKeybinds(rawText, "Small")
		rawText = CoDHUDDiscordTextFormat(rawText)

		local mk
		local lastWidth = 0
		local padding = 10

		function p:Rebuild()
			local w = self:GetWide()
			if w <= 0 then return end

			local text = rawText

			mk = markup.Parse(
				"<font=" .. (st.font or "CoDHUD_Settings_Tri") .. ">" .. text .. "</font>",
				w - 20
			)

			self:SetTall(mk:GetHeight() + 20)
		end

		function p:PerformLayout()
			local w = self:GetWide()
			if w ~= lastWidth then
				lastWidth = w
				self:Rebuild()
			end
		end

		function p:Paint(w, h)
			surface.SetDrawColor(28, 28, 28, 150)
			surface.DrawRect(0, 0, w, h)

			if mk then
				mk:Draw(10, 10)
			end
		end

		return p
	end

	-- if st is a header label
	if st.type == "infosimple" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		function p:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(CoDHUD_S(32), GetDynamicTall(text, w, "CoDHUD_Settings_Main", "CoDHUD_Settings_Main"))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
			local text = GetDisplayText() or "???"
			DrawWrappedText(self, text, self:GetWide(), w * 0.5, nil, true, "CoDHUD_Settings_Main", "CoDHUD_Settings_Main")
		end

		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end
		
		return p
	end

	-- if st is a singular image
	if st.type == "image" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(60, 6, 60, 2)

		local mat = Material(st.image or "", "smooth")
		local mode = st.mode or "fit" 

		if not mat or mat:IsError() then
			-- p.Paint = function(self, w, h)
				-- draw.SimpleText(
					-- "/// Missing image ///",
					-- "CoDHUD_Settings_Tri",
					-- w / 2,
					-- h / 2,
					-- color_white,
					-- TEXT_ALIGN_CENTER,
					-- TEXT_ALIGN_CENTER
				-- )
			-- end
			-- return p
			
			mat = Material("unitvehicles/icons_settings/pnotes/1.0.0.png", "smooth")
		end

		-- Cache image size
		local iw, ih = mat:Width(), mat:Height()
		local aspect = (iw > 0 and ih > 0) and (ih / iw) or (9 / 16)

		-- Optional text config
		local font  = st.font or "CoDHUDFont5"
		local xPos  = st.XPos or 0.5
		local yPos  = st.YPos or 0.01

		-- Layout based on image aspect
		-- p.PerformLayout = function(self, w, h)
			-- self:SetTall(math.floor(w * aspect))
		-- end
		
		p.PerformLayout = function(self, w, h)
			if mode == "icon" then
				self:SetTall(st.fixedSize or 64)
			else
				local targetH = math.floor(w * aspect)
				self:SetTall(targetH)
			end
		end

		p.Paint = function(self, w, h)
			-- Background
			-- surface.SetDrawColor(0, 0, 0, 200)
			-- surface.DrawRect(0, 0, w, h)

			if iw == 0 or ih == 0 then return end

			-- Letterboxed image
			local ratio = math.min(w / iw, h / ih)
			local fw, fh = iw * ratio, ih * ratio
			local x = (w - fw) * 0.5
			local y = (h - fh) * 0.5

			surface.SetMaterial(mat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(x, y, fw, fh)

			-- Optional overlay text (infosimple-style)
			if st.text then
				if st.text and st.text ~= "" then
					DrawWrappedText( self, CoDHUDString(st.text), w - CoDHUD_SX(20), w * xPos, h * yPos, true, font, font )
				end
			end
		end

		-- Optional desc hover behavior (same as infosimple)
		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end

		return p
	end

	-- if st is a header label
	if st.type == "label" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		function p:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(CoDHUD_S(36), GetDynamicTall(text, w*0.8))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
			local bg = Color( 100, 100, 100, 75 )
			
			draw.RoundedBox(4, 0, 0, w, h, bg)
			draw.SimpleTextOutlined(CoDHUDString(st.text), "CoDHUD_Settings_Sec", w*0.5, h*0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black)
		end
		
		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end
		
		return p
	end

	---- boolean custom button ----
	if st.type == "bool" then
		local wrap = vgui.Create("DButton", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(CoDHUD_S(30), GetDynamicTall(text, w - 44))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		wrap:SetText("")
		wrap:SetCursor("hand")

		local localvar = false
		local cv = GetConVar(st.convar or "")
		local function getBool()
			if cv then return cv:GetBool() end
			return localvar
		end

		wrap.DoClick = function()
			if not cv then  
				localvar = not localvar
				CoDHUDMenu.PlaySFX("confirm")
				if descPanel and st.convar then
					descPanel.SelectedCurrent = localvar and "1" or "0"
				end
				if st.func then pcall(st.func, localvar) end
				return
			end
			local new = getBool() and "0" or "1"
			if st.sv and string.match(st.convar, 'codhud_') then
				CoDHUD_SetServerConVar(st.convar, new)
			else
				cv:SetString( new )
			end
			CoDHUDMenu.PlaySFX("confirm")
			if descPanel and st.convar then
				descPanel.SelectedCurrent = new
			end
			if st.func then pcall(st.func, new) end
		end

		wrap.OnCursorEntered = function()
			CoDHUDMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetBool() and "1" or "0"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "CoDHUD.Glyph.Toggle", "CoDHUD.Glyph.Reset" } end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
				if promptBar then promptBar.Prompts = nil end
			end
		end

		wrap.Paint = function(self, w, h)
			local enabled = getBool()
			local hovered = self:IsHovered()

			local bga = hovered and 200 * math.abs(math.sin(RealTime()*4)) or 200 * 0.75
			local bg

			local default = Color(  125, 125, 125, bga )
			local active = Color( 58, 193, 0, bga )
			
			bg = enabled and active or default

			-- background & text
			draw.RoundedBox(6, w - 34, 0, 30, h, bg)
			DrawWrappedText(self, GetDisplayText(), w - 44, 10, nil)
		end

		-- dynamic update when convar changes - simple timer check
		wrap.Think = function(self)
			-- nothing heavy; updates on click via convar toggle
		end
		
		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_RIGHT and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					if st.sv and string.match(st.convar, 'codhud_') then
						CoDHUD_SetServerConVar(st.convar, new)
					else
						cv:SetString( cv:GetDefault() )
					end
					CoDHUDMenu.PlaySFX("confirm")
				end
				return
			end
			-- existing left-click handling:
			if mc == MOUSE_LEFT then
				self:DoClick()
			end
		end

		return wrap
	end

	---- slider: label left, slider right ----
	if st.type == "slider" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(CoDHUD_S(30), GetDynamicTall(text, w * 0.4))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		wrap.Paint = function(self, w, h)
			local text = CoDHUDString(GetDisplayText()) or "???"
			DrawWrappedText(self, text, w * 0.425, 10)
			
			-- draw.RoundedBox(4, 0, 0, w * 0.425, h, Color(255, 255, 255))
		end

		local function PushDesc()
			CoDHUDMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or st.command or "?"
				elseif st.command then
					descPanel.SelectedConVar = st.command or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "CoDHUD.Glyph.Reset" } end
		end
		local function PopDesc()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				elseif st.command then
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end
		wrap.OnCursorEntered = PushDesc
		wrap.OnCursorExited  = PopDesc

		local slider = vgui.Create("DNumSlider", wrap)
		slider:Dock(RIGHT)
		slider:SetWide(CoDHUD_SX(250))
		slider:DockMargin(26, 0, 6, 0)
		slider:SetContentAlignment(5)
		slider:SetMin(st.min or 0)
		slider:SetMax(st.max or 100)
		slider:SetDecimals(st.decimals or 0)
		slider:SetValue(st.min or 0)
		slider.Label:SetVisible(false)
		slider.TextArea:SetVisible(false)
		slider.OnCursorEntered = PushDesc
		slider.OnCursorExited  = PopDesc

		local valPanel = vgui.Create("DPanel", wrap)
		valPanel:SetWide(CoDHUD_SX(84))
		valPanel:Dock(RIGHT)
		valPanel.Paint = function() end

		local valBox = vgui.Create("DTextEntry", valPanel)
		valBox:SetWide(CoDHUD_SX(80))
		valBox:SetFont("CoDHUD_Settings_Tri")
		valBox:SetTextColor(color_white)
		valBox:SetHighlightColor(Color(58,193,0))
		valBox:SetCursorColor(Color(58,193,0))
		valBox.Paint = function(self2, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(30,30,30,200))
			self2:DrawTextEntryText(color_white, Color(58,193,0), color_white)
		end
		valBox.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or st.command or "?"
				elseif st.command then
					descPanel.SelectedConVar = st.command or "?"
				end
			end
			-- if promptBar then promptBar.Prompts = { "CoDHUD.Glyph.Confirm" } end
		end
		valBox.OnCursorExited  = PopDesc

		-- Only validate on enter/apply, allow free typing
		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if v then
				-- store as pending value but don't overwrite with applied yet
				pendingValue = v
				applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
			end
		end

		local applyBtn = vgui.Create("DButton", wrap)
		applyBtn:SetSize(CoDHUD_SX(25), CoDHUD_S(25))
		applyBtn:Dock(RIGHT)
		applyBtn:SetText(" ")
		applyBtn:SetVisible(false)
		applyBtn.Paint = function(self2, w, h)
			draw.RoundedBox(4,0,0,w,h,self2:IsHovered() and Color(60,180,60) or Color(45,140,45))
			draw.SimpleText("✔", "CoDHUD_Settings_Sec", w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		applyBtn.OnCursorEntered = function()
			CoDHUDMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or st.command or "?"
				elseif st.command then
					descPanel.SelectedConVar = st.command or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "CoDHUD.Glyph.Confirm" } end
		end
		applyBtn.OnCursorExited  = PopDesc

		-- Vertically center value box and button
		local function LayoutValPanel()
			if not (IsValid(valBox) and IsValid(applyBtn)) then return end

			local offsetY = (wrap:GetTall() - valBox:GetTall()) / 2
			valBox:SetPos(0, offsetY)

			local btnX = valBox:GetWide() + 4
			-- applyBtn:SetPos(valPanel:GetX() + btnX, offsetY)
		end

		wrap.OnSizeChanged = LayoutValPanel

		local appliedValue = st.min or 0
		local pendingValue = appliedValue

		local function RoundValue(val)
			if st.decimals then
				local factor = 10 ^ st.decimals
				return math.floor(val * factor + 0.5) / factor
			end
			return val
		end

		local function ApplyPendingValue()
			local val = RoundValue(pendingValue)
			appliedValue = val
			if st.convar and GetConVar(st.convar) then
				if st.sv and string.match(st.convar, 'codhud_') then
					CoDHUD_SetServerConVar(st.convar, val)
				else
					GetConVar(st.convar):SetString( tostring(val) )
				end
			elseif st.command then
				RunConsoleCommand(st.command, tostring(val))
			end
			if st.func then pcall(st.func, val) end
			valBox:SetText(string.format("%."..(st.decimals or 2).."f", val))
			applyBtn:SetVisible(false)
			CoDHUDMenu.PlaySFX("confirm")
		end

		valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
		slider:SetValue(appliedValue)

		local typing = false

		valBox.OnGetFocus = function()
			typing = true
			if IsValid(CoDHUD.SettingsFrame) then
				CoDHUD.SettingsFrame:SetKeyboardInputEnabled(true)
			end
		end

		valBox.OnLoseFocus = function()
			typing = false
			if IsValid(CoDHUD.SettingsFrame) then
				CoDHUD.SettingsFrame:SetKeyboardInputEnabled(false)
			end
		end

		slider.OnValueChanged = function(_, val)
			pendingValue = val
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)

			if not typing and IsValid(valBox) then
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", val))
			end
		end

		valBox.OnEnter = function(self2)
			local v = tonumber(self2:GetValue()) or st.max
			if st.min then v = math.max(st.min, v) end
			if st.max then v = math.min(st.max, v) end

			pendingValue = v
			slider:SetValue(v)
			ApplyPendingValue()
		end

		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if not v then return end
			pendingValue = v
			slider:SetValue(v)
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
		end

		applyBtn.DoClick = function()
			local v = tonumber(valBox:GetValue()) or st.max
			if st.min then v = math.max(st.min, v) end
			if st.max then v = math.min(st.max, v) end

			pendingValue = v
			slider:SetValue(v)
			ApplyPendingValue()
		end

		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				appliedValue = cv:GetFloat()
				pendingValue = appliedValue
				slider:SetValue(appliedValue)
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
			end
		end

		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_RIGHT and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					local def = tonumber(cv:GetDefault()) or st.min or 0
					slider:SetValue(def)
					valBox:SetText(tostring(def))
					pendingValue = def
					applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
				end
			end
		end

		return wrap
	end

	---- combo: label left, dropdown right ----
	if st.type == "combo" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		wrap.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "CoDHUD.Glyph.Reset" } end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		local combo = vgui.Create("CoDHUDCombo", wrap)
		combo:Dock(RIGHT)
		combo:SetWide(CoDHUD_SX(250))
		combo:DockMargin(6, 3, 6, 3)
		combo.Paint = function(self, w, h)
			local hovered = self.Button:IsHovered()
			local default = Color( 125, 125, 125, 125 )
			local hover = Color( 125, 125, 125, 200 * math.abs(math.sin(RealTime()*4)) )

			-- background & text
			draw.RoundedBox(12, 0, 0, w, h, default)
			if hovered then draw.RoundedBox(12, 0, 0, w, h, hover) end
		end
		
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(CoDHUD_S(30), GetDynamicTall(text, w - combo:GetWide() - 20))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		wrap.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local bga = hovered and 200 or 125
			local bg = Color( 125, 125, 125, 0 )
			
			if enabled then
				bg = Color( 58, 193, 0, bga )
			end
			
			draw.RoundedBox(6, 0, 0, w, h, bg)
			DrawWrappedText(self, GetDisplayText(), w - combo:GetWide() - 20, 10)
		end

		for _, entry in ipairs(st.content or {}) do
			combo:AddChoice(entry[1], entry[2])
		end

		-- Default value
		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				local val = cv:GetString() -- ConVar value as string
				local matched = false

				for _, v in ipairs(st.content or {}) do
					-- Detect numeric vs string
					if type(v[2]) == "number" then
						if tonumber(val) == v[2] then
							combo:SetValue(v[1], v[2])
							matched = true
							break
						end
					else
						if val == tostring(v[2]) then
							combo:SetValue(v[1], v[2])
							matched = true
							break
						end
					end
				end

				if not matched and #st.content > 0 then
					combo:SetValue(st.content[1][1], st.content[1][2])
				end
			end
		elseif st.text then
			combo:SetValue(CoDHUDString(st.text), nil)
		end

		combo.OnSelect = function(_, val, data)
			if st.convar then
				if st.sv and string.match(st.convar, 'codhud_') then
					CoDHUD_SetServerConVar(st.convar, data)
				else
					GetConVar(st.convar):SetString( data )
				end
			end
			if st.func then
				st.func(combo, val, data)
			end
		end

		combo.Button.OnCursorEntered = function()
			CoDHUDMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					local cv = GetConVar(st.convar)
					descPanel.SelectedDefault = cv and cv:GetDefault() or "?"
					descPanel.SelectedCurrent = cv and cv:GetString() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "CoDHUD.Glyph.Open", "CoDHUD.Glyph.Reset" } end
		end

		combo.Button.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_RIGHT and st.convar then
				local cv = GetConVar(st.convar)
				if not cv then return end

				local def = cv:GetDefault() -- default value as string
				local matched = false

				-- find matching display text
				for _, v in ipairs(st.content or {}) do
					if tostring(v[2]) == tostring(def) then
						combo:SetValue(v[1], v[2])   -- set both text and data
						CoDHUDMenu.PlaySFX("hover")
						matched = true
						break
					end
				end

				-- fallback if no match found
				if not matched and #st.content > 0 then
					combo:SetValue(st.content[1][1], st.content[1][2])
				end

				if st.sv and string.match(st.convar, 'codhud_') then
					CoDHUD_SetServerConVar(st.convar, def)
				else
					GetConVar(st.convar):SetString( def )
				end
			end
		end

		return wrap
	end

	---- button ----
	if st.type == "button" then
		local btn = vgui.Create("DButton", parent)
		btn:Dock(TOP)
		btn:DockMargin(6, 6, 6, 6)
		function btn:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(CoDHUD_S(30), GetDynamicTall(text, w * 0.95))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		btn:SetText("")
		btn.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local default = Color( 125, 125, 125, 125 )
			local hover = Color( 125, 125, 125, 200 * math.abs(math.sin(RealTime()*4)) )

			-- background & text
			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
			if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
			DrawWrappedText(self, GetDisplayText(), w * 0.95, w*0.5, nil, true)
		end
		
		btn.DoClick = function(self)
			if st.playsfx then CoDHUDMenu.PlaySFX(st.playsfx) end
			if st.func then st.func(self) end
			if st.convar and not st.func then
				RunConsoleCommand(st.convar)
			end
		end
		btn.OnCursorEntered = function()
			CoDHUDMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = st.prompts or nil end
		end
		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		return btn
	end

	---- factions ----
	if st.type == "factions" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 6)

		p.Paint = function() end

		local grid = vgui.Create("DGrid", p)
		grid:Dock(TOP)
		grid:SetCols(3)
		grid:SetColWide(CoDHUD_S(128))
		grid:SetRowHeight(CoDHUD_S(128))
		
		function p:PerformLayout()
			local cols = grid:GetCols() or 3
			local count = #grid:GetItems() or 0

			local rows = math.ceil(count / cols)
			local cellSize = CoDHUD_S(128)

			local newTall = rows * cellSize + CoDHUD_S(16)

			if self:GetTall() ~= newTall then
				self:SetTall(newTall)
			end
		end

		local factions = CoDHUD.Factions[CoDHUD_GetHUDType()] or {}
		local factionCounts = {}

		for _, ply in ipairs(player.GetAll()) do
			local fac = ply:GetNW2String("CoDHUD_Faction", "rangers")
			if fac == "" then fac = "rangers" end
			factionCounts[fac] = (factionCounts[fac] or 0) + 1
		end

		local sorted = {}
		for id, factionData in pairs(factions) do
			table.insert(sorted, {id = id, data = factionData})
		end

		table.sort(sorted, function(a, b)
			return (a.data.order or 0) < (b.data.order or 0)
		end)

		for _, entry in ipairs(sorted) do
			local id = entry.id
			local faction = entry.data
			local count = factionCounts[id] or 0

			local btn = vgui.Create("DImageButton")
			btn:SetSize(CoDHUD_S(128), CoDHUD_S(128))

			if faction.scoreIcon then
				btn:SetImage(faction.scoreIcon)
			end

			local current = LocalPlayer():GetNW2String("CoDHUD_Faction", "rangers")

			btn.OnCursorEntered = function()
				CoDHUDMenu.PlaySFX("hover")
				if descPanel then
					descPanel.Desc = language.GetPhrase(faction.name) or id:upper()
				end
				if promptBar then promptBar.Prompts = st.prompts or nil end
			end
			btn.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
				if promptBar then promptBar.Prompts = nil end
			end


			btn.DoClick = function()
				local cur = LocalPlayer():GetNW2String("CoDHUD_Faction", "rangers")
				if id == cur then return end

				local mode = CoDHUD.RestrictFactions or 1
				if mode == 0 then return end

				if mode == 2 then
					local pool = CoDHUD.Factions.ActivePool or {}
					if not table.HasValue(pool, id) then return end
				end

				if CoDHUDMenu.ConfirmFactionChange then
					CoDHUDMenu.PlaySFX("confirm")
					-- CoDHUDMenu.CloseCurrentMenu(true)
					-- timer.Simple(tonumber(GetConVar("codhud_menu_closespeed"):GetString()) or 0.2, function()
						CoDHUDMenu.OpenMenu(CoDHUDMenu.ConfirmFactionChange(id), true)
						-- CoDHUDMenu.PlaySFX("menuopen")
					-- end)
				end
			end

			btn.PaintOver = function(self, w, h)
				local current = LocalPlayer():GetNW2String("CoDHUD_Faction", "rangers")
				local mode = CoDHUD.RestrictFactions

				local blocked = false

				if id ~= current then
					if mode == 0 then
						blocked = true
					elseif mode == 2 then
						local pool = CoDHUD.Factions.ActivePool or {}
						if not table.HasValue(pool, id) then
							blocked = true
						end
					end
				end

				-- Darken blocked factions
				if blocked then
					surface.SetDrawColor(0, 0, 0, 180)
					surface.DrawRect(0, 0, w, h)
				end

				-- Existing selection highlight
				if current == id then
					surface.SetDrawColor(255, 255, 255, 60)
					surface.DrawOutlinedRect(0, 0, w, h, 4)

					surface.SetDrawColor(255, 255, 255, 255)
					surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
				end

				if count > 0 then
					local txt = tostring(count)
					surface.SetFont("DermaDefaultBold")
					local tw, th = surface.GetTextSize(txt)

					draw.RoundedBox(4, w - tw - 16, 4, tw + 10, th + 6, Color(0,0,0,200))
					draw.SimpleText(txt, "DermaDefaultBold", w - 11, 7, color_white, TEXT_ALIGN_CENTER)
				end
			end

			grid:AddItem(btn)
		end

		return p
	end

	-- fallback: do nothing
	return nil
end

CoDHUD_WrapCache = CoDHUD_WrapCache or {}

function CoDHUD_WrapText(text, font, maxwidth)
	local cacheKey = font .. "|" .. tostring(maxwidth) .. "|" .. text

	-- return cached result if it exists
	local cached = CoDHUD_WrapCache[cacheKey]
	if cached then
		return cached
	end

	-- compute wrapped lines
	surface.SetFont(font)

	local lines = {}
	local curline = ""

	local words = string.Explode(" ", text)

	local function utf8_chars(str)
		return string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*")
	end

	for _, word in ipairs(words) do
		local test = (curline == "" and word) or (curline .. " " .. word)
		local w = surface.GetTextSize(test)

		if w > maxwidth then
			if surface.GetTextSize(word) > maxwidth then
				for char in utf8_chars(word) do
					local test2 = curline .. char
					if surface.GetTextSize(test2) > maxwidth then
						if curline ~= "" then
							table.insert(lines, curline)
						end
						curline = char
					else
						curline = test2
					end
				end
			else
				if curline ~= "" then
					table.insert(lines, curline)
				end
				curline = word
			end
		else
			curline = test
		end
	end

	if curline ~= "" then
		table.insert(lines, curline)
	end

	-- store result
	CoDHUD_WrapCache[cacheKey] = lines
	return lines
end

-- Plays Sound SFX for the menu
function CoDHUDMenu.PlaySFX(name, overrideSet)
    if not GetConVar("codhud_menu_sounds"):GetBool() then return end
    name = tostring(name or "")
    local setName = CoDHUD_GetHUDType() or "mw2"
    local setTbl = CoDHUDMenu.Sounds[setName] or CoDHUDMenu.Sounds["mw2"]
    if not setTbl then return end
    local snd = setTbl[name]
    if not snd or snd == "" then return end
	
    surface.PlaySound(snd)
end

function CoDHUDMenu.EstimateTabHeight(tab, availableWidth)
	local h = 0

	if tab.TabName and tab.TabName ~= "" then
		local text = CoDHUDString(tab.TabName)
		local base = math.max(CoDHUD_S(48), GetDynamicTall(text, availableWidth - 44, "CoDHUDFont5") )

		h = h + base
	end

	for _, st in ipairs(tab) do
		if istable(st) and st.type and CoDHUD.ShouldDrawSetting(st) then
			local base
			local text = CoDHUDString(st.text) or ""

			if st.type == "info" then
				local rawText = CoDHUDReplaceKeybinds(text, "Small")
				rawText = CoDHUDDiscordTextFormat(text)

				local available = availableWidth - 20
				if available < 1 then available = 1 end

				local mk = markup.Parse( "<font=CoDHUD_Settings_Tri>" .. rawText .. "</font>", available )

				base = (mk and mk:GetHeight() or 0) + 20
			elseif st.type == "infosimple" then
				base = math.max(CoDHUD_S(32), GetDynamicTall(text, availableWidth * 0.95, "CoDHUD_Settings_Main", "CoDHUD_Settings_Main"))
			elseif st.type == "image" then
				base = math.floor((availableWidth / 16) * 9)
			elseif st.type == "label" then
				base = math.max( CoDHUD_S(36), GetDynamicTall(CoDHUDString(text), availableWidth * 0.8) )
			elseif st.type == "slider" then
				base = math.max( CoDHUD_S(30), GetDynamicTall(CoDHUDString(text), availableWidth * 0.4) )
			elseif st.type == "combo" then
				base = math.max( CoDHUD_S(30), GetDynamicTall(CoDHUDString(text), availableWidth - CoDHUD_S(330) - 20) )
			elseif st.type == "button" then
				base = math.max( CoDHUD_S(30), GetDynamicTall(CoDHUDString(text), availableWidth * 0.95) )
			else
				base = CoDHUD_S(30)
			end

			h = h + base + CoDHUD_S(12)
		end
	end

	return h
end

-- Helper to open menus safely
function CoDHUDMenu.OpenMenu(menuFunc, dontsave)
    if not dontsave and menuFunc then
        CoDHUDMenu.LastMenu = menuFunc
    end

    -- if CoDHUDMenu.CurrentMenu and IsValid(CoDHUDMenu.CurrentMenu) then
        -- CoDHUDMenu.CloseCurrentMenu(true)
        -- timer.Simple(tonumber(GetConVar("codhud_menu_closespeed"):GetString()) or 0.2, function()
            -- if menuFunc then
                -- menuFunc()
                -- CoDHUDMenu.CurrentMenu = CoDHUD.SettingsFrame
				-- CoDHUDMenu.PlaySFX("menuopen")
            -- end
        -- end)
        -- return
    -- end

    -- Open menu immediately if nothing is open
    if menuFunc then
        menuFunc()
        CoDHUDMenu.CurrentMenu = CoDHUD.SettingsFrame
    end
end

-- Close the currently open menu with animation
function CoDHUDMenu.CloseCurrentMenu(noCloseSound)
    local frame = CoDHUDMenu.CurrentMenu or CoDHUD.SettingsFrame
    if not IsValid(frame) or frame._closing then return end

    -- Play close sound unless explicitly disabled OR convars disallow
    if not noCloseSound and GetConVar("codhud_menu_sounds"):GetBool() then CoDHUDMenu.PlaySFX("menuclose") end

    frame._closing = true
    frame._closeStart = CurTime()

    local closeSpeed = tonumber(GetConVar("codhud_menu_closespeed"):GetString()) or 0.2
    frame._closeFadeDur = closeSpeed * 0.5
    frame._closeShrinkDur = closeSpeed
    frame._closeShrinkStart = frame._closeStart + frame._closeFadeDur * 0.5

    CoDHUDMenu.CurrentMenu = nil
end

-- Opens a CoDHUDMenu menu
function CoDHUDMenu:Open(menu)
    local CurrentMenu = menu or {}
    local Name = CurrentMenu.Name or CoDHUDString("uv.unitvehicles")
	
	local BaseMenuW = 1400
	local BaseMenuH = 900
	local Width = CurrentMenu.Width or math.min( CoDHUD_SX(BaseMenuW), ScrW() * 0.92 )
	
	if CurrentMenu.DynamicHeight and CurrentMenu.Tabs and #CurrentMenu.Tabs == 1 then
		local SCROLL_SAFETY = math.max(CoDHUD_S(14), CoDHUD_S(1))
		
		local tab = CurrentMenu.Tabs[1]
		local contentH = CoDHUDMenu.EstimateTabHeight(tab, CurrentMenu.Width)

		local chromePadding = CoDHUD_S(140)

		local maxH = ScrH() * 0.92
		local desiredH = contentH + chromePadding

		if desiredH >= maxH then
			CurrentMenu.Height = maxH - SCROLL_SAFETY
		else
			CurrentMenu.Height = desiredH
		end
	end

	local Height = CurrentMenu.Height or math.min( CoDHUD_S(BaseMenuH), ScrH() * 0.92 )

    local ShowDesc = CurrentMenu.Description == true and not GetConVar("codhud_menu_hide_desc"):GetBool()
    local Tabs = CurrentMenu.Tabs or {}
    local UnfocusClose = CurrentMenu.UnfocusClose == true
	local HideCloseButton = CurrentMenu.HideCloseButton == true
	local HidePrompts = GetConVar("codhud_menu_hide_prompts"):GetBool()
	
	-- if CurrentMenu.Description == true and GetConVar("codhud_menu_hide_desc"):GetBool() then
		-- Width = math.max(
			-- CoDHUD_SX(1000),
			-- Width * 0.75
		-- )
	-- end

    if IsValid(CoDHUD.SettingsFrame) then CoDHUD.SettingsFrame:Remove() end
    gui.EnableScreenClicker(true)

    local sw, sh = ScrW(), ScrH()
    local fw, fh = Width, Height
    local fx, fy = (sw - fw) * 0.5, (sh - fh) * 0.5
    local watchedConvars = {}
	local watchedConds = {}

    local frame = vgui.Create("DFrame")
    CoDHUD.SettingsFrame = frame
	frame:SetSize(fw, fh)
	frame:SetPos(fx, fy)
	frame:Center()
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)
	
	frame.Tabs = CurrentMenu.Tabs or {}

    frame.TargetWidth = fw
    frame.TargetHeight = fh

    local animStart = CurTime()
    local animDur = tonumber(GetConVar("codhud_menu_openspeed"):GetString()) or 0.2
    local primaryFadeStart = animStart + animDur * 0.5
    local primaryFadeDur = animDur * 1.25
    local secondaryFadeStart = animStart + animDur * 0.5
    local secondaryFadeDur = animDur * 1.25

	frame._fadeStart = CurTime()
	frame._fadeDur = tonumber(GetConVar("codhud_menu_openspeed"):GetString()) or 0.2
    frame._closing = false

    frame.TitleAlpha = 0

    -- Right description panel
    local descPanel
    if ShowDesc then
        descPanel = vgui.Create("DPanel", frame)
        descPanel:Dock(RIGHT)
        descPanel:SetWide(fw * 0.25)
        descPanel.Paint = function(self, w, h)
            local a = self:GetAlpha()
			local col = Color( 28, 28, 28, math.floor(150 * (a / 255)) )
            surface.SetDrawColor(col)

			if self.SelectedConVar then
				surface.DrawRect(0, h * 0.9, w, h)
				draw.SimpleText(self.SelectedConVar, "CoDHUD_Settings_Tri", w * 0.5, h * 0.98 - 40, Color(175, 175, 175, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			if self.SelectedDefault and self.SelectedDefault ~= "" then
				draw.SimpleText( string.format( CoDHUDString("uv.settings.default"), self.SelectedDefault ), "CoDHUD_Settings_Tri", 10, h * 0.98 - 20, Color(175, 175, 175, a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			if self.SelectedCurrent and self.SelectedCurrent ~= "" then
				draw.SimpleText(string.format( CoDHUDString("uv.settings.current"), self.SelectedCurrent ), "CoDHUD_Settings_Tri", 10, h * 0.98, Color(175, 175, 175, a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			
            if self.Text and a > 5 then
				local xPadding, yPadding = CoDHUD_SX(10), CoDHUD_S(10)
				local wrapWidth = w - xPadding * 2

				local desc = CoDHUDReplaceKeybinds(CoDHUDString(self.Desc) or "")

				local markupText = "<font=CoDHUD_Settings_Tri>" .. "<color=255,255,255," .. a .. ">" .. desc .. "</color></font>"

				local mk = markup.Parse(markupText, wrapWidth)
				
				surface.DrawRect(0, 0, w, mk:GetHeight() + (xPadding * 2))

				mk:Draw(xPadding, yPadding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end

        descPanel.Text = ""
        descPanel.Desc = ""
        descPanel.SelectedConVar = ""
        descPanel.SelectedDefault = ""
        descPanel.SelectedCurrent = ""
        descPanel:SetAlpha(0)
    end

    -- Center scroll panel
    local center = vgui.Create("DScrollPanel", frame)
    center:Dock(FILL)
    center:DockMargin(8, 8, 8, 8)
    center:SetAlpha(0)

	local sbar = center:GetVBar()
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sbar.btnUp:Paint(w, h)
		draw.SimpleTextOutlined( "▲", "CoDHUD_Settings_Sec", w * 0.5, h * 0.5, Color( 255, 255, 255, self:IsHovered() and 255 * math.abs(math.sin(RealTime()*4)) or 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )
	end
	function sbar.btnDown:Paint(w, h)
		draw.SimpleTextOutlined( "▼", "CoDHUD_Settings_Sec", w * 0.5, h * 0.5, Color( 255, 255, 255, self:IsHovered() and 255 * math.abs(math.sin(RealTime()*4)) or 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )
	end
	function sbar.btnGrip:Paint(w, h)
		local hovered = self:IsHovered()
		local default = Color( 125, 125, 125, 125 )
		local hover = Color( 125, 125, 125, 200 * math.abs(math.sin(RealTime()*4)) )
		
		draw.RoundedBox(12, 0, 0, w, h, hovered and hover or default)
	end

    -- Left tabs panel (only if >1 tab)
    local tabsPanel
    if #Tabs > 1 then
        tabsPanel = vgui.Create("DScrollPanel", frame)
        tabsPanel:Dock(LEFT)
        tabsPanel:SetWide(CoDHUD_SX(300))
		tabsPanel:Dock(LEFT)
        tabsPanel.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 0 )
			surface.DrawRect(0, 0, w, h)
		end

        tabsPanel:SetAlpha(0)
    end
	
	-- Bottom input prompt bar
	local promptBar
	if not HidePrompts then
		promptBar = vgui.Create("DPanel", frame)
		promptBar:Dock(BOTTOM)
		promptBar:SetTall(CoDHUD_S(32.5))
		promptBar:DockMargin(8, 0, 8, 8)
		promptBar:SetAlpha(0)

		promptBar.Prompts = nil

		promptBar.Paint = function(self, w, h)
			local a = self:GetAlpha()
			if a <= 5 then return end
			if not self.Prompts or #self.Prompts == 0 then return end

			local xPadding, yPadding = CoDHUD_SX(10), CoDHUD_S(5)
			local wrapWidth = w - xPadding * 2

			local resolved = {}

			for _, prompt in ipairs(self.Prompts) do
				local phrase = CoDHUDString(prompt)
				table.insert(resolved, phrase)
			end

			local text = table.concat(resolved, "      ")

			text = CoDHUDReplaceKeybinds(text)

			local markupText =
				"<font=CoDHUD_Settings_Sec>" ..
				"<color=255,255,255," .. a .. ">" ..
				text ..
				"</color></font>"

			local mk = markup.Parse(markupText, wrapWidth)
			
			surface.SetFont("CoDHUD_Settings_Sec")
            surface.SetDrawColor( 28, 28, 28, math.floor(150 * (a / 255)) )
			surface.DrawRect(0, 0, mk:GetWidth() + (xPadding * 2), h)
			
			mk:Draw(xPadding, yPadding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end

    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetSize(20, 20)
    closeBtn:SetText("")
    closeBtn:SetFont("DermaDefaultBold")
	if HideCloseButton then
		closeBtn:SetVisible(false)
		closeBtn:SetMouseInputEnabled(false)
		closeBtn:SetKeyboardInputEnabled(false)
	end

    closeBtn.DoClick = function()
        CoDHUDMenu.CloseCurrentMenu()
    end
    closeBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local bg = hovered and Color(200, 60, 60, self:GetAlpha()) or Color(140, 50, 50, self:GetAlpha())
        draw.RoundedBox(4, 0, 0, w, h, bg)
        draw.SimpleText("X", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn:SetAlpha(0)

	local primaryGroup = {}

	if not HideCloseButton then
		table.insert(primaryGroup, closeBtn)
	end

    local secondaryGroup = {center}
    if tabsPanel then table.insert(secondaryGroup, tabsPanel) end
    if descPanel then table.insert(secondaryGroup, descPanel) end
	if promptBar then table.insert(secondaryGroup, promptBar) end

    local CURRENT_TAB = 1

    -- Build tab content
    local function BuildTab(tabIndex)
        center.CurrentTabIndex = tabIndex
        center:Clear()
        if descPanel then
            descPanel.Text = ""
            descPanel.Desc = ""
        end

		local tab = Tabs[tabIndex]
		if not tab then return end

		if not tab.NoTitle then
			local title = vgui.Create("DLabel", center)
			title:SetText("")
			title:Dock(TOP)
			title:DockMargin(6, 6, 6, 12)

			function title:PerformLayout()
				local text = CoDHUDString(tab.TabName)
				local w = self:GetWide()
				if w <= 0 then return end
				local newTall = math.max(CoDHUD_S(48), GetDynamicTall(text, w - 44, "CoDHUDFont5"))
				if self:GetTall() ~= newTall then
					self:SetTall(newTall)
				end
			end

			title.Paint = function(self, w, h)
				DrawWrappedText(
					self,
					CoDHUDString(tab.TabName) or ("Tab " .. tostring(tabIndex)),
					w - 44,
					w * 0.5,
					nil,
					true,
					"CoDHUDFont5"
				)

				if tab.Icon and tab.ShowIcon then
					local mat = Material(tab.Icon, "smooth")
					local iconSize = tab.IconSize or CoDHUD_SX(40)
					local iconY = (h - iconSize) / 2

					surface.SetDrawColor(255, 255, 255, self:GetAlpha())
					surface.SetMaterial(mat)
					surface.DrawTexturedRect(0, iconY, iconSize, iconSize)
					surface.DrawTexturedRect(w - iconSize, iconY, iconSize, iconSize)
				end
			end
		end

        watchedConvars = {} -- reset
        for k2, entry in ipairs(tab) do
            if istable(entry) and entry.type then
				if entry.parentconvar then watchedConvars[entry.parentconvar] = true end
				if entry.requireparentconvar then watchedConvars[entry.requireparentconvar] = true end
				if entry.requireparentconvarfloat then watchedConvars[entry.requireparentconvarfloat] = true end
				if entry.requireparentconvarvariable then watchedConvars[entry.requireparentconvarvariable] = true end
				if entry.cond then
					table.insert(watchedConds, entry)
				end
            end
        end

        for k2, entry in ipairs(tab) do
            if istable(entry) and entry.type then
                local pnl = CoDHUD.BuildSetting(center, entry, descPanel, promptBar)
                if IsValid(pnl) then
                    pnl:SetVisible(CoDHUD.ShouldDrawSetting(entry))
                    pnl:SetAlpha(0)
                end
            end
        end
    end

    local lastValues = {}

    local function SetGroupAlpha(group, a)
        for _, pnl in ipairs(group) do
            if IsValid(pnl) and pnl.SetAlpha then pnl:SetAlpha(a) end
        end
    end

    local function SetCenterChildrenAlpha(a)
        for _, child in ipairs(center:GetChildren()) do
            if IsValid(child) and child.SetAlpha then
                child:SetAlpha(a)
            end
        end
    end

    local function SetAlphaRecursive(panel, a)
        if not IsValid(panel) then return end
        if panel.SetAlpha then panel:SetAlpha(a) end
        for _, child in ipairs(panel:GetChildren()) do
            SetAlphaRecursive(child, a)
        end
    end

    frame.Think = function(self)
        if not self._closing then
			local fade = math.Clamp( (CurTime() - self._fadeStart) / self._fadeDur, 0, 1 )
			local alpha = fade * 255

			self.TitleAlpha = alpha

			SetGroupAlpha(primaryGroup, alpha)
			SetGroupAlpha(secondaryGroup, alpha)
			SetAlphaRecursive(center, alpha)
			
            if not HideCloseButton and IsValid(closeBtn) then
				closeBtn:SetPos(math.max(self:GetWide() - 24, 8), 4)
			end

            -- unfocus auto-close
			if UnfocusClose and input.IsMouseDown(MOUSE_LEFT) then
				local mx, my = gui.MousePos()
				if mx and my then
					local fx2, fy2 = self:GetPos()
					local fw2, fh2 = self:GetSize()

					local clickedInsideDropdown = false
					for _, pnl in ipairs(CoDHUDMenu.OpenDropdowns or {}) do
						if IsValid(pnl) then
							local px, py = pnl:LocalToScreen(0, 0)
							local pw, ph = pnl:GetSize()
							if mx >= px and mx <= px + pw and my >= py and my <= py + ph then
								clickedInsideDropdown = true
								break
							end
						end
					end

					if not clickedInsideDropdown and (mx < fx2 or mx > fx2 + fw2 or my < fy2 or my > fy2 + fh2) then
						timer.Simple(0, function()
							if IsValid(self) then CoDHUDMenu.CloseCurrentMenu() end
						end)
					end
				end
			end

            local shouldRefresh = false
			for cvName in pairs(watchedConvars) do
				local cv = GetConVar(cvName)
				if cv then
					local val

					-- Determine type by which setting is using it
					local isVariable = false
					for _, tab in ipairs(Tabs) do
						for _, entry in ipairs(tab) do
							if entry.requireparentconvarvariable == cvName then
								isVariable = true
								break
							end
						end
					end

					if isVariable then
						val = cv:GetString()
					else
						val = cv:GetString() -- fallback: still track as string for safety
					end

					if lastValues[cvName] ~= val then
						lastValues[cvName] = val
						shouldRefresh = true
					end
				end
			end

			for _, entry in ipairs(watchedConds) do
				local ok = entry.cond and entry.cond()

				if lastValues[entry] ~= ok then
					lastValues[entry] = ok
					shouldRefresh = true
				end
			end

            if shouldRefresh then
                BuildTab(center.CurrentTabIndex)
            end
        else
			local fade = math.Clamp( (CurTime() - self._closeStart) / self._closeFadeDur, 0, 1 )
			local alpha = (1 - fade) * 255
			self.TitleAlpha = alpha

			SetGroupAlpha(primaryGroup, alpha)
			SetGroupAlpha(secondaryGroup, alpha)
			SetCenterChildrenAlpha(alpha)

			if fade >= 1 then
				if IsValid(self) then
					self:Remove()
				end
			end
        end
    end

    frame.Paint = function(self, w, h)
		local bg = Color( 25, 25, 25, 245 )
		local alpha = math.Clamp(math.floor(self.TitleAlpha), 0, 255)
        local titleColor = Color(255, 255, 255, alpha)

		if CoDHUD[CoDHUD_GetHUDType()] and CoDHUD[CoDHUD_GetHUDType()].SettingsMenu then
			CoDHUD[CoDHUD_GetHUDType()].SettingsMenu(w, h, alpha)
		else
			draw.RoundedBox(0, 0, 0, w, h, bg)
		end

		draw.SimpleTextOutlined(Name, "CoDHUD_Settings_Main", w * 0.01, 0, titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, color_black)
    end

    -- Build tabs if more than 1
    local TAB_START_OFFSET = 15
    local TAB_BUTTON_HEIGHT = CoDHUD_S(64)
    local TAB_BUTTON_PADDING = 0
    local TAB_SIDE_PADDING = 6
    local TAB_CORNER_RADIUS = 4

    if tabsPanel then
        tabsPanel:DockPadding(0, TAB_START_OFFSET, 0, 0)
		local uv_tab_hover_last = uv_tab_hover_last or 0
        for i, tab in ipairs(Tabs) do
            if not CoDHUD.PlayerCanSeeSetting(tab) then continue end

            local btn = vgui.Create("DButton", tabsPanel)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, TAB_BUTTON_PADDING)
            btn:SetTall(tab.Icon and CoDHUD_S(64) or CoDHUD_S(48))
            btn:SetText("")

            btn.Paint = function(self, w, h)
				local a = self:GetAlpha()
				local isSelected = (CURRENT_TAB == i)
				local hovered = self:IsHovered()

				local pulse = math.abs(math.sin(RealTime() * 4))

				local baseAlpha  = 75
				local hoverAlpha = 175 * pulse

				local default = Color( 125, 125, 125, baseAlpha )
				local active = Color( 255, 255, 255, baseAlpha )
				local hoverCol = Color( 255, 255, 255, hoverAlpha )
				local bg = isSelected and active or default

				draw.RoundedBox( TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, bg )

				if hovered then
					draw.RoundedBox( TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, hoverCol )
				end

                if tab.Icon then
                    local mat = Material(tab.Icon, "smooth")
                    local iconSize = CoDHUD_SX(40)
                    local iconX = TAB_SIDE_PADDING + 2
                    local iconY = (h - iconSize) / 2
                    surface.SetDrawColor(255, 255, 255, self:GetAlpha())
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                end
				
				if a > 5 then
					DrawWrappedText(self, CoDHUDString(tab.TabName or "Tab"), self:GetWide() - ((tab.Icon and self:GetWide() * 0.15 or self:GetWide() * 0.085)) * 2, tab.Icon and CoDHUD_SX(60) or CoDHUD_SX(20), nil, false, "CoDHUD_Settings_Main", "CoDHUD_Settings_Sec")
				end
            end

			btn.OnCursorEntered = function()
				CoDHUDMenu.PlaySFX("hover")
				if tab.Desc and descPanel then descPanel.Desc = tab.Desc or "" end
				if promptBar then promptBar.Prompts = tab.Prompts or { "uv.prompt.tab" } end
			end
			
			btn.OnCursorExited = function()
				if descPanel then descPanel.Desc = "" end
				if promptBar then promptBar.Prompts = nil end
			end
		
            btn.DoClick = function()
				if tab.playsfx then CoDHUDMenu.PlaySFX(tab.playsfx) end
				if tab.func then tab.func(self) return end
                CURRENT_TAB = i
                BuildTab(i)
                tabsPanel:InvalidateLayout(true)
            end

            if i == 1 then BuildTab(1) end
        end
    else
        -- Only 1 tab → just build that tab directly
        BuildTab(1)
    end

    frame.OnRemove = function()
        gui.EnableScreenClicker(false)
        if CoDHUD.SettingsFrame == frame then CoDHUD.SettingsFrame = nil end
    end
end