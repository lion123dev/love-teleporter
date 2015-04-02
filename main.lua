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
foodx = {}
foody = {}
foodEmitters = {}
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


gameoverx = {1,1,1,1,1,2,2,2,3,3,3,3,5,5,5,5,5,6,6,7,7,7,7,7,9,9,9,9,9,10,11,12,13,13,13,13,13,15,15,15,15,15,16,16,16,17,17,17,
			1,1,1,1,1,2,2,3,3,3,3,3,5,5,5,6,7,8,9,9,9,11,11,11,11,11,12,12,12,13,13,13,15,15,15,15,15,16,16,17,17,17,17};
gameovery = {1,2,3,4,5,1,3,5,1,3,4,5,1,2,3,4,5,1,3,1,2,3,4,5,1,2,3,4,5,2,3,2,1,2,3,4,5,1,2,3,4,5,1,3,5,1,3,5,
			7,8,9,10,11,7,11,7,8,9,10,11,7,8,9,10,11,10,9,8,7,7,8,9,10,11,7,9,11,7,9,11,7,8,9,10,11,7,9,7,8,10,11};

gameovernum = num_food;

score = 0;

--music
samples = 0
sampleRate=0
volume=0
analysisDepth = 50
channels = 0

function startGame()
	herox=hero_startx
	heroy=hero_starty

	enemyx=enemy_startx
	enemyy=enemy_starty
	
	hero_speed = hero_startSpeed;
	enemy_speed = enemy_startSpeed;
	
	for i=1,num_food do
		foodx[i] = math.floor(math.random(love.window.getWidth()));
		foody[i] = math.floor(math.random(love.window.getHeight()));
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
	hero = love.graphics.newImage("hero.png")
	hero_width = hero:getWidth()
	hero_height = hero:getHeight()
	enemy = love.graphics.newImage("enemy.png")
	enemy_width = hero:getWidth()
	enemy_height = hero:getHeight()
	
	myP = love.graphics.newParticleSystem(love.graphics.newImage("hero.png"), numParticles)
	nmeP = love.graphics.newParticleSystem(love.graphics.newImage("enemy.png"), numParticles)
	
	myP:setParticleLifetime(particle_lifetimeMin, particle_lifetimeMax);
    myP:setEmissionRate(frequenceParticles);
	myP:setLinearAcceleration(-particle_radius, -particle_radius, particle_radius, particle_radius);
	myP:setSizeVariation(0);
	myP:setSizes(unpack(particle_size))
	
	nmeP:setParticleLifetime(particle_lifetimeMin, particle_lifetimeMax);
    nmeP:setEmissionRate(frequenceParticles);
	nmeP:setLinearAcceleration(-particle_radius, -particle_radius, particle_radius, particle_radius);
	nmeP:setSizeVariation(0);
	nmeP:setSizes(unpack(particle_size))
	food_img = love.graphics.newImage("food.png")
	food_width = food_img:getWidth()
	food_height = food_img:getHeight()
	for i=1,num_food do
		foodEmitter = love.graphics.newParticleSystem(love.graphics.newImage("food.png"), numParticles)
		foodEmitter:setParticleLifetime(particle_lifetimeMin, particle_lifetimeMax);
		foodEmitter:setEmissionRate(frequenceParticles);
		foodEmitter:setLinearAcceleration(-particle_radius, -particle_radius, particle_radius, particle_radius);
		foodEmitter:setSizeVariation(0);
		foodEmitter:setSizes(unpack(particle_size))
		
		foodEmitters[i] = foodEmitter
	end
	
	startGame();
end

