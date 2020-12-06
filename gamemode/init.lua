AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local nets = {"D_main", "death_screen","newgame","loadgame","sendModel","removeModel","green","newHUDClass","newQuest","ThirdOTSPacket","ThirdOTSReq","_notify","_class","stop_sounds","_sound","_icon"}

for k,v in pairs(nets) do
	util.AddNetworkString(v)
end

local files = {
"resource/fonts/narcissusopensg.ttf",
"materials/b_bell.png",
"materials/b_bell2.png",
"materials/schoolframe.png",
"materials/bm/basketball.vtf",
"materials/bm/basketball_normal.vtf",
"materials/minimap/arrow.png",
"materials/minimap/arrow.png",
"materials/minimap/bully_simplificado.png",
"materials/minimap/compass.png",
}

for k,v in pairs(files) do
	resource.AddFile(v)
end

local workshop = {
	"https://steamcommunity.com/sharedfiles/filedetails/?id=894719011",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=881703270",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=548792844",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=713965272",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=713722042",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=714639477",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=764821451",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=198118356",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=794151170",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=572267883",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=263446966",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=1246022789",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=887889470",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=1118827309",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=889681148",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=1273191703",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=105225353",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=1403389931",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=810090879",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=746448809",
	"https://steamcommunity.com/sharedfiles/filedetails/?id=1356583184"
}

for _,wk in pairs(workshop) do
	if string.match( string.Right(wk,10), "=" ) then
		resource.AddWorkshop(string.Right(wk,9))
	else
		resource.AddWorkshop(string.Right(wk,10))
	end
end

/*function spawnPr()
	local ent = ents.Create("npc_professor")
	if ( !IsValid( ent ) ) then return end
	ent:SetPos(Vector(-1131.028076, -2173.579590, 72.031250))
	ent:Spawn()
end

timer.Create("spawn_proffessors",40,20,spawnPr)*/

local files = file.Find( "gamemodes/bullyrp/gamemode/modules/*", "GAME" )
	MsgC( Color( 255, 0, 0 ), "-----------------------------------------------------------------\n" )
	MsgC( Color( 255, 0, 0 ), "[BULLYRP]",Color( 255, 255, 255 ), " Load Modules\n" )
	MsgC( Color( 255, 0, 0 ), "-----------------------------------------------------------------\n" )
	MsgC( Color( 255, 255, 255 ), "\n")
	for _,v in pairs(files) do
		MsgC( Color( 255, 0, 0 ), "File: ",Color( 255, 255, 255 ), v.."\n" )
		AddCSLuaFile("modules/" .. v)
		include("modules/" .. v)
	end
	MsgC( Color( 255, 255, 255 ), "\n")
	MsgC( Color( 255, 0, 0 ), "-----------------------------------------------------------------\n" )


timer.Simple(4,function()
local doors = {390,389}
for k,door in pairs(ents.FindByClass("prop_door_rotating")) do
	for _,id in pairs(doors) do
		if door:EntIndex() == id then
			door:Fire("lock")
		end
	end
end
end)

function GM:PlayerInitialSpawn(ply)
	timer.Simple(2,function()
	ply:SetupHands()
	end)

	if ply:getTeam() == nil then
		ply:setTeam(0)
	else
		ply:setTeam(ply:getTeam())
	end

	if ply:getSettings("music") == nil then
		ply:setSettings("music",true)
	end

	if ply:getStats("misiones") == nil then
		ply:setStats("misiones",0)
	end

	if ply:getStats("noqueados") == nil then
		ply:setStats("noqueados",0)
	end

	if ply:getStats("progreso") == nil then
		ply:setStats("progreso",0)
	end

	ply:loadData()

	ply:SetPos(Vector(586.638184, -544.025330, 1240.744873))

	local class = file.Read("class.txt","DATA")

	ply:SetNWInt("class",class)

	timer.Simple(1,function()
	net.Start("D_main")
	net.Send(ply)
	end)

end

function GM:PlayerSpawn(ply)
	timer.Simple(2,function()
	ply:SetupHands()
	end)
	ply:setTeam(ply:getTeam())

	if ply:GetNWBool("killed") then
		timer.Simple(1,function()
			ply:SetPos(Vector(-3219.609131, 5494.263184, 144.031250))

			ply:sendNotify("Te han quitado las armas mientras estabas inconsciente, no están permitidas en la escuela.")
		end)
		ply:SetNWBool("killed",false)
	end
end


function GM:PlayerDeath( victim, inflictor, attacker )
	net.Start( "death_screen" )
	net.Send( victim )
	timer.Simple( 5, function()
		victim:Spawn()
	end )
	victim:SetNWBool("killed",true)
	victim:setWanted(0)
	if victim == attacker then return end
	if attacker:getWanted() == nil then return end
	if tonumber(attacker:getWanted()) == 3 then return end


	
	attacker:setWanted(attacker:getWanted() + 1)

end

timer.Create("saveTime",1,0,function()
	for k,v in pairs(player.GetAll()) do
		if v:getStats("tiempo") == nil then
			v:setStats("tiempo",0)
		end
		v:setStats("tiempo",v:getStats("tiempo") + 1)
	end
end)

function GM:ShowHelp( ply )
	return
end


function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end


net.Receive("newgame",function()
	local ply = net.ReadEntity()

	ply:setLVL(0)
	for i=0,6 do
		ply:setRespect(team.GetName(i),0)
	end
	ply:setMoney(10)
	ply:setTeam(0)
	--ply:newQuest("Vé a hablar con el director")
end)

net.Receive("loadgame",function()
	local ply = net.ReadEntity()
	
	ply:setTeam(ply:getTeam())
	if ply:getQuest() == "none" then return end
	ply:newQuest(ply:getQuest())
end)

net.Receive("_class",function()
	local ply = net.ReadEntity()
	local str = net.ReadString()
	local num = net.ReadString()

	num = tonumber(num)

	ply:classComplete(str,num)

end)

hook.Add( "PlayerDeathThink", "PlayerDeathThinkNoRespawn", function( ply )
	return false
end )

net.Receive("stop_sounds",function()
	local ply = net.ReadEntity()

	ply:SetNWBool("stopsound",true)
end)