function widget:GetInfo()
	return {
		name      = "BuildETA",
		desc      = "Displays estimated time of arrival for builds",
		author    = "trepan (modified by jK) (stall ETA fixed by Google Frog)",
		date      = "Feb, 2008",
		license   = "GNU GPL, v2 or later",
		layer     = -1,
		enabled   = true,
	}
end

local gl     = gl
local Spring = Spring
local table  = table

local stockpilerDefNames =
	{ "corsilo"
	, "cornukesub"
}

local stockpilerDefs = {}
for i = 1, #stockpilerDefNames do
	stockpilerDefs[UnitDefNames[stockpilerDefNames[i]].id] = true
end
stockpilerDefNames = nil

local etaTable = {}
local stockpileEtaTable = {}


options_path = 'Settings/Interface/Build ETA'
options_order = { 'showonlyonshift'}
options = {
	
	showonlyonshift = {
		name = 'Show only on shift',
		type = 'bool',
		value = false,
	},
}

local vsx, vsy = widgetHandler:GetViewSizes()

function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = viewSizeX
	vsy = viewSizeY
end


local function MakeETA(unitID,unitDefID)
	if (unitDefID == nil) then return nil end
	local buildProgress = select(5, Spring.GetUnitHealth(unitID))
	if (buildProgress == nil) then 
		return nil 
	end

	local ud = UnitDefs[unitDefID]
	if (ud == nil)or(ud.height == nil) then 
		return nil 
	end

	return {
		firstSet = true,
		lastTime = Spring.GetGameSeconds(),
		lastProg = buildProgress,
		rate     = nil,
		lastNewTime = nil,
		timeLeft = nil,
		yoffset  = ud.height + 14,
	}
end


function widget:Initialize()
	local spect, spectFull = Spring.GetSpectatingState()
	local myAllyTeam = Spring.GetMyAllyTeamID()
	local allUnits = Spring.GetAllUnits()
	for i = 1, #allUnits do
		local unitID = allUnits[i]
		if (Spring.GetUnitAllyTeam(unitID) == myAllyTeam) or (spect and spectFull) then
			local buildProgress = select(5, Spring.GetUnitHealth(unitID))
			if (buildProgress < 1) then
				etaTable[unitID] = MakeETA(unitID, Spring.GetUnitDefID(unitID))
			elseif (stockpilerDefs[Spring.GetUnitDefID(unitID)]) then
				stockpileEtaTable[unitID] = {
					firstSet = true,
					lastTime = Spring.GetGameFrame(),
					lastProg = Spring.GetUnitRulesParam(unitID, "gadgetStockpile") or 0,
					rate     = nil,
					lastNewTime = nil,
					timeLeft = nil,
					negative = false,
					yoffset  = UnitDefs[Spring.GetUnitDefID(unitID)].height + 14,
				}
			end
		end
	end
	WG.etaTable = etaTable
end

local function updateTime(bi, dt, newTime, negative)
	if bi.lastNewTime and dt < 2 and (bi.negative == negative) then
		bi.timeLeft = ((newTime + bi.lastNewTime - dt)/2)
	else
		bi.timeLeft = newTime
	end
	bi.negative = negative
	bi.lastNewTime = newTime
end

