require("game_object")

hero_startx = 0
hero_starty = 0
enemy_startx = 300
enemy_starty = 400

window_width = 1000
window_height = 800


hero_startSpeed = 3
hero_incrementSpeed = 0.1
enemy_startSpeed = 2
enemy_incrementSpeed = 0.5



tpPowerCooldown = 100;
tpPower = tpPowerCooldown;
food = {}
foodlink = {}
food_score_cost = 100

particle_radius = 320
particle_lifetimeMin = 0.4
particle_lifetimeMax = 1.5
particle_size = {0.3,0.1,0.1}
numParticles = 10000
frequenceParticles = 1000

gui_indent = 30

num_food = 48+43;

dead = false;

--1 6 9  13 18 20  25        33  38 43 46
--2      14    21  26 30  32 34  39
--3 710  15 19 22  27   31   35  40 44 47
--4  11  16    23  28        36  41 
--5 812  17    24  29        37  42 45 48

--49 54 56  61       69 70 75 78 81 86 88
--50    57   62     68  71       82    89
--51    58    63   67   72 76 79 83 87
--52    59     64 66    73       84    90
--53 55 60      65      74 77 80 85    91

gameoverx = {1,1,1,1,1,2,2,2,3,3,3,3,5,5,5,5,5,6,6,7,7,7,7,7,9,9,9,9,9,10,11,12,13,13,13,13,13,15,15,15,15,15,16,16,16,17,17,17,
			1,1,1,1,1,2,2,3,3,3,3,3, 5,5,5,6,7,8,9,9,9,11,11,11,11,11,12,12,12,13,13,13,15,15,15,15,15,16,16,17,17,17,17};
gameovery ={1,2,3,4,5,1,3,5,1,3,4,5, 1,2,3,4,5,1,3,1,2,3,4,5,1,2,3,4,5,2,3,2,1,2,3,4,5,1,2,3,4,5,1,3,5,1,3,5,
			7,8,9,10,11,7,11,7,8,9,10,11, 7,8,9,10,11,10,9,8,7,7,8,9,10,11,7,9,11,7,9,11,7,8,9,10,11,7,9,7,8,10,11};
gameoverlink =  {2,3,4,5,8,1,10,12,6,11,12,11,
				14,15,19,15,16,13,22,18,20,21,22,23,
				30,25,26,27,28,31,32,33,34,35,36,37,36,
				39,40,41,42,41,38,40,42,43,44,45,
				
				50,51,52,53,55,49,60,54,56,57,58,59,
				62,63,64,65,66,67,68,69,68,
				71,72,73,74,73,70,72,74,75,76,77,
				86,81,82,83,84,88,83,89,87,87,90};
			
gameovernum = num_food;

score = 0;
--music
samples = 0
sampleRate=0
volume=0
analysisDepth = 50
channels = 0

player = GameObject.create()
enemy = GameObject.create()

function startGame()
	
	player:setPosition(hero_startx, hero_starty)
	enemy:setPosition(enemy_startx, enemy_starty)
	
	hero_speed = hero_startSpeed;
	enemy_speed = enemy_startSpeed;
	
	for i=1,num_food do
		food[i]:setPosition(math.random(love.window.getWidth()),math.random(love.window.getHeight()))
	end
	
	tpPower = tpPowerCooldown;
end

function love.load()
	data = love.sound.newSoundData('music.mp3');
	music = love.audio.newSource('music.mp3');
	samples = data:getSampleCount()
	sampleRate = data:getSampleRate()
	channels = data:getChannels()
	music:play();
	
	love.window.setMode(window_width,window_height,{resizable = true});
	love.window.setTitle("I LOVE teleporting");
	
	player:setImage("hero.png")
	player:setParticleSystem(numParticles,frequenceParticles, particle_lifetimeMin, particle_lifetimeMax, particle_radius, 0);
	
	enemy:setImage("enemy.png")
	enemy:setParticleSystem(numParticles,frequenceParticles, particle_lifetimeMin, particle_lifetimeMax, particle_radius, 0);
	
	for i=1,num_food do
		food[i] = GameObject.create()
		food[i]:setImage("food.png")
		food[i]:setParticleSystem(numParticles,frequenceParticles, particle_lifetimeMin, particle_lifetimeMax, particle_radius, 0);
	end
	
	startGame();
end

