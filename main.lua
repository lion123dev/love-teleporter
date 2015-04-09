require("objects.game_object")
require("objects.food")
require("objects.player");
require("objects.enemy");

--constants
window_width = 1000
window_height = 800



--particles
particle_radius = 320
particle_lifetimeMin = 0.4
particle_lifetimeMax = 1.5
particle_size = {0.3,0.1,0.1}
numParticles = 10000
frequenceParticles = 1000

gui_indent = 30
score = 0;
num_food = 91;

--food

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

food = {}
foodlink = {}
food_score_cost = 100
gameoverx = {1,1,1,1,1,2,2,2,3,3,3,3,5,5,5,5,5,6,6,7,7,7,7,7,9,9,9,9,9,10,11,12,13,13,13,13,13,15,15,15,15,15,16,16,16,17,17,17,1,1,1,1,1,2,2,3,3,3,3,3, 5,5,5,6,7,8,9,9,9,11,11,11,11,11,12,12,12,13,13,13,15,15,15,15,15,16,16,17,17,17,17};
gameovery ={1,2,3,4,5,1,3,5,1,3,4,5, 1,2,3,4,5,1,3,1,2,3,4,5,1,2,3,4,5,2,3,2,1,2,3,4,5,1,2,3,4,5,1,3,5,1,3,5,7,8,9,10,11,7,11,7,8,9,10,11, 7,8,9,10,11,10,9,8,7,7,8,9,10,11,7,9,11,7,9,11,7,8,9,10,11,7,9,7,8,10,11};
gameoverlink =  {2,3,4,5,8,1,10,12,6,11,12,11,14,15,19,15,16,13,22,18,20,21,22,23,30,25,26,27,28,31,32,33,34,35,36,37,36,39,40,41,42,41,38,40,42,43,44,45,50,51,52,53,55,49,60,54,56,57,58,59,62,63,64,65,66,67,68,69,68,71,72,73,74,73,70,72,74,75,76,77,86,81,82,83,84,88,83,89,87,87,90};
gameovernum = num_food;

--music
samples = 0
sampleRate=0
volume=0
analysisDepth = 440
channels = 0
duration = 0

function startGame()
	player:reset()
	enemy:reset()
	for i=1,num_food do
		food[i]:reposition()
	end
end

function love.load()
	--load music
	data = love.sound.newSoundData('music.mp3');
	music = love.audio.newSource('music.mp3');
	samples = data:getSampleCount()
	sampleRate = data:getSampleRate()
	channels = data:getChannels()
	duration = data:getDuration()
	music:play();
	
	--load window
	love.window.setMode(window_width,window_height,{resizable = true});
	love.window.setTitle("I LOVE teleporting");
	
	--load gameObjects
	player = Player.create()
	enemy = Enemy.create()
	enemy:setPlayer(player)
	player:setParticleSystem(numParticles,frequenceParticles, particle_lifetimeMin, particle_lifetimeMax, particle_radius, 0);
	enemy:setParticleSystem(numParticles,frequenceParticles, particle_lifetimeMin, particle_lifetimeMax, particle_radius, 0);
	for i=1,num_food do
		food[i] = Food.create()
		food[i]:setParticleSystem(numParticles,frequenceParticles, particle_lifetimeMin, particle_lifetimeMax, particle_radius, 0);
	end
	
	startGame();
end

function love.draw()
	love.graphics.setColor(255,255,255);
	
	--render gameObjects
	enemy:render()
	if(player.dead == false) then
		player:render()
	end
	for i=1,num_food do
		food[i]:render()
	end
	
	--gameover links
	if player.dead then
		for i=1,num_food do
			love.graphics.line(food[i].x+food[i].width/2,food[i].y+food[i].height/2,food[gameoverlink[i]].x+food[gameoverlink[i]].width/2,food[gameoverlink[i]].y+food[gameoverlink[i]].height/2);
		end
	end
	
	--gui
	love.graphics.setColor(0,66,66);
	love.graphics.rectangle("fill",gui_indent,gui_indent,160,40);
	love.graphics.rectangle("fill",love.window.getWidth()-gui_indent-160,gui_indent,160,40);
	love.graphics.setColor(0,255,0);
	love.graphics.rectangle("fill",gui_indent+30,gui_indent+10,player.tpPower/TP_POWER_COOLDOWN*100,20);
	love.graphics.setColor(255,255,255);
	love.graphics.print("Score:" .. score, love.window.getWidth()-gui_indent-160+45,gui_indent+13,0,1,1)
end

function love.mousepressed(x, y, button)
   if button == 'r' then
	  music:seek(x/love.window.getWidth()*duration,"seconds")
   end
   if button == 'l' and player:canTeleport() then
      player:teleport(x,y)
   end
end

function love.update(dt)
	--update music
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
	
	--update gameObjects
	enemy:update(dt)
	player:update(dt)
	for i=1,num_food do
		food[i]:update(dt);
		if (enemy:collide(food[i])) then
			enemy:speedUp()
			food[i]:reposition()
		end
		
		if player.dead == false then
			if (player:collide(food[i])) then
				score = score + food_score_cost;
				player:speedUp()
				food[i]:reposition()
			end
		
		end
		
		if player.dead and gameovernum>=i then
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
	
	--lose conditions
	if(love.keyboard.isDown("r")) then
		player:kill()
		startGame();
	end
	
	if (player:collide(enemy)) then
		player:kill()
	end
	
end