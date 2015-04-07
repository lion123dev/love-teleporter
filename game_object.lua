GameObject = { }
GameObject.__index = GameObject
function GameObject.create()
	local self = setmetatable({}, GameObject)
	self.x = 0
	self.y = 0
	self.width = 1
	self.height = 1
	
	return self
end

function GameObject:setSizes(_width, _height)
	self.width = _width;
	self.height = _height;
end

function GameObject:setImage(_image)
	self.image = love.graphics.newImage(_image)
	self:setSizes(self.image:getWidth(),self.image:getHeight())
end

function GameObject:render()
	love.graphics.draw(self.image, self.x, self.y)
	if (self.particle ~= nil) then
		love.graphics.draw(self.particle,self.x + self.width/2, self.y + self.height/2)
	end
end

function GameObject:collide(_secondObject)
	if ((((_secondObject.x >= self.x) and (_secondObject.x < self.x+self.width)) or ((self.x >= _secondObject.x) and (self.x < _secondObject.x+_secondObject.width))) and (((_secondObject.y >= self.y) and (_secondObject.y < y1+self.height)) or ((self.y >= _secondObject.y) and (self.y < _secondObject.y+_secondObject.height)))) then
		return true
	end
	return false
end

function GameObject:move(_dx, _dy)
	self.x = self.x + _dx
	self.y = self.y + _dy
end

function GameObject:moveX(_dx)
	self.x = self.x + _dx
end

function GameObject:moveY(_dy)
	self.y = self.y + _dy
end

function GameObject:setPosition(_x, _y)
	self.x = _x
	self.y = _y
end

function GameObject:update(dt)
	if (self.particle ~= nil) then
		self.particle:update(dt)
	end
end

function GameObject:setParticleSystem( _number, _frequence, _lifeTimeMin, _lifeTimeMax, _radius, _sizeVariation)
	self.particle = love.graphics.newParticleSystem(self.image, _number)
	self.particle:setParticleLifetime(_lifeTimeMin, _lifeTimeMax);
	self.particle:setEmissionRate(_frequence);
	self.particle:setLinearAcceleration(-_radius, -_radius, _radius, _radius);
	self.particle:setSizeVariation(_sizeVariation);
end