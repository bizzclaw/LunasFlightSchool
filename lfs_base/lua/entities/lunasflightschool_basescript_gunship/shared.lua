ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "basescript gunship"
ENT.Author = "Blu"
ENT.Information = ""
ENT.Category = "[LFS]"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.MaxTurnPitch = 50
ENT.MaxTurnYaw = 50
ENT.MaxTurnRoll = 50

ENT.PitchDamping = 1
ENT.YawDamping = 1
ENT.RollDamping = 1

ENT.TurnForcePitch = 500
ENT.TurnForceYaw = 500
ENT.TurnForceRoll = 500

ENT.IdleRPM = 0
ENT.MaxRPM = 100
ENT.LimitRPM = 100

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 100
ENT.MaxThrustVtol = 400

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Driver" )
	self:NetworkVar( "Entity",1, "DriverSeat" )
	self:NetworkVar( "Entity",2, "Gunner" )
	self:NetworkVar( "Entity",3, "GunnerSeat" )
	
	self:NetworkVar( "Bool",0, "Active" )
	self:NetworkVar( "Bool",1, "EngineActive" )
	self:NetworkVar( "Bool",3, "IsGroundTouching" )
	self:NetworkVar( "Bool",2, "AI",	{ KeyName = "aicontrolled",	Edit = { type = "Boolean",	order = 1,	category = "AI"} } )
	self:NetworkVar( "Bool",4, "RotorDestroyed" )
	
	self:NetworkVar( "Int",2, "AITEAM", { KeyName = "aiteam", Edit = { type = "Int", order = 2,min = 0, max = 2, category = "AI"} } )
	
	self:NetworkVar( "Float",0, "LGear" )
	self:NetworkVar( "Float",1, "RGear" )
	self:NetworkVar( "Float",2, "RPM" )
	self:NetworkVar( "Float",3, "RotPitch" )
	self:NetworkVar( "Float",4, "RotYaw" )
	self:NetworkVar( "Float",5, "RotRoll" )
	self:NetworkVar( "Float",6, "HP", { KeyName = "health", Edit = { type = "Float", order = 2,min = 0, max = self.MaxHealth, category = "Misc"} } )
	
	self:NetworkVar( "Float",7, "Shield" )
	
	
	self:NetworkVar( "Int",0, "AmmoPrimary", { KeyName = "primaryammo", Edit = { type = "Int", order = 3,min = 0, max = self.MaxPrimaryAmmo, category = "Weapons"} } )
	self:NetworkVar( "Int",1, "AmmoSecondary", { KeyName = "secondaryammo", Edit = { type = "Int", order = 4,min = 0, max = self.MaxSecondaryAmmo, category = "Weapons"} } )

	if SERVER then
		self:NetworkVarNotify( "AI", self.OnToggleAI )
		
		self:SetAITEAM( self.AITEAM )
		self:SetHP( self.MaxHealth )
		self:SetShield( self.MaxShield )
		self:OnReloadWeapon()
	end
	
	self:AddDataTables()
end