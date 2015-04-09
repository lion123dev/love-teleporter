require("objects.game_object")
DynamicObject = { }
DynamicObject.__index = DynamicObject
setmetatable(DynamicObject, GameObject)
function DynamicObject.create()
	local self = GameObject.create();
	setmetatable(self, DynamicObject)
	self.speed = 0
	self.speedIncrement = 0
	return self
end

function DynamicObject:setSpeed(newSpeed)
	self.speed = newSpeed
end

function DynamicObject:setSpeedIncrement(newSpeedInc)
	self.speedIncrement = newSpeedInc
end

function DynamicObject:speedUp()
	self.speed = self.speed + self.speedIncrement
end