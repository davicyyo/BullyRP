if SERVER then

	net.Receive("ThirdOTSReq", function(len, ply)
		local t = net.ReadBool()
		local state = net.ReadBool()
		if t then
			ply:SetNW2Bool("ThirtOTS",  state)
		else
			ply:SetNW2Bool("ThirtOTS_SStatus", state)
		end
	end)
end

concommand.Add("thirdperson_ots", function(fply, cmd, args, argstr)
	if CLIENT then
		net.Start("ThirdOTSReq")
		net.WriteBool(true)
		net.WriteBool(not fply:GetNW2Bool("ThirtOTS", false))
		net.SendToServer()
	end
	fply:SetNW2Bool("ThirtOTS", not fply:GetNW2Bool("ThirtOTS", false))
end, nil, nil, FCVAR_NONE)

concommand.Add("thirdperson_ots_swap", function(fply, cmd, args, argstr)
	if CLIENT then
		net.Start("ThirdOTSReq")
		net.WriteBool(false)
		net.WriteBool(not fply:GetNW2Bool("ThirtOTS_SStatus", false))
		net.SendToServer()
	end
	fply:SetNW2Bool("ThirtOTS_SStatus", not fply:GetNW2Bool("ThirtOTS_SStatus", false))
end, nil, nil, FCVAR_NONE)


function PointDir(from, to)
	local ang = to - from

	return ang:Angle()
end

local minvec = Vector(-6, -6, -6)
local maxvec = Vector(6, 6, 6)
local crouchfac = 0
local rightconvar = 20
local upconvar = 0
local upcrouchedconvar = 15
local forwardconvar = -35
local crosscv = 1
local fovcv = 100
local lply

local function chkfunc(ent)
	if not lply and IsValid(LocalPlayer()) then
		lply = LocalPlayer()
	end

	if ent == lply or (IsValid(ply) and ent == ply:GetActiveWeapon()) then return false end
	if ent:IsRagdoll() then return false end

	return true
end

local angleclamp = 85
local oldeyeangles
local neweyeangles
local tr = {}
local traceres
local swapfac = 1
local swaptarget = 1

hook.Add("CalcView", "ThirdOTSCalcView", function(fply, pos, angles, fov)
	if not fply:GetNW2Bool("ThirtOTS", false) then return end
	if not fply:Alive() or fply:InVehicle() then return end
	swaptarget = fply:GetNW2Bool("ThirtOTS_SStatus", false) and -1 or 1
	swapfac = math.Approach(swapfac, swaptarget, (swaptarget - swapfac) * FrameTime() * 10)
	oldeyeangles = fply:EyeAngles() --angles * 1

	if not fply.thirdotscameraangle then
		angles.p = math.Clamp(angles.p, -angleclamp, angleclamp)
		fply.thirdotscameraangle = angles
	end

	angles = fply.thirdotscameraangle

	if fply.oldeyeangles then
		local dif = fply:EyeAngles() - fply.oldeyeangles
		fply.thirdotscameraangle = fply.thirdotscameraangle + dif
	end

	fply.thirdotscameraangle:Normalize()
	fply.thirdotscameraangle.p = math.Clamp(fply.thirdotscameraangle.p, -angleclamp, angleclamp)
	angles:Normalize()
	local tmpang = Angle(angles.p, angles.y, angles.r)
	tr.start = pos
	tr.endpos = pos + (tmpang:Forward() * forwardconvar) + (tmpang:Right() * rightconvar* swapfac) + (tmpang:Up() * upconvar)
	local newnum = fply:Crouching() and 1 or 0
	crouchfac = math.Approach(crouchfac, newnum, (newnum - crouchfac) * FrameTime() * 10)

	if crouchfac > 0 then
		tr.endpos = tr.endpos + (tmpang:Up() * upcrouchedconvar) * crouchfac
	end

	tr.filter = chkfunc
	tr.mask = MASK_SOLID
	tr.mins = minvec
	tr.maxs = maxvec
	local htra = util.TraceHull(tr)
	local tmppos = htra.HitPos
	tr.start = tmppos - tmpang:Forward() * forwardconvar* 2
	tr.endpos = tmpang:Forward() * 2147483647
	tr.mask = MASK_SHOT
	tr.filter = chkfunc
	traceres = util.TraceLine(tr)
	neweyeangles = PointDir(fply:GetShootPos(), traceres.HitPos)
	neweyeangles:Normalize()
	local vpan = fply:GetViewPunchAngles()
	vpan:Normalize()
	fply:SetEyeAngles(LerpAngle(FrameTime() * 10, oldeyeangles, neweyeangles))
	fply.oldeyeangles = fply:EyeAngles()
	fply.campos = tmppos
	fply.camang = tmpang
	tmpang = tmpang + vpan * 1
	tmpang.r = 0
	if fovcv then
		fov = fov * math.Clamp( fovcv, 50, 150) / 90
	end

	if LeanCalcView then
		return LeanCalcView(fply, tmppos, tmpang, fov)
	else
		return {
			origin = tmppos,
			angles = tmpang,
			fov = fov
		}
	end
end)

hook.Add("ShouldDrawLocalPlayer", "ThirdOTSShouldDrawLocalPlayer", function(fply)
	if not fply:GetNW2Bool("ThirtOTS", false) then return end
	if not fply:Alive() or fply:InVehicle() then return end

	return true
end)

local DisabledMoveTypes = {
	[MOVETYPE_FLY] = true,
	[MOVETYPE_FLYGRAVITY] = true,
	[MOVETYPE_OBSERVER] = true,
	[MOVETYPE_NOCLIP] = true
}

hook.Add("CreateMove", "ThirdOTSCreateMove", function(cmd)
	local fply = LocalPlayer()
	if not IsValid(fply) then return end
	if not fply:GetNW2Bool("ThirtOTS", false) then return end
	if DisabledMoveTypes[fply:GetMoveType()] then return end
	local tang = fply.camang and fply.camang or fply:EyeAngles()
	vel = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), cmd:GetUpMove())
	vel:Rotate(fply:EyeAngles() - tang)
	cmd:SetSideMove(vel.y)
	cmd:SetForwardMove(vel.x)
	cmd:SetUpMove(vel.z)
end)	

if CLIENT then
	local check = 0
	local cooldown = cooldown or 0
	hook.Add( "Think", "KeyDown_Person", function()
		if input.IsKeyDown( KEY_F1 ) then
			check = check + 1
			if check == 1 then
				LocalPlayer():sendNotify("Presiona F1 + SHIFT para cambiar de perspectiva")
			end
			if cooldown < CurTime() then
				cooldown = CurTime() + 0.5
				if input.IsKeyDown( KEY_LSHIFT ) then
					LocalPlayer():ConCommand( "thirdperson_ots_swap" )
				else
					LocalPlayer():ConCommand( "thirdperson_ots" )
				end
			end
		end
	end )
end