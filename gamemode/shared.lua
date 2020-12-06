GM.Name = "LifeRP"
GM.Author = "HeadArrow Studios"
GM.Email = "info@headarrow.com"
GM.Website = "liferp.headarrow.com"

DeriveGamemode( "sandbox" )

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

function GM:PlayerNoClip(ply)
	return ply:IsSuperAdmin()
end

team.SetUp(0, "Marginados",Color(0,100,0))
team.SetUp(1, "Abusones",Color(255,255,255))
team.SetUp(2, "Empollones",Color(0,255,0))
team.SetUp(3, "Musculitos",Color(0,0,255))
team.SetUp(4, "Pijos",Color(0,140,255))
team.SetUp(5, "Macarras",Color(0,0,0))
team.SetUp(6, "Profesores",Color(140,0,255))