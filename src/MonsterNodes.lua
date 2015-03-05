
MonsterNode = class("MonsterNode",function()
    return cc.Layer:create();

end)

function MonsterNode.create()
	local node=MonsterNode.new()
	node:init()
	return node;
end

function MonsterNode:ctor()
	
end

function MonsterNode:init()
	self:InitDefaultParams();
	self:InitComponents();
	self:InitEventHandlers();
	self:InitUpdate();
	return true;
end

function MonsterNode:InitDefaultParams()
	self.maxHp = 10000;
	self.curHp = self.maxHp;
	self.speedrate = 2;
	self.enableTargetSeeking = false;
	self.intervalTime_ATK = 1.5;
	self.cumlativeTime_ATK = self.intervalTime_ATK;
	self.inATK = false;
	self.m_currActionState=ACTION_STATE_NONE;
	self.movementXBound0 = 0;
	self.movementXBound1 = 960;
	self.movementYBound0 = 0;
	self.movementYBound1 = 640;
	self.target=nil;
end

function MonsterNode:InitComponents()
	print("InitComponents")
	self.rootNode=cc.Node:create();
	self.rootNode:setAnchorPoint(0.5, 0.5);
	self.rootNode:setPosition(0, 0);
	self:addChild(self.rootNode);
	local sp=cc.Sprite:create("Mons/hps.png");
	local lb =cc.ProgressTimer:create(sp);
	lb:setScaleX(0.6);
	lb:setScaleY(0.44);
	lb:setAnchorPoint(0.5, 0.5);
	lb:setType(cc.PROGRESS_TIMER_TYPE_BAR);
	lb:setBarChangeRate(cc.p(1,0))
	lb:setMidpoint(cc.p(0,0.5));
	lb:setPercentage(100);
	lb:setPosition(0, 61);
	lb:setName("lb");
	self.rootNode:addChild(lb);

	local flow=GetFlowWordNode();
	flow:setName("FLWord");
	flow:setPosition(0,0);
	self:addChild(flow);
	
	print("~InitComponents")
end

function MonsterNode:InitEventHandlers()
	print("InitEventHandlers")
	local function onKeyPressed_mon(keyCode, event)
		if keyCode==KEY_SPACE then
			self:Test();
		end
	end
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed_mon, cc.Handler.EVENT_KEYBOARD_PRESSED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
	print("~InitEventHandlers")
end

function MonsterNode:InitAnimations()
	
end

function MonsterNode:InitUpdate()
	self:scheduleUpdateWithPriorityLua(function(dt)
		if self.sprite == nil then
			return;
		end
		if self.enableTargetSeeking and not self.inATK then
			self:CheckFilp();
			self:MarchingToTargetPerFrame();
		end
		if self:ConditionMeets_ATK() then
			self:StartATK();
			self.cumlativeTime_ATK = 0;
		else
			self.cumlativeTime_ATK =self.cumlativeTime_ATK+dt;
		end
    end,0)
end

function MonsterNode:SetMovementRange(minX,maxX,minY,maxY)
	self.movementXBound0 = minX;
	self.movementXBound1 = maxX;
	self.movementYBound0 = minY;
	self.movementYBound1 = maxY;
end

function MonsterNode:ChangeHp(hp,reboundType)
	if hp < 0 then
		hp = 0;
	end
	if hp>self.maxHp then
		hp = self.maxHp;
	end
	if hp < self.curHp then
		if hp ~= 0 then
			self:Rebound(self.curHp - hp, reboundType);
			self:StartHurt();
			local fl=self:getChildByName("FLWord");
			ShowWord1(fl,string.format("%s",hp-self.curHp));
		else
			self:StartDead();
		end
	end
	self.curHp=hp;
	local lb=self.rootNode:getChildByName("lb");
	lb:setPercentage(100 * self.curHp / self.maxHp);
end


function MonsterNode:ChangeState(actionState)
	if (self.m_currActionState==ACTION_STATE_DEAD) or self.m_currActionState==actionState then
		return false;
	end
	self.inATK=false;
	self.sprite:stopAllActions();
	self.m_currActionState=actionState;
	if actionState== ACTION_STATE_REMOVE then
		return false;
	else
		return true;
	end
end

function MonsterNode:BecomeStand()
	if self:ChangeState(ACTION_STATE_IDLE) then
		local mon = self.sprite;
		mon:runAction(self.action_Idle);
	end
end

function MonsterNode:StartATK()
	if self:ChangeState(ACTION_STATE_ATTACK) then
		local mon = self.sprite;
		self.inATK = true;
		mon:runAction(self.action_Attack);
		if self.Attack ~= nil then
			self.Attack(this);
		end
	end
