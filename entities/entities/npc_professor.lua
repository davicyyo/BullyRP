AddCSLuaFile()

ENT.Base                        = "base_nextbot"
ENT.Spawnable           = true

function ENT:Initialize()

        
       self:SetModel("models/player/bobert/enigma_npc.mdl")
       self:SetHealth(200)

        self.LoseTargetDist     = 2000
        self.SearchRadius       = 1000

end

function ENT:OnInjured( info )
	if self:isKilled() then return end

	self:SetEnemy(info:GetAttacker())

	local ply = info:GetAttacker()

	if ply:IsPlayer() then
		ply:setWanted(3)
	end

	self:SetNWBool("hurt",true)
	self:EmitSound("ambient/voices/m_scream1.wav",60, 100, 1, CHAN_VOICE)
end

function ENT:SetEnemy( ent )
        self.Enemy = ent
end

function ENT:isKilled()
	return self:GetNWBool("killed")
end

function ENT:isHurt()
	return self:GetNWBool("hurt")
end

function ENT:GetEnemy()
        return self.Enemy
end

function ENT:HaveEnemy()
        if ( self:GetEnemy() and IsValid( self:GetEnemy() ) ) then
                if ( self:GetRangeTo( self:GetEnemy():GetPos() ) > self.LoseTargetDist ) then
                        return self:FindEnemy()
                elseif ( self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive() ) then
                        return self:FindEnemy()
                end
                return true
        else
                return self:FindEnemy()
        end
end

local hostile = false
local swingpose = false
local checking = 0
function ENT:Think()
	if self:isKilled() then return end

		if ( self:GetEnemy() and IsValid( self:GetEnemy() ) ) then
				if (self:GetRangeTo(self:GetEnemy()) < 5) then
					if self:GetEnemy():IsPlayer() then
						if not self:GetEnemy():Alive() then
							self:SetEnemy(nil)
							self:StartActivity( ACT_WALK )
							self.loco:SetDesiredSpeed( 50 )
							return
						end

						if tonumber(self:GetEnemy():getWanted()) == 3 then
						self:GetEnemy():setWanted(0)
						self:GetEnemy():Freeze(true)
							if checking > 1 then return end

							checking = checking + 1
							swingpose = true
							self.loco:SetDesiredSpeed( 0 )
							self:ResetSequence("throw1")

							timer.Simple(0.8,function()

							if !IsValid(self:GetEnemy()) then return end

							
							self:GetEnemy():SetPos(Vector(438.937073, 1485.354858, 656.031250))
							self:GetEnemy():StripWeapons()
							self:GetEnemy():sendNotify("Te han castigado, ahora deberás esperar 5 minutos para volver a salir, también te han quitado las armas")
							local pl = self:GetEnemy()
							timer.Simple(5,function()
								pl:Freeze(false)
							end)
							timer.Simple(10,function()
								pl:setTeam(pl:getTeam())
								pl:sendNotify("Has Terminado el castigo, intenta portarte bien esta vez")
							end)

							timer.Simple(1,function()
								checking = 0
							end)

							end)
						end
					else
						if checking > 1 then return end
						if self:GetEnemy():isKilled() then

						self:SetEnemy(nil)
						self:StartActivity( ACT_WALK )
						self.loco:SetDesiredSpeed( 50 )

						return
						
						end

						checking = checking + 1

						swingpose = true
						self.loco:SetDesiredSpeed( 0 )
						self:ResetSequence("swing")

						-- a me wa para npc

						timer.Simple(2,function()
								checking = 0
							end)

					end
				else
					if swingpose then
						swingpose = false
						self:StartActivity( ACT_RUN )
						self:ResetSequence("sprint_all")
                        self.loco:SetDesiredSpeed( 200 )
					end
				end
		end

end

function ENT:OnKilled( dmginfo )

	local ply = dmginfo:GetAttacker()

	self:SetNWBool("killed",true)

	if ply:IsPlayer() then
		
		ply:setWanted(3)

		if ply:getStats("noqueados") == nil then
			ply:setStats("noqueados",1)
		else
			ply:setStats("noqueados",ply:getStats("noqueados") + 1)
		end
	end

	self:SetEnemy(nil)
	self.loco:SetDesiredSpeed( 0 )
	timer.Simple(0.1,function()
	self:ResetSequence( "arrestpunch")
		timer.Simple(1,function()
			if not IsValid(self) then return end
			self:ResetSequence( "d1_town05_Wounded_Idle_2")
		end)

		timer.Simple(10,function()
			if !IsValid(self) then return end
			for k,v in pairs(ents.FindByClass(self:GetClass())) do
				if v == self then
					v:Remove()
					self:SetNWBool("killed",false)
				end
			end
		end)

	end)

end

function ENT:FindEnemy()
	if self:isKilled() then return end
       local _ents = ents.FindInSphere( self:GetPos(), self.SearchRadius )
        for k, v in pairs( _ents ) do
                if ( v:IsPlayer() ) then
                	if not v:Alive() then return false end
                            if v:getWanted() > 0 then
                            self:SetEnemy( v )
                            return true
                        	end
                end
        end
        self:SetEnemy( nil )
        return false