function love.draw()
	love.graphics.setColor(255,255,255);
	love.graphics.draw(nmeP, enemyx+enemy_width/2, enemyy+enemy_height/2)
	love.graphics.draw(enemy, enemyx, enemyy)	
	
	if(dead == false) then
		love.graphics.draw(myP, herox+hero_width/2, heroy+hero_width/2)
		love.graphics.draw(hero, herox, heroy)
	end
	
	for i=1,num_food do
		love.graphics.draw(foodEmitters[i], foodx[i]+food_width/2, foody[i]+food_height/2)
		love.graphics.draw(food_img, foodx[i], foody[i])
	end
	allowed_rass = 70;
	if dead then
		for i=1,num_food do
			index=1;
			variants = {};
			for try=1,num_food do
				if not(try == i) then
					rass = math.sqrt((foodx[try]-foodx[i])^2+(foody[try]-foody[i])^2)
					if rass < allowed_rass then
						table.insert(variants, try);
					end;
				end;
			end
			index = variants[math.random(#variants)];
			if not(table.getn(variants) == 0) then
				love.graphics.line(foodx[i]+food_width/2,foody[i]+food_height/2,foodx[index]+food_width/2,foody[index]+food_height/2);
			end
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
      herox = x
      heroy = y
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
	
	myP:setEmissionRate(math.floor(frequenceParticles*volume2))
	nmeP:setEmissionRate(math.floor(frequenceParticles*volume2))
	myP:setSizes(unpack({volume2/4,volume2/2,volume2/2}));
	nmeP:setSizes(unpack({volume2/4,volume2/2,volume2/2}));
	for i=1,num_food do
		foodEmitters[i]:setEmissionRate(math.floor(frequenceParticles*volume2))
		foodEmitters[i]:setSizes(unpack({volume2/4,volume2/2,volume2/2}));
	end
	
	--enemy
	if dead == false then
		if(enemyx < herox) then
			goRight=1
		else
			goRight=-1
		end
		if(enemyy < heroy) then
			goDown=1
		else
			goDown=-1
		end
	else
	    goRight=3
		goDown=0
	end
	enemyx = enemyx + (math.floor(math.random()*11)-5+goRight*enemy_speed)
	enemyy = enemyy + (math.floor(math.random()*11)-5+ goDown*enemy_speed)
	
	--me
	if (dead == false) then
		if(tpPower < tpPowerCooldown) then
			tpPower = tpPower+1;
		end
		if(love.keyboard.isDown("left")) then
			herox = herox - hero_speed;
		end
		if(love.keyboard.isDown("right")) then
			herox = herox + hero_speed;
		end
		if(love.keyboard.isDown("up")) then
			heroy = heroy - hero_speed;
		end
		if(love.keyboard.isDown("down")) then
			heroy = heroy + hero_speed;
		end
		
		myP:update(dt);
		nmeP:update(dt);
	end
	
	if(love.keyboard.isDown("r")) then
		dead = false;
		startGame();
	end
	
	--food
	for i=1,num_food do
		foodEmitters[i]:update(dt);
		if (rectsIntersect(enemyx,enemyy,enemy_width,enemy_height,foodx[i],foody[i],food_width,food_height)) then
			enemy_speed = enemy_speed+enemy_incrementSpeed;
			foodx[i] = math.floor(math.random(love.window.getWidth()));
			foody[i] = math.floor(math.random(love.window.getHeight()));
		end
		
		if dead == false then
		
			if (rectsIntersect(herox,heroy,hero_width,hero_height,foodx[i],foody[i],food_width,food_height)) then
				score = score + food_score_cost;
				hero_speed = hero_speed+hero_incrementSpeed;
				foodx[i] = math.floor(math.random(love.window.getWidth()));
				foody[i] = math.floor(math.random(love.window.getHeight()));
			end
		
		end
		
		if dead == true and gameovernum>=i then
			foodx[i] = foodx[i] + (math.random()-0.5)*volume2*30 + ((gameoverx[i]+1)*50*love.window.getWidth()/1000 - foodx[i])/6;
			foody[i] = foody[i] + (math.random()-0.5)*volume2*30 +((gameovery[i]+1)*50*love.window.getHeight()/800 - foody[i])/6;
			if(math.random()<0.0002) then
				nextpt = math.floor(math.random(num_food));
				
				rx = foodx[i]
				ry = foody[i]
				
				foodx[i] = foodx[nextpt];
				foody[i] = foody[nextpt];
				
				foodx[nextpt] = rx;
				foody[nextpt] = ry;
			end
		end
	end
	--lose condition
	if (rectsIntersect(herox,heroy,hero_width,hero_height,enemyx,enemyy,enemy_width,enemy_height)) then
		dead = true;
	end
	
end

function rectsIntersect(x1, y1, width1, height1, x2, y2, width2, height2)
	if ((((x2 >= x1) and (x2 < x1+width1)) or ((x1 >= x2) and (x1 < x2+width2))) and (((y2 >= y1) and (y2 < y1+height1)) or ((y1 >= y2) and (y1 < y2+height2)))) then
		return true
	end
	return false
end