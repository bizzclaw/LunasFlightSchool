--DO NOT EDIT OR REUPLOAD THIS FILE

function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.Col = data:GetStart() or Vector(255,100,0)
	
	sound.Play( Sound( "lfs/laser_hitgeneric.ogg" ), self.Pos, SNDLVL_60dB )
	
	self.mat = Material( "sprites/light_glow02_add" )
	
	self.LifeTime = 0.2
	self.DieTime = CurTime() + self.LifeTime

	local Col = self.Col
	local Pos = self.Pos
	local Dir = data:GetNormal()
	
	local emitter = ParticleEmitter( Pos, false )
	
	for i = 0, 10 do
		local particle = emitter:Add( "sprites/light_glow02_add", Pos )
		
		local vel = VectorRand() * 100 - Dir  * 40
		
		if particle then
			particle:SetVelocity( vel )
			particle:SetAngles( vel:Angle() + Angle(0,90,0) )
			particle:SetDieTime( math.Rand(0.2,0.4) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(6,12) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(-100,100) )
			particle:SetRollDelta( math.Rand(-100,100) )
			particle:SetColor( Col.x,Col.y,Col.z )
			particle:SetGravity( Vector(0,0,-600) )

			particle:SetAirResistance( 0 )
			
			particle:SetCollide( true )
			particle:SetBounce( 0.5 )
		end
	end
	
	emitter:Finish()
end

function EFFECT:Think()
	if self.DieTime < CurTime() then return false end

	return true
end

function EFFECT:Render()
	local Scale = (self.DieTime - CurTime()) / self.LifeTime
	render.SetMaterial( self.mat )
	render.DrawSprite( self.Pos, 100 * Scale, 100 * Scale, Color( self.Col.x, self.Col.y, self.Col.z, 255) )
	render.DrawSprite( self.Pos, 25 * Scale, 25 * Scale, Color( 255, 255, 255, 255) )
end