end

local alert = 0
function ENT:RunBehaviour()
        while ( true ) do
        		if self:isKilled() then return end
                if ( self:HaveEnemy() ) then

                        self:EmitSound("vo/Citadel/br_ohshit.wav",60,100,1,CHAN_VOICE)
                        self.loco:FaceTowards( self:GetEnemy():GetPos() )
                        self:StartActivity( ACT_RUN )
                        self:ResetSequence("sprint_all")
                        self.loco:SetDesiredSpeed( 250 )
                       	self:ChaseEnemy()
                        self:StartActivity( ACT_IDLE )
                else

                		if self:isHurt() then return end

                       	self:StartActivity( ACT_WALK )
                       	self.loco:SetDesiredSpeed( 100 )
                       	local pos = {
                       	[1] = Vector(-797.783325, -2183.045898, 72.031250),
                       	[2] = Vector(829.176147, -2179.815430, 72.031250),
                       	[3] = Vector(2525.848877, -2197.001221, 72.031250),
                       	[4] = Vector(2818.244141, 305.623474, 72.031250),
                       	[5] = Vector(3745.606201, 352.058685, 72.031250),
                       	[6] = Vector(2818.244141, 305.623474, 72.031250),
                       	[7] = Vector(2827.167480, 4032.507568, 72.031250),
                       	[8] = Vector(2576.957520, 2948.402100, 72.031250),
                       	[9] = Vector(223.426071, 2935.376709, 72.031250),
                       	[10] = Vector(246.297653, 6461.705566, 72.031250),
                       	[11] = Vector(1042.266235, 6538.753906, 72.031250),
                       	[12] = Vector(1046.949097, 8565.451172, 72.031250),
                       	[13] = Vector(179.763809, 8562.862305, 72.031250),
                       	[14] = Vector(168.536011, 9730.435547, -151.968750),
                       	[15] = Vector(-251.635178, 9666.784180, -151.968750),
                       	[16] = Vector(-223.101059, 8564.138672, 72.031250),
                       	[17] = Vector(-1018.012878, 8482.500000, 72.031250),
                       	[18] = Vector(-1051.015259, 6546.128906, 72.031250),
                       	[19] = Vector(-219.125214, 6437.845215, 72.031250),
                       	[20] = Vector(-208.260468, 2931.922852, 72.031250),
                       	[21] = Vector(-2551.628174, 2933.602295, 72.031250),
                       	[22] = Vector(-3034.630615, 2947.908203, 72.031250),
                       	[23] = Vector(-2813.043213, 3934.062744, 72.031250),
                       	[24] = Vector(-2823.437988, 390.834473, 72.031250),
                       	[25] = Vector(-3875.214844, 385.458496, 72.031250),
                       	[26] = Vector(-2823.437988, 390.834473, 72.031250),
                       	[27] = Vector(-2822.402832, -1828.799316, 72.031250),
                       	[28] = Vector(-2466.147705, -2175.163086, 72.031250),
                       	}


                       	timer.Create("checkingstuck",5,0,function()
			            if !IsValid(self) then timer.Remove("checkingstuck") return end

				            local lpos = self:GetPos()

				           	timer.Simple(5,function()
				           		if not IsValid(self) then return end
					            if lpos:Distance(self:GetPos()) < 100 then
					            	self:Remove()
					            	spawnPr()
					            end
				        	end)

			        	end)


                       	local cnt = 0
                       	for k,v in pairs(pos) do
                       		if self:GetPos():Distance(v) > 50 then
                       			cnt = cnt + 1
                       			if cnt == #pos then
                       				self:MoveToPos( pos[1] )
                       			else
                       				if self:isHurt() then cnt = cnt - 1 return end
                       					self:MoveToPos( pos[cnt] )
                       			end
                       		end
                       	end
                        self:StartActivity( ACT_IDLE )
                end
                coroutine.wait( 2 )

        end

end

function ENT:ChaseEnemy( options )

        local options = options or {}

        local path = Path( "Follow" )
        path:SetMinLookAheadDistance( options.lookahead or 300 )
        path:SetGoalTolerance( options.tolerance or 20 )
        path:Compute( self, self:GetEnemy():GetPos() )

        if ( !path:IsValid() ) then return "failed" end

        while ( path:IsValid() and self:HaveEnemy() ) do

                if ( path:GetAge() > 0.1 ) then
                        path:Compute( self, self:GetEnemy():GetPos() )
                end
                path:Update( self )

                if ( options.draw ) then path:Draw() end
                if ( self.loco:IsStuck() ) then
                        self:HandleStuck()
                        return "stuck"
                end

                coroutine.yield()

        end

        return "ok"

end

list.Set( "NPC", "NPC Professor", {
        Name = "NPC Professor",
        Class = "npc_professor",
        Category = "BullyRP"
} )