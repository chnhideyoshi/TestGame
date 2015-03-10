MapLayer = class("MapLayer",function()
    return cc.Layer:create();

end)

function MapLayer.create()
	local layer=MapLayer.new()
	layer:init()
	return layer;
end

function MapLayer:ctor()
	
end

function MapLayer:init()
	self:InitDefaultParms();
	self:InitComponents();
	self:InitEventHandlers();
	self:InitPlayer();
	self:InitMonsters();
	self:InitSkills();
	self:InitUpdate();
	return true;
end

function MapLayer:InitDefaultParms()
	self.movementYBound0 = 80;
	self.movementYBound1 = 323;
	self.movementXOffsetThreshold = 200;
	self.monsters={};
	self.monstersflag={};
end

function MapLayer:InitComponents()
	print("InitComponents")
	self.rootNode=cc.CSLoader:createNode("LY_Map.csb");
	self:addChild(self.rootNode);
	self.mapPanel=self.rootNode:getChildByTag(102);
	local nav=NavigatorLayer.create();
	nav:setGlobalZOrder(1);
	self:addChild(nav);
	self.navigator=nav;
	
	print("~InitComponents")
end

function MapLayer:InitEventHandlers()
	local function onKeyPressed_map(keyCode, event)
		--print(keyCode);
		if keyCode==KEY_SPACE then
			--self:Test();
		end
		if keyCode==KEY_ESC then
			if self:getChildByName("LY_ESCMenu") == nil then
				cc.Director:getInstance():pause();
				local layer = EscMenuLayer.create();
				layer:setAnchorPoint(0, 0);
				layer:setPosition(0,0);
				layer:setName("LY_ESCMenu");
				layer:setGlobalZOrder(91);
				layer.Return = function()
					cc.Director:getInstance():resume();
				end
				layer.Exit=function()
					cc.Director:getInstance():endToLua();
				end
				self:addChild(layer);
				
			else
				self:removeChild(self:getChildByName("LY_ESCMenu"));
				cc.Director:getInstance():resume();
			end
		end
	end
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed_map, cc.Handler.EVENT_KEYBOARD_PRESSED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end

function MapLayer:InitPlayer()
	print("InitPlayer")
	self.player=PlayerNode.create();
	self.player:setAnchorPoint(0.5,0.35);
	self.player:setPosition(400, 200);
	self.mapPanel:addChild(self.player);
	self.player:SetOnceState(O_STATE_WELOME);
	self.player.MaxHp=10000;
	self.player.MaxMp=1000;
	self.player.Hp=self.player.MaxHp;
	self.player.Mp=0;
	self.player:setGlobalZOrder(10);	
	
	self.navigator:SetHpValue(self.player.Hp);
	self.navigator:SetMpValue(0);
	self.navigator:SetHpPercentage(self.player.Hp * 100 / self.player.MaxHp);
	self.navigator:SetMpPercentage(0);
	self.player.MpChanged=function(sender)
		self.navigator:SetMpValue(sender.Mp);
		self.navigator:SetMpPercentage(sender.Mp*100/sender.MaxMp);
	end
	self.player.HpChanged = function(sender)
		self.navigator:SetHpValue(sender.Hp);
		self.navigator:SetHpPercentage(sender.Hp * 100 / sender.MaxHp);
		if (sender.Hp == 0) then
			StopMusic();
			sender:SetOnceState(O_STATE_DEAD);
		end
	end
	self.player.ATKReadyChecked=function(node,newstate)
		local ret=self.skManager:GetChecked(newstate);
		if not ret then
			node:ShowMessage("MP NOT READY!");
		end
		return ret;
	end
	self.player.OnceStateChanged=function(sender,newstate)
		local ret=false;
		if newstate==O_STATE_ATK1 then
			ret=self.skManager:PlayerExecuteSkill(PLAYER_SKILL_ATK1,self.mapPanel);
		end
		if newstate==O_STATE_ATK2 then
			ret=self.skManager:PlayerExecuteSkill(PLAYER_SKILL_ATK2,self.mapPanel);
		end
		if newstate==O_STATE_ATK3 then
			ret=self.skManager:PlayerExecuteSkill(PLAYER_SKILL_ATK3,self.mapPanel);
		end
		if newstate==O_STATE_ATK4 then
			ret=self.skManager:PlayerExecuteSkill(PLAYER_SKILL_ATK4,self.mapPanel);
		end
		if newstate==O_STATE_ATK5 then
			ret=self.skManager:PlayerExecuteSkill(PLAYER_SKILL_ATK5,self.mapPanel);
		end
		if newstate==O_STATE_ATK6 then
			ret=self.skManager:PlayerExecuteSkill(PLAYER_SKILL_ATK6,self.mapPanel);
		end
		if newstate==O_STATE_ATK7 then
			ret=self.skManager:PlayerExecuteSkill(PLAYER_SKILL_ATK7,self.mapPanel);
		end
	end
	self.player.End=function(sender,endtype)
		if endtype==0 then
			self.player:setVisible(false);
			self:Lose();
		elseif endtype==1 then
			self.player:setVisible(false);
			self:Win();
		else
			prints("WelcomeEnd")
		end
	end
	
	print("~InitPlayer")
