
AddCSLuaFile()

SWEP.PrintName = "Manos"
SWEP.Author = "BullyRP"
SWEP.Category = "BullyRP"
SWEP.Instructions = "Click Izquierdo para pegar \nRe-Cargar para subir/bajar puños"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.active = false

SWEP.DrawAmmo = false

SWEP.HitDistance = 48

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()

	self:SetHoldType( "normal" )

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )

end

local check = 0
function SWEP:PrimaryAttack( right )
	check = check + 1

	if check == 1 then
		if SERVER then
				if !IsValid(self) and !IsValid(self.Owner) then return end
				self.Owner:sendNotify("¡Presiona R para bajar o levantar los puños!")
		end
	end

	if self.active then

		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		local anim = "fists_left"
		if ( right ) then anim = "fists_right" end
		if ( self:GetCombo() >= 2 ) then
			anim = "fists_uppercut"
		end

		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

		self:EmitSound( SwingSound )

		self:UpdateNextIdle()
		self:SetNextMeleeAttack( CurTime() + 0.2 )

		self:SetNextPrimaryFire( CurTime() + 0.9 )
		self:SetNextSecondaryFire( CurTime() + 0.9 )
	end
end

function SWEP:SecondaryAttack()

	self:PrimaryAttack( true )

end

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.random( 8, 12 ) )

		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
			dmginfo:SetDamage( math.random( 12, 24 ) )
		end

		tr.Entity:TakeDamageInfo( dmginfo )
		hit = true

	end

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	self.Owner:LagCompensation( false )

end

function SWEP:Deploy()
	if self.active == false then
		self.active = false
		self:SetHoldType( "normal" )
		local speed = GetConVarNumber( "sv_defaultdeployspeed" )
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_holster" ) )
		vm:SetPlaybackRate( speed )

		self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
		self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
		self:UpdateNextIdle()

		if ( SERVER ) then
			self:SetCombo( 0 )
		end
		return
	end

	local speed = GetConVarNumber( "sv_defaultdeployspeed" )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	vm:SetPlaybackRate( speed )

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:UpdateNextIdle()

	if ( SERVER ) then
		self:SetCombo( 0 )
	end

	return true

end

function SWEP:Think()

	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end

	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then

		self:SetCombo( 0 )

	end
end


local nextreload = nextreload or 0
function SWEP:Reload()
	if nextreload > CurTime() then return end
	nextreload = CurTime() + 0.4
	if self.active == false then
		self.active = true
		self:SetHoldType( "fist" )
		local speed = GetConVarNumber( "sv_defaultdeployspeed" )
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
		vm:SetPlaybackRate( speed )

		self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
		self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
		self:UpdateNextIdle()

		if ( SERVER ) then
			self:SetCombo( 0 )
		end
	else
		self.active = false
		self:SetHoldType( "normal" )
		local speed = GetConVarNumber( "sv_defaultdeployspeed" )
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_holster" ) )
		vm:SetPlaybackRate( speed )

		self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
		self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
		self:UpdateNextIdle()

		if ( SERVER ) then
			self:SetCombo( 0 )
		end
	end
end