end

function MonsterNode:StartHurt()
	if self:ChangeState(ACTION_STATE_HURT) then
		local mon = self.sprite;
		self.inATK = true;
		mon:runAction(self.action_Hurt);
	end
end

function MonsterNode:StartDead()
	if self:ChangeState(ACTION_STATE_DEAD) then
		local mon = self.sprite;
		self.inATK = true;
		mon:runAction(self.action_Dead);
	end
end

function MonsterNode:onEndATK()
	self:BecomeStand();
end

function MonsterNode:onEndHurt()
	self:BecomeStand();
end

function MonsterNode:onEndDead()
	if self.Dead ~= nil then
		self.Dead(self);
	end
end

function MonsterNode:Rebound(deltaHp,rtype)
	
end

function MonsterNode:CheckFilp()
	if self.target==nil then
		return
	end 
	local posX,posY=self:getPosition();
	local tposX,tposY=self.target:getPosition();
	local isOnTargetLeft = false;
	if posX < tposX then
		isOnTargetRight=false;
	else
		isOnTargetRight=true;
	end
	self.sprite:setFlippedX(isOnTargetRight);
end

function MonsterNode:MarchingToTargetPerFrame()
	if self.target==nil then 
		return;
	end
	local posX,posY=self:getPosition();
	local tposX,tposY=self.target:getPosition();
	local delta=cc.p(tposX-posX,tposY-posY);
	local curDirection=cc.pNormalize(delta);
	if cc.pGetLength(delta) > self.speedrate then
		posX=posX+curDirection.x*self.speedrate;
		posY=posY+curDirection.y*self.speedrate;
		self:setPosition(posX,posY);
	else
		self:setPosition(tposX,tposY);
	end 
end

function MonsterNode:ConditionMeets_ATK()
	if self.m_currActionState == ACTION_STATE_DEAD or self.target==nil then
		return false;
	end
	if self.cumlativeTime_ATK > self.intervalTime_ATK then
		local posX,posY=self:getPosition();
		local tposX,tposY=self.target:getPosition();
		local delta=cc.p(tposX-posX,tposY-posY);
		local len=cc.pGetLength(delta);
		if len < 30 then
			return true;
		end
		return false;
	else
		return false;
	end
end

function MonsterNode:Test()
	self:ChangeHp(self.curHp-600,0);
end

----------------------------------------

function MonsterNode.create_1()
	local node=MonsterNode.new()
	node:init_1()
	return node;
end

function MonsterNode:init_1()
	self:InitDefaultParams_1();
	self:InitComponents_1();
	self:InitEventHandlers_1();
	self:InitAnimations_1();
	self:InitUpdate();
	return true;
end

function MonsterNode:InitDefaultParams_1()
	self:InitDefaultParams();
	
end

function MonsterNode:InitComponents_1()
	self:InitComponents();
	local sp = cc.Sprite:create("Mons//mons1d.png");
	sp:setContentSize(cc.size(88, 101));
	sp:setName("sp");
	sp:setAnchorPoint(0.5, 0.5);
	self.sprite=sp;
	self.rootNode:addChild(sp);
end

function MonsterNode:InitEventHandlers_1()
	self:InitEventHandlers();
end

function MonsterNode:InitAnimations_1()
	self:InitAnimations();
	local frameCache = cc.SpriteFrameCache:getInstance();
	frameCache:addSpriteFrames("Mons\\mons1.plist", "Mons\\mons1.png");

	local pIdleAnim=createWithSingleFrameName("mons1_", 0.2, 1);
	self.action_Idle=cc.RepeatForever:create(cc.Animate:create(pIdleAnim));
	self.action_Idle:retain();
	
	local pAttackAnim=createWithSingleFrameName("mons2_", 0.2, 1);
	self.action_Attack=cc.Sequence:create(cc.Animate:create(pAttackAnim),cc.CallFunc:create(function(node,value)
		self:onEndATK();
	end));
	self.action_Attack:retain();

	local pHurtAnim=createWithSingleFrameNameAndCount("mons4_", 2, 0.2, 1);
	self.action_Hurt=cc.Sequence:create(cc.Animate:create(pHurtAnim),cc.CallFunc:create(function(node,value)
		self:onEndHurt();
	end));
	self.action_Hurt:retain();
	
	local pDeadAnim = createWithSingleFrameName("mons4_", 0.2, 1);
	self.action_Dead=cc.Sequence:create(cc.Animate:create(pDeadAnim),cc.Blink:create(3, 9),cc.CallFunc:create(function(node,value)
		self:onEndDead();
	end));
	self.action_Dead:retain();	

	self:BecomeStand()
end