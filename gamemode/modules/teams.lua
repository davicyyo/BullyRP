local ply = FindMetaTable("Player")

local team = {}

team[0] = {

	name = "Marginados",
	sweps = {"hands"},
	hp = 80,
	speedwalk = 200,
	default = true,
	lvl = false,
	models = {
	"models/player/bully/constantinos/constantinos.mdl",
	"models/player/bully/gordon/gordon.mdl",
	"models/player/bully/ivan/ivan.mdl",
	"models/player/bully/trevor/trevor.mdl"},
	pos = {Vector(589.150513, 3395.200439, 72.031250)}

}

team[1] = {

	name = "Abusones",
	sweps = {"hands"},
	hp = 100,
	speedwalk = 100,
	lvl = 10,
	models = {
	"models/player/bully/davis/davis.mdl",
	"models/player/bully/derby/derby.mdl",
	"models/player/bully/tom/tom.mdl",
	"models/player/bully/trent/trent.mdl"},
	pos = {
	Vector(-4994.603516, 1415.122437, 136.031250),
	Vector(-4861.560059, 1413.867920, 136.031250),
	Vector(-4609.677734, 1411.491577, 136.031250),
	Vector(-4471.059082, 1410.183838, 136.031250),
	Vector(-4336.029785, 1435.679810, 136.031250)}

}

team[2] = {

	name = "Empollones",
	sweps = {"hands"},
	hp = 30,
	speedwalk = 80,
	lvl = 30,
	models = {
	"models/player/bully/algernon/algernon.mdl",
	"models/player/bully/bucky/bucky.mdl",
	"models/player/bully/cornelius/cornelius.mdl"},
	pos = {
	Vector(2542.391602, 4522.185059, 384.031250),
	Vector(3089.498291, 4517.554199, 384.031250),
	Vector(3416.191406, 4556.482422, 312.031250),
	Vector(2197.078857, 4556.887207, 312.031250),
	Vector(1621.985352, 4653.920898, 488.000183)}

}

team[3] = {

	name = "Musculitos",
	sweps = {"hands"},
	hp = 200,
	speedwalk = 300,
	lvl = 20,
	models = {
	"models/player/bully/casey/casey.mdl",
	"models/player/bully/damon/damon.mdl",
	"models/player/bully/juri/juri.mdl"},
	pos = {
	Vector(885.491821, 9724.033203, -151.968750),
	Vector(591.554138, 9710.679688, -151.968750),
	Vector(-591.432739, 9737.077148, -151.968750),
	Vector(-933.019897, 9734.971680, -151.968750),
	Vector(5.463349, 10130.071289, -151.968750)}

}

team[4] = {

	name = "Pijos",
	sweps = {"hands"},
	hp = 200,
	speedwalk = 300,
	lvl = 50,
	models = {
	"models/player/bully/bif/bif.mdl",
	"models/player/bully/bryce/bryce.mdl",
	"models/player/bully/chad/chad.mdl",
	"models/player/bully/gord/gord.mdl",
	"models/player/bully/parker/parker.mdl",
	"models/player/bully/tad/tad.mdl"},
	pos = {
	Vector(1250.404053, 459.667694, 400.031250),
	Vector(-1246.921387, 714.481262, 400.031250),
	Vector(-1246.921387, 714.481262, 400.031250),
	Vector(1244.427490, 157.970306, 400.031250),
	Vector(1254.426880, 718.337769, 400.031250)}

}

team[5] = {

	name = "Macarras",
	sweps = {"hands"},
	hp = 100,
	speedwalk = 100,
	lvl = 40,
	models = {
	"models/player/bully/hal/hal.mdl",
	"models/player/bully/norton/norton.mdl",
	"models/player/bully/peanut/peanut.mdl"},
	pos = {
	Vector(4316.548340, 529.554260, 416.031250),
	Vector(4323.178223, 175.981781, 416.031250),
	Vector(4833.849609, 436.858063, 416.031250),
	Vector(4831.691406, 344.015991, 416.031250),
	Vector(4828.177246, 186.285950, 416.031250)}

}

team[6] = {

	name = "Profesores",
	sweps = {"weapon_fists"},
	hp = 400,
	speedwalk = 100,
	lvl = 60,
	models = {},
	pos = {
	Vector(-1593.453003, -589.883850, 144.031250),
	Vector(-1646.267700, -416.993988, 144.031250),
	Vector(1494.260742, -677.021790, 144.031250),
	Vector(1647.968750, -419.856903, 144.031250),
	Vector(1.620113, 795.677063, 144.031250)}

}


function ply:setUpTeam(n)
	if SERVER then
	local values = {0,1,2,3,4,5,6}
	if table.HasValue(values,n) then return end

	n = tonumber(n)

	if team[n].lvl != false then
		if self:getLVL() < team[n].lvl then self:sendNotify("No dispones de nivel "..team[n].lvl.." para entrar en esta banda") return end
	end

	self:SetPos(table.Random(team[n].pos))

	self:SetTeam(n)
	self:SetHealth(team[n].hp)
	self:SetMaxHealth(team[n].hp)
	self:SetRunSpeed(team[n].speedwalk)
	self:SetModel(table.Random(team[n].models))
	timer.Simple(2,function()
	self:StripWeapons()
	for k,wp in pairs(team[n].sweps) do
		self:Give(wp)
	end
	end)
	end
end