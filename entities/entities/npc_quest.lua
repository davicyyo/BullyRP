AddCSLuaFile()

if SERVER then
util.AddNetworkString("mision")
end

ENT.Base                        = "base_nextbot"
ENT.Spawnable           = true

function ENT:Initialize()

        
      --self:SetModel(self:GetNWInt("model"))
      self:SetModel("models/konnie/f13chad/f13chad_s.mdl")

end

function ENT:RunBehaviour()
        while ( true ) do
            self:StartActivity( ACT_WALK )
                self.loco:SetDesiredSpeed( 100 )
            self:MoveToPos( self:GetPos() + Vector( -18.016474, -3401.863770, -12735.968750 ) ) -- Walk to a random place within about 400 units ( yielding )
        end

end

function ENT:OnKilled( dmginfo )

    return false

end

local accept = 0
local random = 300
function ENT:AcceptInput( Name, Activator, Caller ) 

   accept = accept + 1

   if accept > 1 then return end

    if SERVER then
        net.Start("mision")
        net.WriteEntity(self)
        net.Send(Caller)
    end

    self:StartActivity( ACT_IDLE )
    self.loco:SetDesiredSpeed( 0 )

    timer.Create("check_StopInteract",1,0,function()
            if self:GetNWBool("canInteract") == true then
                self:StartActivity( ACT_WALK )
                self.loco:SetDesiredSpeed( 100 )
                timer.Remove("check_StopInteract")
            end
    end)

    timer.Create("talking",0.5,0,function()
        if !IsValid(self) then return end
        if self:GetNWBool("canInteract") == true then return end

       self:ResetSequence("Idle_Relaxed_Shotgun_"..math.random(1,9))


    end)

    timer.Simple(1,function()
        accept = 0
    end)
    
end

list.Set( "NPC", "NPC Quest", {
        Name = "NPC Quest",
        Class = "npc_quest",
        Category = "BullyRP"
} )

if CLIENT then

    local canInteract = true

    surface.CreateFont( "NPC_Normal", {
    font = "NarcissusOpenSG",
    extended = false,
    size = ScreenScale(20),
    weight = 500,
    shadow = true,
    } )

    net.Receive("mision",function()
        local ent = net.ReadEntity()

    local check = false
    hook.Add("CalcView", "UserMenuCam", function(pl, pos, ang, fov)
        if !IsValid(ent) then return end
        if check == true then return end
        canInteract = false

        pos = ent:GetPos()
        ang = ent:GetAngles()

        ang.p = 0
        ang:RotateAroundAxis(ang:Up(),150)

        pos = pos - ang:Forward() * 50*1 + ang:Right() * 20*1
        pos.z = pos.z + 60

        local view = {}

        view.origin = pos
        view.angles = ang
        view.fov = 70
        view.drawviewer = true

        return view
    end)

    end)

function ENT:Draw()
    self:DrawModel()

    if canInteract == false then return end

    if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
        local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 500.0)
        alpha = math.Clamp(1.25 - alpha, 0 ,1)
        local a = Angle(0,0,0)
        a:RotateAroundAxis(Vector(1,0,0),90)
        a.y = LocalPlayer():GetAngles().y - 90
        cam.Start3D2D(self:GetPos() + Vector(0,0,75), a , 0.074)
            draw.RoundedBox(0,-225,-70,450,75 , Color(200,100,0,0 * alpha))
            surface.SetDrawColor( 255, 255, 255, 255 ) 
            surface.SetMaterial( Material( "materials/schoolframe.png" ) )
            surface.DrawTexturedRect( ScrW()*-0.15, ScrH()*-0.125, ScrW()*0.3, ScrH()*0.125 ) 
            draw.SimpleText("NUEVA MISIÓN","NPC_Normal",0,-55,Color(247,173,41,255) , 1 , 1)
        cam.End3D2D()
    end
end

end