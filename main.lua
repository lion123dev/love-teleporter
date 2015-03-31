hero_startx = 0
hero_starty = 0
enemy_startx = 300
enemy_starty = 400

hero_startSpeed = 3
enemy_startSpeed = 2

numParticles = 100000
frequenceParticles = 1000;

tpPower = 100;
food = {}
foodx = {}
foody = {}
foodEmitters = {}


num_food = 48+43;

dead = false;


gameoverx = {1,1,1,1,1,2,2,2,3,3,3,3,5,5,5,5,5,6,6,7,7,7,7,7,9,9,9,9,9,10,11,12,13,13,13,13,13,15,15,15,15,15,16,16,16,17,17,17,
			1,1,1,1,1,2,2,3,3,3,3,3,5,5,5,6,7,8,9,9,9,11,11,11,11,11,12,12,12,13,13,13,15,15,15,15,15,16,16,17,17,17,17};
gameovery = {1,2,3,4,5,1,3,5,1,3,4,5,1,2,3,4,5,1,3,1,2,3,4,5,1,2,3,4,5,2,3,2,1,2,3,4,5,1,2,3,4,5,1,3,5,1,3,5,
			7,8,9,10,11,7,11,7,8,9,10,11,7,8,9,10,11,10,9,8,7,7,8,9,10,11,7,9,11,7,9,11,7,8,9,10,11,7,9,7,8,10,11};

gameovernum = num_food;

score = 0;

function startGame()
	herox=hero_startx
	heroy=hero_starty

	enemyx=enemy_startx
	enemyy=enemy_starty
	
	hero_speed = hero_startSpeed;
	enemy_speed = enemy_startSpeed;
	
	for i=1,num_food do
		foodx[i] = math.floor(math.random(1000));
		foody[i] = math.floor(math.random(800));
	end
end

function love.load()
	love.window.setMode(1000,800);
	love.window.setTitle("I LOVE teleporting");
	hero = love.graphics.newImage("hero.png")
	enemy = love.graphics.newImage("enemy.png")
	
	myP = love.graphics.newParticleSystem(love.graphics.newImage("hero.png"), numParticles)
	nmeP = love.graphics.newParticleSystem(love.graphics.newImage("enemy.png"), numParticles)
	
	myP:setParticleLifetime(0.4, 1.5);
    myP:setEmissionRate(frequenceParticles);
	myP:setLinearAcceleration(-320, -320, 320, 320);
	myP:setSizeVariation(0);
	myP:setSizes(0.3,0.1,0.1)
	
	nmeP:setParticleLifetime(0.4, 1.5);
    nmeP:setEmissionRate(frequenceParticles);
	nmeP:setLinearAcceleration(-320, -320, 320, 320);
	nmeP:setSizeVariation(0);
	nmeP:setSizes(0.3,0.1,0.1)
	
	for i=1,num_food do
		food[i] = love.graphics.newImage("food.png")
		
		foodEmitter = love.graphics.newParticleSystem(love.graphics.newImage("food.png"), numParticles)
		foodEmitter:setParticleLifetime(0.4, 1.5);
		foodEmitter:setEmissionRate(frequenceParticles);
		foodEmitter:setLinearAcceleration(-320, -320, 320, 320);
		foodEmitter:setSizeVariation(0);
		foodEmitter:setSizes(0.3,0.1,0.1)
		
		foodEmitters[i] = foodEmitter
	end
	
	startGame();
end

function love.draw()
	love.graphics.setColor(255,255,255);
	love.graphics.draw(nmeP, enemyx+25, enemyy+25)
	love.graphics.draw(enemy, enemyx, enemyy)	
	
	if(dead == false) then
		love.graphics.draw(myP, herox+25, heroy+25)
		love.graphics.draw(hero, herox, heroy)
	end
	
	for i=1,num_food do
		love.graphics.draw(foodEmitters[i], foodx[i]+12.5, foody[i]+12.5)
		love.graphics.draw(food[i], foodx[i], foody[i])
	end
	
	love.graphics.setColor(0,66,66);
	love.graphics.rectangle("fill",30,30,160,40);
	love.graphics.rectangle("fill",love.window.getWidth()-30-160,30,160,40);
	love.graphics.setColor(0,255,0);
	love.graphics.rectangle("fill",60,40,tpPower,20);
	love.graphics.setColor(255,255,255);
	love.graphics.print("Score:" .. score, love.window.getWidth()-30-160+45,30+13,0,1,1)
end

function love.mousepressed(x, y, button)
   if button == 'l' and dead == false and tpPower == 100 then
      herox = x
      heroy = y
	  tpPower = 0
   end
end

function love.update(dt)
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
		if(tpPower < 100) then
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
		diffX = enemyx-foodx[i]+25;
		diffY = enemyy-foody[i]+25;
		
		if (diffX<30) and (diffX>0) and (diffY<30) and (diffY>0) then
			enemy_speed = enemy_speed+0.5;
			foodx[i] = math.floor(math.random(1000));
			foody[i] = math.floor(math.random(800));
		end
		
		if dead == false then
		
			diffX = herox-foodx[i]+25;
			diffY = heroy-foody[i]+25;
			
			if (diffX<30) and (diffX>0) and (diffY<30) and (diffY>0) then
				score = score + 100;
				hero_speed = hero_speed+0.1;
				foodx[i] = math.floor(math.random(1000));
				foody[i] = math.floor(math.random(800));
			end
		
		end
		
		if dead == true and gameovernum>=i then
			foodx[i] = foodx[i] + ((gameoverx[i]+1)*50 - foodx[i])/6;
			foody[i] = foody[i] + ((gameovery[i]+1)*50 - foody[i])/6;
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
	diffX = enemyx - herox;
	diffY = enemyy - heroy;
	if (diffX<50) and (diffX>0) and (diffY<50) and (diffY>0) then
		dead = true;
	end
	
	
end