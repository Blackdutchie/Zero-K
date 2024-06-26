--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Chili Spectator Panels",
    desc      = "Manages UI panels for displaying team information while spectating.",
    author    = "GoogleFrog",
    date      = "5 August 2015",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

include("colors.h.lua")
VFS.Include("LuaRules/Configs/constants.lua")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local abs = math.abs
local spGetTeamResources = Spring.GetTeamResources
local spGetTeamRulesParam = Spring.GetTeamRulesParam

local Chili
local screen0

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local col_metal = {136/255,214/255,251/255,1}
local col_energy = {.93,.93,0,1}
local col_empty = {0,0,0,0}
local col_expense
local positiveColourStr
local negativeColourStr

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local playerWindow
local economyWindowData
local allyTeamData

local enabled = false
local enabledPlayer = false
local enabledResource = false

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Options Functions

local function UpdateResourceWindowFonts(windowData)
	windowData.metalPanel.label_income.font.size = options.resourceMainFontSize.value
	windowData.metalPanel.label_overdrive.font.size = options.resourceFontSize.value
	windowData.metalPanel.label_reclaim.font.size = options.resourceFontSize.value
	windowData.energyPanel.label_income.font.size = options.resourceMainFontSize.value
	windowData.energyPanel.label_overdrive.font.size = options.resourceFontSize.value
	windowData.energyPanel.label_reclaim.font.size = options.resourceFontSize.value
	
	windowData.metalPanel.label_income:Invalidate()
	windowData.metalPanel.label_overdrive:Invalidate()
	windowData.metalPanel.label_reclaim:Invalidate()
	windowData.energyPanel.label_income:Invalidate()
	windowData.energyPanel.label_overdrive:Invalidate()
	windowData.energyPanel.label_reclaim:Invalidate()
	windowData.metalPanel.mainPanel:Invalidate()
	windowData.energyPanel.mainPanel:Invalidate()
end

local function UpdatePlayerWindowFonts()
	playerWindow.nameLeft.font.size = options.playerMainFontSize.value
	playerWindow.nameRight.font.size = options.playerMainFontSize.value
	playerWindow.winsLeft.font.size = options.playerMainFontSize.value
	playerWindow.winsRight.font.size = options.playerMainFontSize.value
	
	playerWindow.nameLeft:Invalidate()
	playerWindow.nameRight:Invalidate()
	playerWindow.winsLeft:Invalidate()
	playerWindow.winsRight:Invalidate()
	playerWindow.mainPanel:Invalidate()
end

local function option_UpdateFonts()
	if economyWindowData then
		UpdateResourceWindowFonts(economyWindowData[1])
		UpdateResourceWindowFonts(economyWindowData[2])
	end
	if playerWindow then
		UpdatePlayerWindowFonts()
	end
end

local function option_ColourBlindUpdate()
	positiveColourStr = (options.colourBlind.value and YellowStr) or GreenStr
	negativeColourStr = (options.colourBlind.value and BlueStr) or RedStr
	col_expense = (options.colourBlind.value and {.2,.3,1,1}) or {1,.3,.2,1}
end

local function ShowOptions(self)
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	if not meta then 
		return false 
	end
	WG.crude.OpenPath(options_path)
	WG.crude.ShowMenu()
	return true
end

ShowOptions = {ShowOptions}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Options

options_path = 'Settings/HUD Panels/Extras/Spectating'

options_order = {
	'enableSpectator',
	'clanNameLengthCutoff',
	
	'lable_playerPanel',
	'enablePlayerPanel',
	'playerOpacity',
	'playerMainFontSize', 
	'playerFontSize',
	
	'lable_economyPanels',
	'enableEconomyPanels',
	'resourceOpacity',
	'resourceMainFontSize', 
	'resourceFontSize',
	'colourBlind', 
}
 
