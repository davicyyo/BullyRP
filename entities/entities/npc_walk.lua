AddCSLuaFile()

ENT.Base                        = "base_nextbot"
ENT.Spawnable           = true

function ENT:Initialize()

        
       --self:SetModel(table.Random(team[tonumber(self:GetNWInt("team"))].model))
       --self:SetHealth(team[tonumber(self:GetNWInt("team"))].hp)
       self:SetModel("models/winningrook/gtav/clowns/clown_000.mdl")
       self:SetHealth(80)

        self.LoseTargetDist     = 2000  -- How far the enemy has to be before we lose them
        self.SearchRadius       = 1000  -- How far to search for enemies
        self:SetNWBool("killed",false)

end

function ENT:OnInjured( info )
	if self:isKilled() then return end
	if self:isHurt() then return end

	self:SetEnemy(info:GetAttacker())

	self:SetNWBool("hurt",true)
	self:EmitSound("ambient/voices/m_scream1.wav",60, 100, 1, CHAN_VOICE)
	self:ResetSequence("Crouch_idleD")
	self.loco:SetDesiredSpeed( 0 )

	timer.Simple(0.5,function()
		if self:isKilled() then return end
		self:ResetSequence("crouchhidetostand")
	end)

	timer.Simple(1,function()
		if not IsValid(self) then return end
		self:SetNWBool("hurt",false)

		self:ResetSequence("sprint_all")
		self.loco:SetDesiredSpeed( 200 )
	end)
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
	if self:isHurt() then return end

		if ( self:GetEnemy() and IsValid( self:GetEnemy() ) ) then
				if (self:GetRangeTo(self:GetEnemy()) < 10) then
					if self:GetEnemy():IsPlayer() then
						if not self:GetEnemy():Alive() then
							self:SetEnemy(nil)
							self:StartActivity( ACT_WALK )
							self.loco:SetDesiredSpeed( 50 )
							return
						end
							if checking > 1 then return end

							checking = checking + 1
							swingpose = true
							self.loco:SetDesiredSpeed( 0 )
							self:ResetSequence("swing")

							timer.Simple(0.4,function()

								if !IsValid(self:GetEnemy()) then return end

							self:GetEnemy():EmitSound("ambient/voices/m_scream1.wav",80, 100, 1, CHAN_VOICE)
							self:GetEnemy():TakeDamage( 10 )
							self:GetEnemy():ViewPunch(Angle( 30, 0, 0 ))
							timer.Simple(1,function()
								checking = 0
							end)

							end)
					else
						if checking > 1 then return end
						if self:GetEnemy():isHurt() then return end
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

						self:GetEnemy():EmitSound("ambient/voices/m_scream1.wav",80, 100, 1, CHAN_VOICE)
						self:GetEnemy():TakeDamage( 10 )

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
		
		if ply:getWanted() != 3 then
			ply:setWanted(ply:getWanted() + 1)
		end

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
        	if v:GetNWBool("kickme") then
        		if v == self then return end
        			if v:isKilled() then return end
        			self:SetEnemy( v )
        		return true
        	end
                if ( v:IsPlayer() ) then
                	if not v:Alive() then return false end
                            if 40 > 50 then 
                            	return false
                            else
                            self:SetEnemy( v )
                            return true
                        	end
                end
        end
        self:SetEnemy( nil )
        return false
end

function ENT:RunBehaviour()
        while ( true ) do
        		if self:isKilled() then return end
                if ( self:HaveEnemy() ) then

                        self:EmitSound("vo/Citadel/br_ohshit.wav",60,100,1,CHAN_VOICE)
                        self.loco:FaceTowards( self:GetEnemy():GetPos() )
                        self:StartActivity( ACT_RUN )
                        self:ResetSequence("sprint_all")
                        self.loco:SetDesiredSpeed( 200 )
                       	self:ChaseEnemy()
                        self:StartActivity( ACT_IDLE )
                else
                       	self:StartActivity( ACT_WALK )
                       	self.loco:SetDesiredSpeed( 100 )
                        self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 ) -- Walk to a random place within about 400 units ( yielding )
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

list.Set( "NPC", "NPC Walk", {
        Name = "NPC Walk",
        Class = "npc_walk",
        Category = "BullyRP"
} )