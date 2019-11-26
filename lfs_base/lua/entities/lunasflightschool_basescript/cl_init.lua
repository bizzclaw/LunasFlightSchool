--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
end

function ENT:Initialize()
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return view
end

function ENT:LFSHudPaintPlaneIdentifier( X, Y, In_Col )
	surface.SetDrawColor( In_Col.r, In_Col.g, In_Col.b, In_Col.a )
	
	local Size = 60
	
	surface.DrawLine( X - Size, Y + Size, X + Size, Y + Size )
	surface.DrawLine( X - Size, Y - Size, X - Size, Y + Size )
	surface.DrawLine( X + Size, Y - Size, X + Size, Y + Size )
	surface.DrawLine( X - Size, Y - Size, X + Size, Y - Size )
end

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	local Col = Throttle <= 100 and Color(255,255,255,255) or Color(255,0,0,255)

	draw.SimpleText( "THR", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( Throttle.."%" , "LFS_FONT", 120, 10, Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "IAS", "LFS_FONT", 10, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "ALT", "LFS_FONT", 10, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( alt.."m" , "LFS_FONT", 120, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	if self:GetMaxAmmoPrimary() > -1 then
		draw.SimpleText( "PRI", "LFS_FONT", 10, 85, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( AmmoPrimary, "LFS_FONT", 120, 85, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end

	if self:GetMaxAmmoSecondary() > -1 then
		draw.SimpleText( "SEC", "LFS_FONT", 10, 110, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( AmmoSecondary, "LFS_FONT", 120, 110, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
end

function ENT:LFSHudPaintInfoLine( HitPlane, HitPilot, LFS_TIME_NOTIFY, Dir, Len, FREELOOK )
	surface.SetDrawColor( 255, 255, 255, 100 )
	if Len > 34 then
		local FailStart = LFS_TIME_NOTIFY > CurTime()
		if FailStart then
			surface.SetDrawColor( 255, 0, 0, math.abs( math.cos( CurTime() * 10 ) ) * 255 )
		end
		
		if not FREELOOK or FailStart then
			surface.DrawLine( HitPlane.x + Dir.x * 10, HitPlane.y + Dir.y * 10, HitPilot.x - Dir.x * 34, HitPilot.y- Dir.y * 34 )
			
			-- shadow
			surface.SetDrawColor( 0, 0, 0, 50 )
			surface.DrawLine( HitPlane.x + Dir.x * 10 + 1, HitPlane.y + Dir.y * 10 + 1, HitPilot.x - Dir.x * 34+ 1, HitPilot.y- Dir.y * 34 + 1 )
		end
	end
end

function ENT:LFSHudPaintCrosshair( HitPlane, HitPilot )
	surface.SetDrawColor( 255, 255, 255, 255 )
	simfphys.LFS.DrawCircle( HitPlane.x, HitPlane.y, 10 )
	surface.DrawLine( HitPlane.x + 10, HitPlane.y, HitPlane.x + 20, HitPlane.y ) 
	surface.DrawLine( HitPlane.x - 10, HitPlane.y, HitPlane.x - 20, HitPlane.y ) 
	surface.DrawLine( HitPlane.x, HitPlane.y + 10, HitPlane.x, HitPlane.y + 20 ) 
	surface.DrawLine( HitPlane.x, HitPlane.y - 10, HitPlane.x, HitPlane.y - 20 ) 
	simfphys.LFS.DrawCircle( HitPilot.x, HitPilot.y, 34 )
	
	-- shadow
	surface.SetDrawColor( 0, 0, 0, 80 )
	simfphys.LFS.DrawCircle( HitPlane.x + 1, HitPlane.y + 1, 10 )
	surface.DrawLine( HitPlane.x + 11, HitPlane.y + 1, HitPlane.x + 21, HitPlane.y + 1 ) 
	surface.DrawLine( HitPlane.x - 9, HitPlane.y + 1, HitPlane.x - 16, HitPlane.y + 1 ) 
	surface.DrawLine( HitPlane.x + 1, HitPlane.y + 11, HitPlane.x + 1, HitPlane.y + 21 ) 
	surface.DrawLine( HitPlane.x + 1, HitPlane.y - 19, HitPlane.x + 1, HitPlane.y - 16 ) 
	simfphys.LFS.DrawCircle( HitPilot.x + 1, HitPilot.y + 1, 34 )
end

function ENT:LFSHudPaintRollIndicator( HitPlane, Enabled )
	if not Enabled then return end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	local Roll = self:GetAngles().roll
	
	local X = math.cos( math.rad( Roll ) )
	local Y = math.sin( math.rad( Roll ) )
	
	surface.DrawLine( HitPlane.x + X * 50, HitPlane.y + Y * 50, HitPlane.x + X * 125, HitPlane.y + Y * 125 ) 
	surface.DrawLine( HitPlane.x - X * 50, HitPlane.y - Y * 50, HitPlane.x - X * 125, HitPlane.y - Y * 125 ) 
	
	surface.DrawLine( HitPlane.x + 125, HitPlane.y, HitPlane.x + 130, HitPlane.y + 5 ) 
	surface.DrawLine( HitPlane.x + 125, HitPlane.y, HitPlane.x + 130, HitPlane.y - 5 ) 
	surface.DrawLine( HitPlane.x - 125, HitPlane.y, HitPlane.x - 130, HitPlane.y + 5 ) 
	surface.DrawLine( HitPlane.x - 125, HitPlane.y, HitPlane.x - 130, HitPlane.y - 5 ) 
	
	surface.SetDrawColor( 0, 0, 0, 80 )
	surface.DrawLine( HitPlane.x + X * 50 + 1, HitPlane.y + Y * 50 + 1, HitPlane.x + X * 125 + 1, HitPlane.y + Y * 125 + 1 ) 
	surface.DrawLine( HitPlane.x - X * 50 + 1, HitPlane.y - Y * 50 + 1, HitPlane.x - X * 125 + 1, HitPlane.y - Y * 125 + 1 ) 
	
	surface.DrawLine( HitPlane.x + 126, HitPlane.y + 1, HitPlane.x + 131, HitPlane.y + 6 ) 
	surface.DrawLine( HitPlane.x + 126, HitPlane.y + 1, HitPlane.x + 131, HitPlane.y - 4 ) 
	surface.DrawLine( HitPlane.x - 126, HitPlane.y + 1, HitPlane.x - 129, HitPlane.y + 6 ) 
	surface.DrawLine( HitPlane.x - 126, HitPlane.y + 1, HitPlane.x - 129, HitPlane.y - 4 ) 
end

function ENT:LFSHudPaint( X, Y, data, ply )
end

function ENT:LFSHudPaintPassenger( X, Y, ply )
end

function ENT:Think()
	self:AnimCabin()
	self:AnimLandingGear()
	self:AnimRotor()
	self:AnimFins()
	
	self:CheckEngineState()
	
	self:ExhaustFX()
	self:DamageFX()
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetRotorPos() - self:GetForward() * 50 )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:ExhaustFX()
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
end

function ENT:EngineActiveChanged( bActive )
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
end

function ENT:CheckEngineState()
	local Active = self:GetEngineActive()
	
	if Active then
		local RPM = self:GetRPM()
		local LimitRPM = self:GetLimitRPM()
		
		local tPer = RPM / LimitRPM
		
		local CurDist = (LocalPlayer():GetViewEntity():GetPos() - self:GetPos()):Length()
		self.PitchOffset = self.PitchOffset and self.PitchOffset + (math.Clamp((CurDist - self.OldDist) * FrameTime() * 300,-40,20 *  tPer) - self.PitchOffset) * FrameTime() * 5 or 0
		self.OldDist = CurDist
		
		local Pitch = (RPM - self:GetIdleRPM()) / (LimitRPM - self:GetIdleRPM())
		
		self:CalcEngineSound( RPM, Pitch, -self.PitchOffset )
	end
	
	if self.oldEnActive ~= Active then
		self.oldEnActive = Active
		self:EngineActiveChanged( Active )
	end
end

function ENT:AnimFins()
end

function ENT:AnimRotor()
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

function ENT:GetCrosshairFilterEnts()
	if not istable( self.CrosshairFilterEnts ) then
		self.CrosshairFilterEnts = {self}
		
		-- lets ask the server to build the filter for us because it has access to constraint.GetAllConstrainedEntities() 
		net.Start( "lfs_player_request_filter" )
			net.WriteEntity( self )
		net.SendToServer()
	end

	return self.CrosshairFilterEnts
end