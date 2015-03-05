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
	self:InitUpdate();
	return true;
end

function MapLayer:InitDefaultParms()
	self.movementYBound0 = 80;
	self.movementYBound1 = 323;
	self.movementXOffsetThreshold = 200;
	
	self.monsters={};
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
	local function onKeyPressed(keyCode, event)
		if keyCode==136 then
			self:Test();
		end
	end
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
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
			sender:SetOnceState(O_STATE_DEAD);
		end
	end
	
	
	print("~InitPlayer")
	
	

end

function MapLayer:InitMonsters()
	local mon = self:CreateMonster(0);
	mon:setPosition(600,250);
	mon:setGlobalZOrder(5);
	mon:SetMovementRange(0, self.mapPanel:getContentSize().width - 5, self.movementYBound0, self.movementYBound1);
	self.mapPanel:addChild(mon);
	table.insert(self.monsters,mon);
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

function MapLayer:CreateMonster(mtype)
--[[	MonsterNode* monster;
		if (type==0)
			monster = Monster_1::create();
		else if (type==1)
			monster = Monster_2::create();
		else
			monster = Monster_3::create();
		monster->setAnchorPoint(ccp(0.5, 0.5));
		monster->SetEnableTargetSeeking(true);
		monster->SetTargetNode(this->GetPlayerSprite());
		monster->Attack = [&](MonsterNode* mon)
		{
			skManager.MonsterExecuteSkill(mon, MONSTER_SKILL_1, GetMapPanel());
		};
		monster->Dead = [&](MonsterNode* mon)
		{
			for (size_t i = 0; i < monsters.size(); i++)
			{
				if (mon == monsters[i])
				{
					monsters[i] = monsters[monsters.size() - 1];
					monsters.pop_back();
					break;
				}
			}
			mon->removeFromParent();
			if (monsters.size() == 0)
			{
				player->SetOnceState(O_STATE_WIN);
			}
		};
		return monster;--]]
	local monster=nil;
	if mtype==0 then
		monster=MonsterNode.create_1();
	elseif mtype==1 then
		monster=MonsterNode.create_1();
	else
		monster=MonsterNode.create_1();
	end
	monster:setAnchorPoint(0.5, 0.5);
	monster.EnableTargetSeeking=true;
	monster.TargetNode=self.player;
	monster.Attack=function(sender)
		print("as");
	end
	monster.Dead=function(sender)
		print("as2");
	end
	
	return monster;
end

function MapLayer:Test()
	
end

return MapLayer