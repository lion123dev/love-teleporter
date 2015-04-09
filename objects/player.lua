require("objects.dynamic_object")
PLAYER_START_SPEED = 3
PLAYER_INC_SPEED = 0.1
PLAYER_STARTX = 0
PLAYER_STARTY = 0
TP_POWER_COOLDOWN = 100;
Player = { }
Player.__index = Player
setmetatable(Player, DynamicObject)
function Player.create()
	local self = DynamicObject.create();
	setmetatable(self, Player)
	self:setImage("hero.png");
	self:setSpeedIncrement(PLAYER_INC_SPEED)
	return self
end

function Player:reset()
	self:setPosition(PLAYER_STARTX, PLAYER_STARTY)
	self:setSpeed(PLAYER_START_SPEED)
	self.dead = false
	self.tpPower = TP_POWER_COOLDOWN
end

function Player:canTeleport()
	return (self.dead == false and self.tpPower == TP_POWER_COOLDOWN)
end

function Player:teleport(x,y)
	self.tpPower=0
	self:setPosition(x,y)
end

function Player:update(dt)
	if (self.dead == false) then
		if(self.tpPower < TP_POWER_COOLDOWN) then
			self.tpPower = self.tpPower+1;
		end
		if(love.keyboard.isDown("left")) then
			self:moveX(-self.speed);
		end
		if(love.keyboard.isDown("right")) then
			self:moveX(self.speed);
		end
		if(love.keyboard.isDown("up")) then
			self:moveY(-self.speed);
		end
		if(love.keyboard.isDown("down")) then
			self:moveY(self.speed);
		end
	end
	GameObject.update(self, dt)
end

function Player:kill()
	self.dead = true
end