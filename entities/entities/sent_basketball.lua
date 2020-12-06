AddCSLuaFile()

if SERVER then
	resource.AddFile( "materials/entities/sent_basketball.png" )
end

ENT.Type             = "anim"
ENT.Base             = "base_anim"
ENT.PrintName        = "Basketball"
ENT.Category		= "Fun + Games"
ENT.Author="Jvs"
ENT.Spawnable = true  
ENT.AdminOnly = false  

if CLIENT then
	ENT.HitMaterial = Material( util.DecalMaterial( "impact.metal" ) )
end

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then return end

	local spawnpos = tr.HitPos + tr.HitNormal * 25

	local ent = ents.Create( "sent_basketball" )
	ent:SetPos( spawnpos )
	ent:Spawn()
	return ent
end

function ENT:SetupDataTables()
	self:NetworkVar( "Float"	, 0 , "LastImpact" )
end

function ENT:Initialize()
	if SERVER then
		self:SetMaxHealth( 50 )
		self:SetHealth( 50 )
		self:SetLagCompensated( true )	--players can shoot at us even with their shitty ping!
		self:SetUseType( SIMPLE_USE )	--don't let players spam +use on us, that's rude
		self:SetModel( "models/bm/basketball.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		self:SetTrigger( true )	--allow us to use touch,starttouch and whatever even if we can't collide with the player
		
		local physobj =  self:GetPhysicsObject() 
		
		if IsValid( physobj ) then
			physobj:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
			physobj:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
			physobj:SetBuoyancyRatio( 0.5 )
			physobj:SetDamping( 0.25 , 1 )
			physobj:Wake( )
		end
		
	end
	
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
end

function ENT:OnTakeDamage( dmginfo )
	
	if self:Health() <= 0 then return end
	
	self:TakePhysicsDamage( dmginfo )
	
	self:SetHealth( self:Health() - dmginfo:GetDamage() )
	
	if self:Health() <= 0 then
	
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "soccerball_explode", effectdata )
		
		self:Remove()
		return
	end
	
end

function ENT:Use( activator )
	if self:IsPlayerHolding() then return end
	if IsValid( activator ) and activator:IsPlayer() then
		activator:PickupObject( self )
	end
end

function ENT:PhysicsCollide( data, physobj )
	
	if not SERVER then return end
	
	if self:IsPlayerHolding() then return end
	
	if self:GetLastImpact() < CurTime() and data.DeltaTime > 0.2 and data.OurOldVelocity:Length( ) >100 then 
		self:EmitSound( "Rubber.ImpactHard" )
		self:SetLastImpact( CurTime() + 0.1 )
	end

end

function ENT:PhysicsUpdate( physobj )
	if not SERVER then return end
	
	if self:IsPlayerHolding() then return end
	
	--the gravity gun, + use and the physgun all fuck up these settings, set them back
	
	physobj:SetMass( 10 )
	physobj:SetBuoyancyRatio( 0.5 )
	physobj:SetDamping( 0.25 , 1 )
	
end



function ENT:StartTouch( ent )
	if not SERVER then return end
	
	if not IsValid( ent ) then return end
	
	if self:IsPlayerHolding() then return end
	
	if ent:IsPlayer() and ent:GetMoveType() ~= MOVETYPE_WALK then return end
	
	local tr = self:GetTouchTrace()
	
	local direction = tr.Normal
		
	local normal = (ent:WorldSpaceCenter() - self:GetPos() ):GetNormal() * -1
	local physobj = self:GetPhysicsObject()
	local ourvel = self:GetVelocity()
	local theirvel = ent:GetVelocity()
	
	
	if IsValid( physobj ) and ( ent:IsPlayer() or ent:IsNPC() ) then
		
		local aimvec = ent:EyeAngles()
		aimvec.p = 0
		aimvec = aimvec:Forward()
		aimvec.z = 0
		
		if aimvec:Dot( theirvel:GetNormal() ) < 0 then
			theirvel = vector_origin
			theirvel = normal * physobj:GetMass() * 15
		end
		--kick the ball!
		if theirvel ~= vector_origin then
			self:EmitSound( "Rubber.BulletImpact" )
			physobj:SetVelocityInstantaneous(  theirvel * 2.5 + Vector( 0, 0 , 15 * physobj:GetMass() )  )
			self:SetLastImpact( CurTime() + 0.1 )
		else --bounce the ball back
			self:EmitSound( "Rubber.ImpactHard" )
			physobj:SetVelocityInstantaneous( -1 * normal * ourvel:Dot( normal ) )
		end
		self:SetLastImpact( CurTime() + 0.1 ) --we just kick the ball, suppress the bounce sound for a little while
	end
end



function ENT:ImpactTrace( tr , dmgbits , customImpactName )
	if CLIENT then
		if bit.bor( dmgbits , DMG_BULLET ) ~= 0 then
			util.DecalEx( self.HitMaterial, self, tr.HitPos , tr.Normal , color_white, 4,  4 )
		end
	end
	return true
end

if SERVER then
	--this code is not enabled, what it does is lag compensate everything back before the player moved, this way we can 
	--give a chance to laggy players to hit the soccerball, but since Kilburn hasn't implemented a filter to lagcompensation yet, this'll stay disabled
	--we surely don't want to lag compensate a full server of 60+ people for EACH player each frame, no no
	
	--[[
	hook.Add( "SetupMove" , "Soccerball lag comp", function( ply , mv , cmd)
		ply:LagCompensation( true )
	end)
	
	hook.Add( "FinishMove","Soccerball lag comp", function( ply , mv , cmd)
		ply:LagCompensation( false )
	end)
	]]
end
