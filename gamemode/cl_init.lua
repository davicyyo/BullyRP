include( "shared.lua" )

files = {"meta","hud","thirdperson"}

for k,v in pairs(files) do
	include("modules/"..v..".lua")
end

surface.CreateFont( "F_Mini", {
	font = "NarcissusOpenSG",
	extended = false,
	size = ScreenScale(5),
	weight = 500,

} )

surface.CreateFont( "F_Mini+", {
	font = "NarcissusOpenSG",
	extended = false,
	size = ScreenScale(8),
	weight = 500,

} )

surface.CreateFont( "F_Normal", {
	font = "NarcissusOpenSG",
	extended = false,
	size = ScreenScale(10),
	weight = 500,

} )

surface.CreateFont( "F_Grande", {
	font = "NarcissusOpenSG",
	extended = false,
	size = ScreenScale(12),
	weight = 500,

} )

surface.CreateFont( "F_Enorme", {
	font = "NarcissusOpenSG",
	extended = false,
	size = ScreenScale(20),
	weight = 500,

} )


surface.CreateFont( "F_Enorme+", {
	font = "NarcissusOpenSG",
	extended = false,
	size = ScreenScale(40),
	weight = 500,

} )

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudWeapon"] = true,
	["CHudMessage"] = true,
	["CHudDeathNotice"] = true,
	["CHudCloseCaption"] = true,
}

hook.Add("HUDShouldDraw","Hide_SandboxHUD",function(name)
	if ( hide[ name ] ) then return false end
end)

function GM:ContextMenuOpen()
	return true
end

function GM:HUDDrawTargetID()
	return false
end

local pressm = 0
hook.Add("Think","key_map",function()
	if input.IsKeyDown(KEY_M) then
		if gui.IsConsoleVisible() or gui.IsGameUIVisible() then return end
		if LocalPlayer():GetNWBool("guienable") then return end
		if vgui.CursorVisible() then return end
		pressm = pressm + 1

		function openHTML()

			local html = vgui.Create( "DHTML" )
			html:SetSize(ScrW(),ScrH())
			html:SetPos(0,0)
			html:SetHTML( [[
				<center><img src="https://i.imgur.com/b4EQKcH.png" height="900" width="900" /></center>
			]] )

			function closeHTML()
				html:Remove()
				timer.Simple(1,function()
				pressm = 0
				end)
			end
		end

		if pressm == 1 then
			openHTML()
		else
			closeHTML()
		end

	end
end)

net.Receive("sendModel",function()

	local ent = net.ReadEntity()
	local model = net.ReadString()
	local vector = net.ReadVector()
	local angles = net.ReadAngle()
	local removeModel = false


	local modelexample = ClientsideModel( model )
	modelexample:SetNoDraw( true )

			local offsetvec = vector
			local offsetang = angles

			hook.Add( "PostPlayerDraw" , "manual_model_draw_example" , function(ply)
				if ent:GetNWBool("kickme") == false then return end
				ply = ent

				if not IsValid(ent) then return end

				local boneid = ply:LookupBone( "ValveBiped.Bip01_Spine2" )

				if not boneid then
					return
				end

				local matrix = ply:GetBoneMatrix( boneid )

				if not matrix then
					return
				end

				local newpos, newang = LocalToWorld( offsetvec, offsetang, matrix:GetTranslation(), matrix:GetAngles() )

				modelexample:SetPos( newpos )
				modelexample:SetAngles( newang )
				modelexample:SetupBones()
				modelexample:DrawModel()

	end )


end)

net.Receive("_sound",function()
	local url = net.ReadString()
	local volume = net.ReadString()
	local time = net.ReadString()
	local bool = net.ReadBool()

	LocalPlayer():playURL(url,volume,time,bool)
end)

function sendIcon(icon,pos)
	if not icon then return end
	if not pos then return end


local rr = true

hook.Add("HUDPaint", "asdajnhasasbnb232432", function()
			if rr == false then return end

			if pos:Distance(LocalPlayer():GetPos()) > 600 then
				if rr == false then return end
				draw.SimpleText(math.Round(pos:Distance(LocalPlayer():GetPos()) / 60).."m" , "F_Grande", pos:ToScreen().x + 32, pos:ToScreen().y - 120 + 100, Color(255,255,255))
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material(icon) )
				surface.DrawTexturedRect( pos:ToScreen().x + 32, pos:ToScreen().y - 120 + 50,50,50 )
			else
				rr = false
			end
end)

end

net.Receive("_icon",function()
	local icon = net.ReadString()
	local pos = net.ReadVector()

	sendIcon(icon,pos)
end)