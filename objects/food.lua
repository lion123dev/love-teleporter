require("objects.game_object")
Food = { }
Food.__index = Food
setmetatable(Food, GameObject)
function Food.create()
	local self = GameObject.create();
	setmetatable(self, Food)
	self:setImage("food.png");
	return self
end

function Food:reposition()
	self:setPosition(math.random(love.window.getWidth()),math.random(love.window.getHeight()));
end