function love.draw()
	love.graphics.setColor(255,255,255);
	enemy:render()
	
	if(dead == false) then
		player:render()
	end
	
	for i=1,num_food do
		food[i]:render()
	end
	allowed_rass = 70;
	
	if dead then
		for i=1,num_food do
			love.graphics.line(food[i].x+food[i].width/2,food[i].y+food[i].height/2,food[gameoverlink[i]].x+food[gameoverlink[i]].width/2,food[gameoverlink[i]].y+food[gameoverlink[i]].height/2);
		end
	end
	
	love.graphics.setColor(0,66,66);
	love.graphics.rectangle("fill",gui_indent,gui_indent,160,40);
	love.graphics.rectangle("fill",love.window.getWidth()-gui_indent-160,gui_indent,160,40);
	love.graphics.setColor(0,255,0);
	love.graphics.rectangle("fill",gui_indent+30,gui_indent+10,tpPower/tpPowerCooldown*100,20);
	love.graphics.setColor(255,255,255);
	love.graphics.print("Score:" .. score, love.window.getWidth()-gui_indent-160+45,gui_indent+13,0,1,1)
end

function love.mousepressed(x, y, button)
   if button == 'l' and dead == false and tpPower == tpPowerCooldown then
      player:setPosition(x, y)
	  tpPower = 0
   end
end

function love.update(dt)
	--music
	startSample = music:tell("seconds")*sampleRate*channels;
	min_=1;
	max_=-1;
	prev=0;
	volume2=0;
	if (startSample-analysisDepth <= 0) or (startSample+analysisDepth >= samples) then
		volume=0;
	else
		for i=startSample-analysisDepth,startSample+analysisDepth do
			tmp = data:getSample(i);
			volume2 = volume2 + math.abs(tmp-prev);
			prev=tmp;
			if tmp > max_ then
				max_ = tmp
			end
			if tmp < min_ then
				min_ = tmp
			end
		end
		volume = max_-min_;
		volume2 = volume2/analysisDepth;
	end
	
	player.particle:setEmissionRate(math.floor(frequenceParticles*volume2))
	enemy.particle:setEmissionRate(math.floor(frequenceParticles*volume2))
	player.particle:setSizes(unpack({volume2/4,volume2/2,volume2/2}));
	enemy.particle:setSizes(unpack({volume2/4,volume2/2,volume2/2}));
	for i=1,num_food do
		food[i].particle:setEmissionRate(math.floor(frequenceParticles*volume2))
		food[i].particle:setSizes(unpack({volume2/4,volume2/2,volume2/2}));
	end
	
	--enemy
	if dead == false then
		if(enemy.x < player.x) then
			goRight=1
		else
			goRight=-1
		end
		if(enemy.y < player.y) then
			goDown=1
		else
			goDown=-1
		end
	else
	    goRight=3
		goDown=0
	end
	enemy:move(math.floor(math.random()*11)-5+goRight*enemy_speed, math.floor(math.random()*11)-5+ goDown*enemy_speed)
	--me
	if (dead == false) then
		if(tpPower < tpPowerCooldown) then
			tpPower = tpPower+1;
		end
		if(love.keyboard.isDown("left")) then
			player:moveX(- hero_speed);
		end
		if(love.keyboard.isDown("right")) then
			player:moveX(hero_speed);
		end
		if(love.keyboard.isDown("up")) then
			player:moveY(- hero_speed);
		end
		if(love.keyboard.isDown("down")) then
			player:moveY(hero_speed);
		end
		
		player:update(dt);
		enemy:update(dt);
	end
	
	if(love.keyboard.isDown("r")) then
		dead = false;
		startGame();
	end
	
	--food
	for i=1,num_food do
		food[i]:update(dt);
		if (enemy:collide(food[i])) then
			enemy_speed = enemy_speed+enemy_incrementSpeed;
			food[i]:setPosition(math.random(love.window.getWidth()), math.random(love.window.getHeight()))
		end
		
		if dead == false then
		
			if (player:collide(food[i])) then
				score = score + food_score_cost;
				hero_speed = hero_speed+hero_incrementSpeed;
				food[i]:setPosition(math.random(love.window.getWidth()), math.random(love.window.getHeight()))
			end
		
		end
		
		if dead == true and gameovernum>=i then
			food[i]:move((math.random()-0.5)*volume2*30 + ((gameoverx[i]+1)*50*love.window.getWidth()/1000 - food[i].x)/6,(math.random()-0.5)*volume2*30 +((gameovery[i]+1)*50*love.window.getHeight()/800 - food[i].y)/6)
			if(math.random()<0.0002) then
				nextpt = math.floor(math.random(num_food));
				rx = food[i].x
				ry = food[i].y
				food[i]:setPosition(food[nextpt].x,food[nextpt].y);
				food[nextpt]:setPosition(rx, ry);
			end
		end
	end
	--lose condition
	if (player:collide(enemy)) then
		dead = true;
	end
	
end

function rectsIntersect(x1, y1, width1, height1, x2, y2, width2, height2)
	if ((((x2 >= x1) and (x2 < x1+width1)) or ((x1 >= x2) and (x1 < x2+width2))) and (((y2 >= y1) and (y2 < y1+height1)) or ((y1 >= y2) and (y1 < y2+height2)))) then
		return true
	end
	return false
end

