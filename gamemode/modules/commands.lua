if SERVER then

concommand.Add("bullyrp_music",function(ply)
	if tobool(ply:getSettings("music")) then
		ply:setSettings("music",false)
		ply:PrintMessage(HUD_PRINTTALK,"[BULLYRP] La música ha sido desactivada")
	else
		ply:setSettings("music",true)
		ply:PrintMessage(HUD_PRINTTALK,"[BULLYRP] La música ha sido activada")
	end
end)

concommand.Add("test",function(ply)
	--ply:sendClass("matematicas",1)
	ply:SetPos(Vector(-1166.790283, -491.046448, 160.031250))
end)

hook.Add("PlayerSay","!musica",function(ply,text)
	if (text == "!musica") or (text == "/musica") then
		ply:ConCommand("bullyrp_music")
	end
end)

concommand.Add("get_ent",function(ply)
	if !ply:IsSuperAdmin() then return end

	local trace = ply:GetEyeTrace()
	local ent = trace.Entity

	print(ent)
	print(ent:EntIndex())
end)

end