function widget:GameFrame(n)

	if (n % 6 ~= 0) then return end -- 6N because stockpile happens in such increments, else its eta fluctuates

	local _,_,pause = Spring.GetGameSpeed()
	if (pause) then
		return
	end

	local gs = Spring.GetGameSeconds()

	for unitID, bi in pairs(stockpileEtaTable) do
		local buildProgress = Spring.GetUnitRulesParam(unitID, "gadgetStockpile") or 0
		local dp = buildProgress - bi.lastProg
		local dt = n - bi.lastTime

		if (dt >= 30) then
			if (buildProgress <= bi.lastProg) then
				bi.rate = nil
				bi.timeLeft = nil
				bi.firstSet = true
			else
				local rate = 30 * dp / dt

				if (bi.firstSet) then
					if (buildProgress > 0.001) then
						bi.firstSet = false
					end
				else
					updateTime(bi, dt, (1 - buildProgress) / rate, false)
				end
			end
			bi.lastTime = n
			bi.lastProg = buildProgress
		end
	end

	for unitID,bi in pairs(etaTable) do
		local buildProgress = select(5, Spring.GetUnitHealth(unitID))
		local dp = buildProgress - bi.lastProg 
		local dt = gs - bi.lastTime
		if (dt > 2) then
			bi.firstSet = true
			bi.rate = nil
			bi.timeLeft = nil
		end
		
		if dt > 0.5 then
			local rate = dp / dt

			if (rate ~= 0) then
				if (bi.firstSet) then
					if (buildProgress > 0.001) then
						bi.firstSet = false
					end
				else
					if (rate > 0) then
						updateTime(bi, dt, (1 - buildProgress) / rate, false)
					elseif (rate < 0) then
						updateTime(bi, dt, -buildProgress / rate, true)
					end
				end
				bi.lastTime = gs
				bi.lastProg = buildProgress
			end
		end
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	local buildProgress = select(5, Spring.GetUnitHealth(unitID))
	if(buildProgress < 1) then
		local spect,spectFull = Spring.GetSpectatingState()
		local myTeam = Spring.GetMyTeamID()
		if Spring.AreTeamsAllied(unitTeam, myTeam) or (spect and spectFull) then
			etaTable[unitID] = MakeETA(unitID,unitDefID)
		end
	end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	etaTable[unitID] = nil
	stockpileEtaTable[unitID] = nil
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	local spec = Spring.GetSpectatingState()
	if (spec) then return end

	if Spring.AreTeamsAllied (Spring.GetMyTeamID(), newTeam) then
		local buildProgress = select(5, Spring.GetUnitHealth(unitID))
		if (buildProgress < 1) then
			if not etaTable[unitID] then
				etaTable[unitID] = MakeETA(unitID,Spring.GetUnitDefID(unitID))
			end
		elseif stockpilerDefs[Spring.GetUnitDefID(unitID)] and not stockpileEtaTable[unitID] then
			stockpileEtaTable[unitID] = {
				firstSet = true,
				lastTime = Spring.GetGameFrame(),
				lastProg = buildProgress,
				rate     = nil,
				lastNewTime = nil,
				timeLeft = nil,
				negative = false,
				yoffset  = UnitDefs[Spring.GetUnitDefID(unitID)].height + 14,
			}
		end
	else
		etaTable[unitID] = nil
		stockpileEtaTable[unitID] = nil
	end
end

local terraunitDefID = UnitDefNames["terraunit"] and UnitDefNames["terraunit"].id

function widget:UnitFinished(unitID, unitDefID, unitTeam)
	if unitDefID ~= terraunitDefID then
		etaTable[unitID] = nil
	end

	if stockpilerDefs[unitDefID]
	and not stockpileEtaTable[unitID] -- reclaim into rebuild
	then
		stockpileEtaTable[unitID] = {
			firstSet = true,
			lastTime = Spring.GetGameFrame(),
			lastProg = Spring.GetUnitRulesParam(unitID, "gadgetStockpile") or 0,
			rate     = nil,
			lastNewTime = nil,
			timeLeft = nil,
			negative = false,
			yoffset  = UnitDefs[unitDefID].height + 14,
		}
	end
end


local function DrawEtaText(timeLeft,yoffset, negative)
	local etaStr
	if (timeLeft == nil) then
		etaStr = '\255\255\255\1ETA\255\255\255\255: \255\1\1\255???'
	else
		local color = negative and '\255\255\1\1' or '\255\1\255\1'
		etaStr = "\255\255\255\1ETA: " .. string.format('%s%d:%02d', color, timeLeft / 60, timeLeft % 60)
	end

	gl.Translate(0, yoffset,0)
	gl.Billboard()
	gl.Translate(0, 5 ,0)
	gl.Text(etaStr, 0, 0, 8, "co")
end

function widget:DrawWorld()
	if Spring.IsGUIHidden() or (options.showonlyonshift.value and not select(4,Spring.GetModKeyState())) then return end
	gl.DepthTest(true)

	gl.Color(1, 1, 1)

	for unitID, bi in pairs(etaTable) do
		gl.DrawFuncAtUnit(unitID, false, DrawEtaText, bi.timeLeft,bi.yoffset, bi.negative)
	end

	for unitID, bi in pairs(stockpileEtaTable) do
		local stocked, wanted = Spring.GetUnitStockpile(unitID)
		if (stocked < wanted) then
			gl.DrawFuncAtUnit(unitID, false, DrawEtaText, bi.timeLeft,bi.yoffset, false)
		end
	end

	gl.DepthTest(false)
end