options = {
	enableSpectator = {
		name  = "Enable as Spectator",
		type  = "bool", 
		value = false, 
		OnChange = function(self) option_CheckEnable(self) end, 
		desc = "Enables the spectator resource bars when spectating a game with two teams."
	},
	clanNameLengthCutoff = {
		name  = "Max Clan Name Length",
		type  = "number",
		value = 12, min = 0, max = 60, step = 1,
		desc = "Clans with full names shorter than this are displayed in full. Otherwise the short name is used. Requires reload."
	},
	
	lable_playerPanel = {type = 'label', name = 'Player Panel',},
	enablePlayerPanel = {
		name  = "Enable Player Panel",
		type  = "bool", 
		value = true, 
		OnChange = function(self) option_CheckEnablePlayer(self) end,
	},	
	playerOpacity = {
		name  = "Opacity",
		type  = "number",
		value = 0.6, min = 0, max = 1, step = 0.01,
		OnChange = function(self) 
				if playerWindow then
					playerWindow.mainPanel.color = {1,1,1,self.value}
					playerWindow.mainPanel.backgroundColor = {1,1,1,self.value}
					playerWindow.mainPanel:Invalidate()
					playerWindow.window:Invalidate()
				end
			end,
	},
	playerMainFontSize = {
		name  = "Main Font Size",
		type  = "number",
		value = 25, min = 8, max = 60, step = 1,
		OnChange = option_UpdateFonts,
	},
	playerFontSize = {
		name  = "Font Size",
		type  = "number",
		value = 16, min = 8, max = 40, step = 1,
		OnChange = option_UpdateFonts,
	},
	
	lable_economyPanels = {type = 'label', name = 'Economy Panels',},
	enableEconomyPanels = {
		name  = "Enable Economy Panels",
		type  = "bool", 
		value = true, 
		OnChange = function(self) option_CheckEnableResource(self) end,
	},	
	resourceOpacity = {
		name  = "Opacity",
		type  = "number",
		value = 0.6, min = 0, max = 1, step = 0.01,
		OnChange = function(self) 
				if economyWindowData then
					economyWindowData[1].metalPanel.mainPanel.color = {1,1,1,self.value}
					economyWindowData[1].metalPanel.mainPanel.backgroundColor = {1,1,1,self.value}
					economyWindowData[1].metalPanel.mainPanel:Invalidate()
					economyWindowData[1].energyPanel.mainPanel.color = {1,1,1,self.value}
					economyWindowData[1].energyPanel.mainPanel.backgroundColor = {1,1,1,self.value}
					economyWindowData[1].energyPanel.mainPanel:Invalidate()
					economyWindowData[1].window:Invalidate()
					
					economyWindowData[2].metalPanel.mainPanel.color = {1,1,1,self.value}
					economyWindowData[2].metalPanel.mainPanel.backgroundColor = {1,1,1,self.value}
					economyWindowData[2].metalPanel.mainPanel:Invalidate()
					economyWindowData[2].energyPanel.mainPanel.color = {1,1,1,self.value}
					economyWindowData[2].energyPanel.mainPanel.backgroundColor = {1,1,1,self.value}
					economyWindowData[2].energyPanel.mainPanel:Invalidate()
					economyWindowData[2].window:Invalidate()
				end
			end,
	},
	resourceMainFontSize = {
		name  = "Main Font Size",
		type  = "number",
		value = 25, min = 8, max = 60, step = 1,
		OnChange = option_UpdateFonts,
	},
	resourceFontSize = {
		name  = "Font Size",
		type  = "number",
		value = 16, min = 8, max = 40, step = 1,
		OnChange = option_UpdateFonts,
	},
	colourBlind = {
		name  = "Colourblind mode",
		type  = "bool", 
		value = false, 
		OnChange = option_ColourBlindUpdate, 
		desc = "Uses Blue and Yellow instead of Red and Green for number display"
	},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Resource Window Management

local function Mix(startColour, endColour, interpParam)
	return {endColour[1] * interpParam + startColour[1] * (1 - interpParam), 
	endColour[2] * interpParam + startColour[2] * (1 - interpParam), 
	endColour[3] * interpParam + startColour[3] * (1 - interpParam), 
	endColour[4] * interpParam + startColour[4] * (1 - interpParam), }
end

local blink = 0
local BLINK_PERIOD = 1.4

local function UpdateResourceWindowFlash(sideID, blinkAlpha)
	local windowData = economyWindowData[sideID]
	
	if windowData.metalPanel.flashing then
		windowData.metalPanel.bar:SetColor(Mix({col_metal[1], col_metal[2], col_metal[3], 0.65}, col_expense, blinkAlpha))
	end

	if windowData.energyPanel.flashing then
		windowData.energyPanel.barOverlay:SetColor(col_expense[1], col_expense[2], col_expense[3], blinkAlpha)
	end
end

function UpdateResourceWindowFlashMain(dt)
	blink = (blink + dt)%BLINK_PERIOD
	local sawtooth = math.abs(blink/BLINK_PERIOD - 0.5)*2
	local blinkAlpha = sawtooth*0.92
	UpdateResourceWindowFlash(1, blinkAlpha)
	UpdateResourceWindowFlash(2, blinkAlpha)
end

local function GetFontMult(input)
	if input < 10^3 - 0.5 then
		return 1
	else
		return 0.8
	end
end

local function Format(input, override)
	
	local leadingString = positiveColourStr .. "+"
	if input < 0 then
		leadingString = negativeColourStr .. "-"
	end
	leadingString = override or leadingString
	input = math.abs(input)
	
	if input < 0.01 then
		if override then
			return override .. "0.0"
		end
		return WhiteStr .. "0"
	elseif input < 10 - 0.05 then
		return leadingString .. ("%.1f"):format(input) .. WhiteStr
	elseif input < 10^3 - 0.5 then
		return leadingString .. ("%.0f"):format(input) .. WhiteStr
	elseif input < 10^4 then
		return leadingString .. ("%.1f"):format(input/1000) .. "k" .. WhiteStr
	elseif input < 10^5 then
		return leadingString .. ("%.0f"):format(input/1000) .. "k" .. WhiteStr
	else
		return leadingString .. ("%.0f"):format(input/1000) .. "k" .. WhiteStr
	end
end

local function GetBarCaption(net)
	if net < -27.5 then
		return negativeColourStr.."<<<<<<"
	elseif net < -22.5 then
		return negativeColourStr.."<<<<<"
	elseif net < -17.5 then
		return negativeColourStr.."<<<<"
	elseif net < -12.5 then
		return negativeColourStr.."<<<"
	elseif net < -7.5 then
		return negativeColourStr.."<<"
	elseif net < -2.5 then
		return negativeColourStr.."<"
	elseif net < 2.5 then
		return ""
	elseif net < 7.5 then
		return positiveColourStr..">"
	elseif net < 12.5 then
		return positiveColourStr..">>"
	elseif net < 17.5 then
		return positiveColourStr..">>>"
	elseif net < 22.5 then
		return positiveColourStr..">>>>"
	elseif net < 27.5 then
		return positiveColourStr..">>>>>"
	else
		return positiveColourStr..">>>>>>"
	end
end

local function UpdateResourcePanel(panel, income, net, overdrive, reclaim, storage, storageMax)
	if storageMax > 0 then
		panel.bar:SetValue(100*storage/storageMax)
	else
		panel.bar:SetValue(0)
	end 
	
	local newFontSize = math.round(GetFontMult(income)*options.resourceMainFontSize.value)
	panel.label_income.font.size = newFontSize
	panel.label_income:Invalidate()
	panel.label_income:SetCaption(Format(income, ""))
	
	if panel.barOverlay then
		panel.barOverlay:SetCaption(GetBarCaption(net))
	else
		panel.bar:SetCaption(GetBarCaption(net))
	end
	
	panel.label_overdrive:SetCaption("OD: " .. Format(overdrive))
	panel.label_reclaim:SetCaption("Re: " .. Format(reclaim))
end

local function UpdateResourceWindowPanel(sideID)
	local allyTeamID = allyTeamData[sideID].allyTeamID
	local teams = Spring.GetTeamList(allyTeamID)
	local windowData = economyWindowData[sideID]
	
	if not (teams and teams[1]) or (not windowData) then
		return
	end
	
	--// Update Economy Values
	-- These are the values displayed on the UI
	local metalIncome = 0
	local metalOverdrive = spGetTeamRulesParam(teams[1], "OD_team_metalOverdrive") or 0
	-- metalReclaim set below
	local metalStorage = 0
	local metalStorageMax = 0
	
	local metalSpent = 0
	
	local energyWaste = spGetTeamRulesParam(teams[1], "OD_team_energyWaste") or 0
	-- energyIncome set below
	local energyOverdrive = spGetTeamRulesParam(teams[1], "OD_team_energyOverdrive") or 0
	local energyReclaim = 0
	local energyStorage = 0
	local energyStorageMax = 0	
	
	
	-- Calculate the values
	for i = 1, #teams do
		local mCurr, mStor, mPull, mInco, mExpe, mShar, mSent, mReci = spGetTeamResources(teams[i], "metal")
		metalIncome = metalIncome + (mInco or 0)
		metalStorage = metalStorage + (mCurr or 0)
		metalStorageMax = metalStorageMax + (mStor or 0)
		
		metalSpent = metalSpent + (mExpe or 0)
		
		local extraMetalPull = spGetTeamRulesParam(teams[i], "extraMetalPull") or 0
		
		local eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = spGetTeamResources(teams[i], "energy")
		local extraEnergyPull = spGetTeamRulesParam(teams[i], "extraEnergyPull") or 0
		
		local energyOverdrive = spGetTeamRulesParam(teams[i], "OD_energyOverdrive") or 0
		local energyChange    = spGetTeamRulesParam(teams[i], "OD_energyChange") or 0
		local extraChange     = math.min(0, energyChange) - math.min(0, energyOverdrive)
		
		energyReclaim = energyReclaim + (eInco or 0) - math.max(0, energyChange)
		
		energyStorage = energyStorage + math.min((eCurr or 0), (eStor or 0) - HIDDEN_STORAGE)
		energyStorageMax = energyStorageMax + (eStor or 0) - HIDDEN_STORAGE 
	end
	
	energyReclaim = math.max(0, energyReclaim)
	
	local metalReclaim = metalIncome 
			- (spGetTeamRulesParam(teams[1], "OD_team_metalOverdrive") or 0)
			- (spGetTeamRulesParam(teams[1], "OD_team_metalBase") or 0) 
			- (spGetTeamRulesParam(teams[1], "OD_team_metalMisc") or 0)
	local energyIncome = (spGetTeamRulesParam(teams[1], "OD_team_energyIncome") or 0) + energyReclaim
	
	local metalNet = metalStorage - (economyWindowData[sideID].lastMetalStorage or 0)
	economyWindowData[sideID].lastMetalStorage = metalStorage
	
	local energyNet = energyStorage - (economyWindowData[sideID].lastEnergyStorage or 0)
	economyWindowData[sideID].lastEnergyStorage = energyStorage
	
	--// Flashing
	local newMetalFlash = (metalIncome - metalSpent + metalStorage >= metalStorageMax)
	if windowData.metalPanel.flashing and not newFlash then
		windowData.metalPanel.bar:SetColor(col_metal)
	end
	windowData.metalPanel.flashing = newMetalFlash
	
	local newEnergyFlash = (energyStorage <= energyStorageMax*0.1) 
		or (energyWaste > 0)
	if windowData.energyPanel.flashing and not newEnergyFlash then
		windowData.energyPanel.barOverlay:SetColor(col_empty)
	end
	windowData.energyPanel.flashing = newEnergyFlash

	--// Update GUI
	UpdateResourcePanel(windowData.metalPanel, metalIncome, metalNet, 
		metalOverdrive, metalReclaim, metalStorage, metalStorageMax)
	UpdateResourcePanel(windowData.energyPanel, energyIncome, energyNet, 
		-energyOverdrive, energyReclaim, energyStorage, energyStorageMax)
end

function UpdateResourceWindowMain()
	UpdateResourceWindowPanel(1)
	UpdateResourceWindowPanel(2)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Resource Window Creation

local function CreateResourceWindowPanel(parentData, left, width, resourceColor, barOverlay)
	local parentPanel = parentData.mainPanel
	local data = {}
	
	--// Panel configuration
	local incomeX      = "3%"
	local incomeY      = "10%"
	local incomeWidth  = "24%"
	local incomeHeight = "70%"
	
	local overdriveX    = "29%"
	local reclaimX     = "63%"
	local textY       = "51%"
	local textWidth   = "60%"
	local textHeight  = "32%"
	
	local barX      = "26%"
	local barY      = "12%"
	local barRight  = "4%"
	local barHeight = "36%"
	
	data.mainPanel = Chili.Panel:New{
		parent = parentPanel,
		x      = left,
		width  = width,
		y      = 0,
		bottom = 0,
		padding = {0,0,0,0},
		backgroundColor = {1,1,1,options.resourceOpacity.value},
		color = {1,1,1,options.resourceOpacity.value},
		dockable = false;
		draggable = false,
		resizable = false,
		OnMouseDown = ShowOptions,
	}
	
	if barOverlay then
		data.barOverlay = Chili.Progressbar:New{
			parent = data.mainPanel,
			orientation = "horizontal",
			value  = 100,
			color  = {0,0,0,0},
			x      = barX,
			y      = barY,
			right  = barRight,
			height = barHeight,
			noSkin = true,
			font   = {
				size = 20, 
				color = {.8,.8,.8,.95}, 
				outline = true,
				outlineWidth = 2, 
				outlineWeight = 2
			},
		}
	end
	
	data.bar = Chili.Progressbar:New{
		parent = data.mainPanel,
		color  = resourceColor,
		orientation = "horizontal",
		x      = barX,
		y      = barY,
		right  = barRight,
		height = barHeight,
		value  = 0,
		fontShadow = false,
		font   = {
			size = 20, 
			color = {.8,.8,.8,.95}, 
			outline = true,
			outlineWidth = 2, 
			outlineWeight = 2
		},
	}
	
	data.label_income = Chili.Label:New{
		parent = data.mainPanel,
		x      = incomeX,
		y      = incomeY,
		width  = incomeWidth,
		height = incomeHeight,
		caption = "0.0",
		valign = "center",
 		align  = "center",
		autosize = false,
		font   = {
			size = options.resourceMainFontSize.value, 
			outline = true, 
			outlineWidth = 2, 
			outlineWeight = 2,
			color = resourceColor, 
		},
	}
	
	data.label_overdrive = Chili.Label:New{
		parent = data.mainPanel,
		x      = overdriveX,
		y      = textY,
		width  = textWidth,
		height = textHeight,
		caption = "OD: 0",
		valign = "center",
 		align  = "left",
		autosize = false,
		font   = {size = options.resourceFontSize.value, outline = true, outlineWidth = 2, outlineWeight = 2},
	}
	
	data.label_reclaim = Chili.Label:New{
		parent = data.mainPanel,
		x      = reclaimX,
		y      = textY,
		width  = textWidth,
		height = textHeight,
		caption = "Re: 0",
		valign = "center",
 		align  = "left",
		autosize = false,
		font   = {size = options.resourceFontSize.value, outline = true, outlineWidth = 2, outlineWeight = 2},
	}
	
	return data
end

local function CreateResourceWindow(allyTeamDataNumber, x, width)
	local data = {}
	
	data.window = Chili.Window:New{
		parent = screen0,
		backgroundColor = {0, 0, 0, 0},
		color = {0, 0, 0, 0},
		dockable = true,
		name = "SpectatorEconomyPanel" .. allyTeamDataNumber,
		padding = {0,0,0,0},
		x = x,
		y = 0,
		clientWidth  = width,
		clientHeight = 50,
		draggable = false,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = true,
		minimizable = false,
		OnMouseDown = ShowOptions,
		tooltip = "Economy for " .. allyTeamData[allyTeamDataNumber].name,
	}
	
	data.mainPanel = Chili.Panel:New{
		backgroundColor = {0, 0, 0, 0},
		parent = data.window,
		padding = {0,0,0,0},
		y      = 0,
		x      = 0,
		right  = 0,
		bottom = 0,
		dockable = false;
		draggable = false,
		resizable = false,
		OnMouseDown = ShowOptions,
		tooltip = "Economy for " .. allyTeamData[allyTeamDataNumber].name,
	}
	
	function data.window:HitTest(x,y) return self end
	function data.mainPanel:HitTest(x,y) return self end
	
	data.metalPanel = CreateResourceWindowPanel(data, 0, "50%", col_metal, false)
	data.energyPanel = CreateResourceWindowPanel(data, "50%", "50%", col_energy, true)
	
	return data
end

local function AddEconomyWindows()
	if enabledEconomy then
		return
	end
	if economyWindowData then
		screen0:AddChild(economyWindowData[1].window)
		screen0:AddChild(economyWindowData[2].window)
	else
		Spring.SendCommands("resbar 0")
		
		local screenWidth,screenHeight = Spring.GetWindowGeometry()
		local screenHorizCentre = screenWidth / 2
		local playerWindowWidth = 500
		local econWidth = 460
		
		economyWindowData = {
			[1] = CreateResourceWindow(1, screenHorizCentre - playerWindowWidth/2 - econWidth, econWidth),
			[2] = CreateResourceWindow(2, screenHorizCentre + playerWindowWidth/2, econWidth),
		}
	end
	enabledEconomy = true
end

local function RemoveEconomyWindows()
	if enabledEconomy then
		screen0:RemoveChild(economyWindowData[1].window)
		screen0:RemoveChild(economyWindowData[2].window)
		enabledEconomy = false
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Player Window Creation

local function CreatePlayerWindow()
	local data = {}
	
	local screenWidth,screenHeight = Spring.GetWindowGeometry()
	local screenHorizCentre = screenWidth / 2
	local playerWindowWidth = 500

	data.window = Chili.Window:New{
		parent = screen0,
		backgroundColor = {0, 0, 0, 0},
		color = {0, 0, 0, 0},
		dockable = true,
		name = "SpectatorPlayerPanel",
		padding = {0,0,0,0},
		x = screenHorizCentre - playerWindowWidth/2,
		y = 0,
		clientWidth  = playerWindowWidth,
		clientHeight = 50,
		draggable = false,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = true,
		minimizable = false,
		OnMouseDown = ShowOptions,
	}
	
	data.mainPanel = Chili.Panel:New{
		backgroundColor = {1,1,1,options.resourceOpacity.value},
		color = {1,1,1,options.resourceOpacity.value},
		parent = data.window,
		padding = {0,0,0,0},
		y      = 0,
		x      = 0,
		right  = 0,
		bottom = 0,
		dockable = false;
		draggable = false,
		resizable = false,
		OnMouseDown = ShowOptions,
	}
	
	function data.window:HitTest(x,y) return self end
	function data.mainPanel:HitTest(x,y) return self end
	
	-- Panel internals
	local nameOuter = 45
	local nameInner = "51%"
	local winsOuter = 16
	local winsInner = "80%"
	
	local texY = "8%"
	local texBottom = "15%"
	
	data.nameLeft = Chili.Label:New{
		parent = data.mainPanel,
		x      = nameOuter,
		y      = texY,
		right  = nameInner,
		bottom = texBottom,
		caption = allyTeamData[1].name,
		valign = "center",
 		align  = "left",
		autosize = false,
		font   = {
			size = math.round(options.playerMainFontSize.value*allyTeamData[1].nameSize), 
			outline = true, 
			outlineWidth = 2, 
			outlineWeight = 2,
			color = allyTeamData[1].color, 
		},
	}
	
	data.nameRight = Chili.Label:New{
		parent = data.mainPanel,
		x      = nameInner,
		y      = texY,
		right  = nameOuter,
		bottom = texBottom,
		caption = allyTeamData[2].name,
		valign = "center",
 		align  = "right",
		autosize = false,
		font   = {
			size = math.round(options.playerMainFontSize.value*allyTeamData[2].nameSize), 
			outline = true, 
			outlineWidth = 2, 
			outlineWeight = 2,
			color = allyTeamData[2].color, 
		},
	}
	
	data.winsLeft  = Chili.Label:New{
		parent = data.mainPanel,
		x      = winsOuter,
		y      = texY,
		right  = winsInner,
		bottom = texBottom,
		caption = allyTeamData[1].winString,
		valign = "center",
 		align  = "left",
		autosize = false,
		font   = {
			size = options.playerMainFontSize.value, 
			outline = true, 
			outlineWidth = 2, 
			outlineWeight = 2,
			color = allyTeamData[1].color, 
		},
	}
	
	data.winsRight  = Chili.Label:New{
		parent = data.mainPanel,
		x      = winsInner,
		y      = texY,
		right  = winsOuter,
		bottom = texBottom,
		caption = allyTeamData[2].winString,
		valign = "center",
 		align  = "right",
		autosize = false,
		font   = {
			size = options.playerMainFontSize.value, 
			outline = true, 
			outlineWidth = 2, 
			outlineWeight = 2,
			color = allyTeamData[2].color, 
		},
	}
	
	return data
end

local function AddPlayerWindow()
	if enabledPlayer then
		return
	end
	if playerWindow then
		screen0:AddChild(playerWindow.window)
	else
		playerWindow = CreatePlayerWindow()
	end
	enabledPlayer = true
end

local function RemovePlayerWindow()
	if enabledPlayer then
		screen0:RemoveChild(playerWindow.window)
		enabledPlayer = false
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Window Visiblity Management

local function GetWinString(name)
	local winTable = WG.WinCounter_currentWinTable
	if winTable and winTable[name] and winTable[name].wins then
		return (winTable[name].wonLastGame and "*" or "") .. winTable[name].wins
	end
	return false
end

local function GetOpposingAllyTeams()
	local teams = Spring.GetTeamList()
	local gaiaTeamID = Spring.GetGaiaTeamID()
	
	-- Finds the teams that contain players or skirmish AIs
	local activeAllyTeams = {}
	local activeAllyTeamsCount = 0
	
	for i = 1, #teams do
		local teamID = teams[i]
		local _,leader,_,isAI,_,allyTeamID = Spring.GetTeamInfo(teamID)
		if teamID ~= gaiaTeamID then
			if isAI then
				-- If the team is an AI team then count it as long as it is not chicken.
				-- The AI names are collected seperately because they are less important.
				local _,name = Spring.GetAIInfo(teamID)
				if not name:find("Chicken:") then
					if not activeAllyTeams[allyTeamID] then
						activeAllyTeams[allyTeamID] = {aiNames = {}, players = 0, AIs = 0, teamID = teamID}
						activeAllyTeamsCount = activeAllyTeamsCount + 1
					end
					
					local data = activeAllyTeams[allyTeamID]
					data.AIs = data.AIs + 1
					data.aiNames[data.AIs] = name
				end
			else
				local name,_,_,_,_,_,_,_,_,customKeys = Spring.GetPlayerInfo(leader)
				customKeys = customKeys or {}
				local clan = customKeys.clan or ""
				if not activeAllyTeams[allyTeamID] then
					activeAllyTeams[allyTeamID] = {players = 0, AIs = 0, teamID = teamID}
					activeAllyTeamsCount = activeAllyTeamsCount + 1
				end
				
				local data = activeAllyTeams[allyTeamID]
				
				-- The first player provides some representitive information for the team
				if not data.playerNames then
					data.playerNames = {}
					data.teamID = teamID
					data.winString = GetWinString(name)
				end
				
				data.players = data.players + 1
				data.playerNames[data.players] = name
				
				-- The team is considered a clan until players from distinct clans are found.
				if (not data.noClan) and data.clan ~= clan then
					if data.clan then
						data.noClan = true
					else
						data.clanfull = customKeys.clanfull
						data.clan = clan
					end
				end
			end
		end
	end
	
	-- The spectator panel is only supported for games against two teams
	if activeAllyTeamsCount ~= 2 then
		return false
	end
	
	-- If all players have the same clan then designation by clan is useless.
	local clans = {}
	for allyTeamID, data in pairs(activeAllyTeams) do
		clans[#clans + 1] = data.clan
	end
	
	if clans[1] == clans[2] then
		for allyTeamID, data in pairs(activeAllyTeams) do
			data.noClan = true
		end
	end
	
	-- Create the final allyTeamData
	local returnData = {}
	
	for allyTeamID, data in pairs(activeAllyTeams) do
		local name = "noname"
		local nameSize = 1
		
		local teamMembers = data.players + data.AIs
		
		if (not data.noClan) and data.clan ~= "" and data.players > 1 then
			-- All players on a team of at least two have the same clan
			if data.clanfull and string.len(data.clanfull) < options.clanNameLengthCutoff.value then
				name = data.clanfull
			else
				name = data.clan
			end
		else
			if data.players >= 1 then
				name = data.playerNames[1]
			else
				name = data.aiNames[1]
			end
			if teamMembers == 2 or data.players == 2 then
				nameSize = 0.65
				if data.players >= 2 then
					name = name .. "\n" .. data.playerNames[2]
				else
					name = name .. "\n" .. data.aiNames[2]
				end
			elseif teamMembers > 2 then
				nameSize = 0.65
				name = name .. "\n and team"
			end
		end
		
		name = name or "noname"
		
		returnData[#returnData + 1] = {
			allyTeamID = allyTeamID, -- allyTeamID for the team
			name = name, -- Large display name of the team
			nameSize = nameSize, -- Display size factor of the team name.
			teamID = data.teamID, -- representitive teamID
			color = {Spring.GetTeamColor(data.teamID)} or {1,1,1,1}, -- color of the teams text (color of first player)
			playerName = data.playerName, -- representitive player name (for win counter)
			winString = data.winString or "0", -- Win string from win counter
		}
	end
	
	if returnData[1].allyTeamID > returnData[2].allyTeamID then
		returnData[1], returnData[2] = returnData[2], returnData[1]
	end
	
	return returnData
end


function option_CheckEnable(self)

	if not self.value then
		if enabled then
			RemovePlayerWindow()
			RemoveEconomyWindows()
			enabled = false
		end
		return
	end
	
	if enabled then
		return
	end
	
	local spectating = select(1, Spring.GetSpectatingState())
	if not spectating then
		return
	end
	
	allyTeamData = GetOpposingAllyTeams()
	if not allyTeamData then
		return
	end
	
	if options.enablePlayerPanel.value then
		AddPlayerWindow()
	end
	
	if options.enableEconomyPanels.value then
		AddEconomyWindows()
	end
	
	enabled = true
end

function option_CheckEnablePlayer(self)
	if not options.enableSpectator.value then
		return
	end
	
	if self.value then
		AddPlayerWindow()
	else
		RemovePlayerWindow()
	end
end

function option_CheckEnableResource(self)
	if not options.enableSpectator.value then
		return
	end
	
	if self.value then
		AddEconomyWindows()
	else
		RemoveEconomyWindows()
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Shutdown()
	--window:Dispose()
end

function widget:Initialize()
	Chili = WG.Chili
	screen0 = Chili.Screen0
	
	if (not Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	option_ColourBlindUpdate()
end


function widget:Update(dt)
	if economyWindowData then
		UpdateResourceWindowFlashMain(dt)
	end
end

function widget:GameFrame(n)
	if economyWindowData and n%TEAM_SLOWUPDATE_RATE == 0 then
		UpdateResourceWindowMain()
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------