end

function MapLayer:InitMonsters()
	local count=7;
	self.monsters={};
	local sz=self.mapPanel:getContentSize();
	local vec=GetRandPointsInRect(1,self.movementYBound0,sz.width-1,self.movementYBound1-100,count)
	for i=1,count do
		local mtype=(i-1)%3;
		if i==count then
			mtype=4;
		end
		local mon = self:CreateMonster(mtype);
		mon:setPosition(vec[i]);
		if mtype==4 then
			mon:setPosition(2600,200);
			mon.enableTargetSeeking=false;
		end
		mon.id=i;
		mon:setGlobalZOrder(5);
		if mtype==3 then
			mon:setPosition(vec[i].x,vec[i].y+400);
			mon:SetMovementRange(0, self.mapPanel:getContentSize().width - 5, 0,self.mapPanel:getContentSize().height );
		else
			mon:SetMovementRange(0, self.mapPanel:getContentSize().width - 5, self.movementYBound0, self.movementYBound1);
		end
		self.mapPanel:addChild(mon);
		table.insert(self.monsters,mon);
		table.insert(self.monstersflag,true);
	end
end


function MapLayer:CreateMonster(mtype)
	local monster=nil;
	if mtype==0 then
		monster=MonsterNode.create_1();
	elseif mtype==1 then
		monster=MonsterNode.create_2();
	elseif mtype==2 then
		monster=MonsterNode.create_3();
	else
		monster=MonsterNode.create_4();
	end
	monster:setAnchorPoint(0.5, 0.5);
	monster.enableTargetSeeking=true;
	monster.target=self.player;
	monster.Attack=function(mon)
		self.skManager:MonsterExecuteSkill(mon, MONSTER_SKILL_1, self.mapPanel);
	end
	monster.Dead=function(mon)
		mon:removeFromParent();
		local index=-1;
		for i = 1,#self.monsters do
			if (mon == self.monsters[i]) then
				index=i;
				break;
			end
		end
		table.remove(self.monsters,index);
		if #self.monsters ==1 then
			self.monsters[1].enableTargetSeeking=true;
			self.monsters[1].maxHp=20000
			self.monsters[1].curHp=20000
		end
		if #self.monsters ==0 then
			StopMusic();
			self.player:SetOnceState(O_STATE_WIN);
		end
	end
	
	return monster;
end

function MapLayer:InitSkills()
	self.skManager=SkillManager.create();
	self.skManager.player=self.player;
	self.skManager.monsters=self.monsters;
end

function MapLayer:InitUpdate()
	self:scheduleUpdateWithPriorityLua(function(dt)
		local inAni = self.player.curOState ~= O_STATE_NONE;
		local inMove = not (self.player.curDirectionX==0 and self.player.curDirectionY==0)
		if not inAni then
			if inMove then
				self:ManagePlayerMovement();
			end
		end
		
    end,0)
end

function MapLayer:ManagePlayerMovement()
	local movementXOffsetThreshold=self.movementXOffsetThreshold;
	local curPosX,curPosY=self.player:getPosition();
	local controlspeedrate=self.player.speed;
	local curDirectionX=self.player.curDirectionX;
	local curDirectionY=self.player.curDirectionY;
	local curBakPosX,curBakPosY=self.mapPanel:getPosition();
	local backSize=self.mapPanel:getContentSize();
	local visibleSize=cc.Director:getInstance():getVisibleSize();
	local newx=curPosX + controlspeedrate*curDirectionX;
	local newy=curPosY + controlspeedrate*curDirectionY;
	local newbackx=curBakPosX;
	if newy> self.movementYBound1 or newy < self.movementYBound0 then
		newy=curPosY;
	end
	if newx<=0 or newx>= backSize.width then
		newx=curPosX;
	end
	self.player:setPosition(newx,newy);
	
	local screenPosX=newx+curBakPosX;
	if screenPosX< movementXOffsetThreshold then
		if curBakPosX<0 then
			newbackx=curBakPosX-controlspeedrate*curDirectionX;
		end
	end
	if screenPosX>visibleSize.width-movementXOffsetThreshold then
		if curBakPosX>visibleSize.width-backSize.width then
			newbackx=curBakPosX-controlspeedrate*curDirectionX;
		end
	end
	self.mapPanel:setPosition(newbackx,curBakPosY);
end


function MapLayer:Win()
	if (self.MapEnd ~= nil) then
		self.MapEnd(true);
	end
end

function MapLayer:Lose()
	if (self.MapEnd ~= nil) then
		self.MapEnd(false);
	end
end

function MapLayer:Test()
	
end

return MapLayer