--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Initialize()
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return self:LFSCalcViewThirdPerson( view, ply )
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	if ply == self:GetGunner() then
		local Pod = ply:GetVehicle()
		
		local radius = 800
		radius = radius + radius * Pod:GetCameraDistance()
		
		local TargetOrigin = self:GetRotorPos() - view.angles:Forward() * radius + view.angles:Up() * 250
		
		local WallOffset = 4

		local tr = util.TraceHull( {
			start = view.origin,
			endpos = TargetOrigin,
			filter = function( e )
				local c = e:GetClass()
				local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
				
				return collide
			end,
			mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
			maxs = Vector( WallOffset, WallOffset, WallOffset ),
		} )
		
		view.drawviewer = true
		view.origin = tr.HitPos
		
		if tr.Hit and not tr.StartSolid then
			view.origin = view.origin + tr.HitNormal * WallOffset
		end
	end
	
	if ply == self:GetBTGunnerL() then
		local ID = self:LookupAttachment( "muzzle_ballturret_left" )
		local Muzzle = self:GetAttachment( ID )
		
		if Muzzle then
			local Pos,Ang = LocalToWorld( Vector(0,20,-45), Angle(270,0,-90), Muzzle.Pos, Muzzle.Ang )
			--view.angles = Ang
			view.origin = Pos
			view.drawviewer = false
		end
	end

	if ply == self:GetBTGunnerR() then
		local ID = self:LookupAttachment( "muzzle_ballturret_right" )
		local Muzzle = self:GetAttachment( ID )
		
		if Muzzle then
			local Pos,Ang = LocalToWorld( Vector(0,20,-45), Angle(270,0,-90), Muzzle.Pos, Muzzle.Ang )
			--view.angles = Ang
			view.origin = Pos
			view.drawviewer = false
		end
	end
	
	return view
end

function ENT:ExhaustFX()
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  80 + Pitch * 25, 50,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
	end
	
	--if self.DIST then
		--self.DIST:ChangePitch(  math.Clamp( 100 + Doppler,0,255) )
		--self.DIST:ChangeVolume( math.Clamp( -1.5 + Pitch * 6, 0.5,1) )
	--end
	
	local OnGround = self:GetIsGroundTouching()
	if self.OldGroundTouching == nil then self.OldGroundTouching = true end
	
	if OnGround ~= self.OldGroundTouching then
		self.OldGroundTouching = OnGround
		if not OnGround then
			self:EmitSound( "LAATi_TAKEOFF" )
		end
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "LAATi_ENGINE" )
		self.ENG:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.BTLOOP then
		self.BTLOOP:Stop()
	end
	
	if self.BTRLOOP then
		self.BTRLOOP:Stop()
	end
	
	if self.BTLLOOP then
		self.BTLLOOP:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
end

function ENT:AnimRotor()
end

function ENT:AnimCabin()
	local FireWingTurret = self:GetWingTurretFire()
	if FireWingTurret ~= self.OldWingTurretFire then
		self.OldWingTurretFire = FireWingTurret
		
		if FireWingTurret then
			self.BTLOOP = CreateSound( self, "LAATi_BT_FIRE_LOOP" )
			self.BTLOOP:Play()
			
			local effectdata = EffectData()
			effectdata:SetEntity( self )
			util.Effect( "laat_wingturret_projector", effectdata )
		else
			if self.BTLOOP then
				self.BTLOOP:Stop()
			end
		end
	end
	
	do
		local Fire = self:GetBTRFire()
		if Fire ~= self.OldFireBTR then
			self.OldFireBTR = Fire
			
			if Fire then
				self.BTRLOOP = CreateSound( self, "LAATi_BT_FIRE_LOOP" )
				self.BTRLOOP:Play()
				
				local effectdata = EffectData()
				effectdata:SetEntity( self )
				util.Effect( "laat_ballturret_right_projector", effectdata )
			else
				if self.BTRLOOP then
					self.BTRLOOP:Stop()
				end
			end
		end
	end
	
	do
		local Fire = self:GetBTLFire()
		if Fire ~= self.OldFireBTL then
			self.OldFireBTL = Fire
			
			if Fire then
				self.BTLLOOP = CreateSound( self, "LAATi_BT_FIRE_LOOP" )
				self.BTLLOOP:Play()
				
				local effectdata = EffectData()
				effectdata:SetEntity( self )
				util.Effect( "laat_ballturret_left_projector", effectdata )
			else
				if self.BTLLOOP then
					self.BTLLOOP:Stop()
				end
			end
		end
	end
end

function ENT:AnimLandingGear()
end

function ENT:Draw()
	self:DrawModel()
end
