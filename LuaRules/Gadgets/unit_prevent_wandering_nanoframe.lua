-- This file solves nothing, but has been left here so I don't try again next year.
--if not gadgetHandler:IsSyncedCode() then return end
--
--function gadget:GetInfo()
--	return {
--		name    = "Prevent Wandering Nanoframe",
--		desc    = "Stops reverse built units wandering off the map",
--		author  = "GoogleFrog",
--		date    = "6 April 2024",
--		license   = "GNU GPL, v2 or later",
--		layer   = 0,
--		enabled = false
--	}
--end
--
--local removeVelocity = nil
--
--function gadget:UnitReverseBuilt(unitID, unitDefID)
--	removeVelocity = removeVelocity or {}
--	removeVelocity[#removeVelocity + 1] = unitID
--end
--
--function gadget:GameFrame()
--	if not removeVelocity then
--		return
--	end
--	for i = 1, #removeVelocity do
--		local unitID = removeVelocity[i]
--		if Spring.ValidUnitID(unitID) then
--			Spring.Utilities.UnitEcho(unitID, "")
--			
--			local h, _, p, c, b = Spring.GetUnitHealth(unitID)
--			Spring.SetUnitHealth(unitID, h, p, c, 1)
--			
--			Spring.SetUnitVelocity(unitID, 0, 0, 0)
--			Spring.SetUnitPosition(unitID, 2300, 260, 3500)
--			local rx, ry, rz = Spring.GetUnitRotation(unitID)
--			Spring.SetUnitPhysics(unitID, 2300, 260, 3500, 0, 0, 0, rx, ry, rz, 1, 1, 1)
--			
--			--if Spring.MoveCtrl.GetTag(unitID) == nil then
--			--	Spring.MoveCtrl.Enable(unitID)
--			--	Spring.MoveCtrl.SetVelocity(unitID, 0, 0, 0)
--			--	Spring.MoveCtrl.Disable(unitID)
--			--else
--			--	Spring.MoveCtrl.SetVelocity(unitID, 0, 0, 0)
--			--end
--		end
--	end
--	removeVelocity = nil
--end
--