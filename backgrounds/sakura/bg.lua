background.LoadTexture("mainTex", "bg.png")
resx, resy = game.GetResolution()
portrait = resy > resx
desw = portrait and 720 or 1280 
desh = desw * (resy / resx)
scale = resx / desw
particleCount = 30
particleSizeSpread = 0.5
particles = {}
psize = {
140,
40,
140
}
tex = {
gfx.CreateImage(background.GetPath() .. "petal1.png", 0),
gfx.CreateImage(background.GetPath() .. "petal2.png", 0),
gfx.CreateImage(background.GetPath() .. "petal3.png", 0)
}

function initializeParticle(initial)
	local particle = {}
	particle.x = math.random()
	particle.y = math.random() * 1.2 - 0.1
	if not initial then particle.y = -0.1 end
	particle.r = math.random()
	particle.s = (math.random() - 0.5) * particleSizeSpread + 1.0
	particle.xv = 0
	particle.yv = 0.1
	particle.rv = math.random() * 2.0 - 1.0
	particle.p = math.random() * math.pi * 2
	particle.t = math.random(1,3)
	return particle
end

for i=1,particleCount do
	particles[i] = initializeParticle(true)
end

function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

function render_bg(deltaTime)
background.DrawShader()
local alpha = 0.3 + 0.5 * background.GetClearTransition()
	for i,p in ipairs(particles) do
		p.x = p.x + p.xv * deltaTime
		p.y = p.y + p.yv * deltaTime
		p.r = p.r + p.rv * deltaTime
		p.p = (p.p + deltaTime) % (math.pi * 2)
		
		p.xv = 0.5 - ((p.x * 2) % 1) + (0.5 * sign(p.x - 0.5))
		p.xv = math.max(math.abs(p.xv * 2) - 1, 0) * sign(p.xv)
		p.xv = p.xv * p.y
		p.xv = p.xv + math.sin(p.p) * 0.01
		
		gfx.Save()
		gfx.ResetTransform()
		gfx.Translate(p.x * resx, p.y * resy)
		gfx.Rotate(p.r)
		gfx.Scale(p.s * scale, p.s * scale)
		gfx.BeginPath()
		gfx.ImageRect(-psize[p.t]/2, -psize[p.t]/2, psize[p.t], psize[p.t], tex[p.t], alpha, 0)
		gfx.Restore()
		if p.y > 1.1 then 
			particles[i] = initializeParticle(false)
		end
	end
end
