require("objects.dynamic_object")
ENEMY_START_SPEED = 1
ENEMY_INC_SPEED = 0
ENEMY_STARTX = 300
ENEMY_STARTY = 400
Enemy = { }
Enemy.__index = Enemy
setmetatable(Enemy, DynamicObject)
function Enemy.create()
	local self = DynamicObject.create();
	setmetatable(self, Enemy)
	self:setImage("enemy.png");
	self:setSpeedIncrement(ENEMY_INC_SPEED)
	return self
end

function Enemy:reset()
	self:setPosition(ENEMY_STARTX, ENEMY_STARTY)
	self:setSpeed(ENEMY_START_SPEED)
end

function Enemy:setPlayer(_player)
	self.player = _player;
end

function Enemy:update(dt)
	if self.player.dead == false then
		if(self.x < self.player.x) then
			goRight=1
		else
			goRight=-1
		end
		if(self.y < self.player.y) then
			goDown=1
		else
			goDown=-1
		end
	else
	    goRight=3
		goDown=0
	end
	self:move(math.floor(math.random()*11)-5+goRight*self.speed,
	           math.floor(math.random()*11)-5+ goDown*self.speed)
	GameObject.update(self, dt)
end