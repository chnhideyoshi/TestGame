
MonsterNode = class("MonsterNode",function()
    return cc.Node:create();

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
	prints("InitComponents")
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
	
	prints("~InitComponents")
end

function MonsterNode:InitEventHandlers()
	prints("InitEventHandlers")
	local function onKeyPressed_mon(keyCode, event)
		if keyCode==KEY_SPACE then
			self:Test();
		end
	end
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed_mon, cc.Handler.EVENT_KEYBOARD_PRESSED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
	prints("~InitEventHandlers")
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
	prints("MonsterNode:ChangeHp")
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
			self.Attack(self);
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

function MonsterNode:Rebound(deltaHp,reboundType)
	prints("MonsterNode:Rebound")
	if reboundType==0 then
		self:stopAllActions();
		local leng=deltaHp/8;
		local tx,ty=self.target:getPosition();
		local px,py=self:getPosition();
		local p=cc.p(px,py);
		local t=cc.p(tx,ty);
		local len=cc.pGetDistance(t,p);
		if len ~=0 then
			local delta=cc.p((px-tx)*leng/len,(py-ty)*leng/len);
			if delta.y+py>self.movementYBound1 then
				local rate=math.abs(py-self.movementYBound1)/math.abs(delta.y);
				delta.x=delta.x*rate;
				delta.y=delta.y*rate;
			end
			if delta.y+py<self.movementYBound0 then
				local rate=math.abs(py-self.movementYBound0)/math.abs(delta.y);
				delta.x=delta.x*rate;
				delta.y=delta.y*rate;
			end
			local ac=cc.MoveBy:create(0.1,cc.p(delta.x, delta.y));
			self:runAction(ac);
		else
			local ac=cc.MoveBy:create(0.1,cc.p(100,0));
			self:runAction(ac);
		end
		
	end
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

--Monster type 1
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
	self.speedrate=0.8;
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




--Monster type 2
----------------------------------------
function MonsterNode.create_2()
	local node=MonsterNode.new()
	node:init_2()
	return node;
end

function MonsterNode:init_2()
	self:InitDefaultParams_2();
	self:InitComponents_2();
	self:InitEventHandlers_2();
	self:InitAnimations_2();
	self:InitUpdate();
	return true;
end

function MonsterNode:InitDefaultParams_2()
	self:InitDefaultParams();
	self.speedrate=1;
end

function MonsterNode:InitComponents_2()
	self:InitComponents();
	local sp = cc.Sprite:create("Mons//mons2d.png");
	sp:setContentSize(cc.size(88, 101));
	sp:setName("sp");
	sp:setAnchorPoint(0.5, 0.5);
	self.sprite=sp;
	self.rootNode:addChild(sp);
end

function MonsterNode:InitEventHandlers_2()
	self:InitEventHandlers();
end

function MonsterNode:InitAnimations_2()
	self:InitAnimations();
	local frameCache = cc.SpriteFrameCache:getInstance();
	frameCache:addSpriteFrames("Mons\\mons2.plist", "Mons\\mons2.png");

	local pIdleAnim=createWithSingleFrameName("mons2_stand_", 0.2, 1);
	self.action_Idle=cc.RepeatForever:create(cc.Animate:create(pIdleAnim));
	self.action_Idle:retain();
	
	local pAttackAnim=createWithSingleFrameName("mons2_atk_", 0.2, 1);
	self.action_Attack=cc.Sequence:create(cc.Animate:create(pAttackAnim),cc.CallFunc:create(function(node,value)
		self:onEndATK();
	end));
	self.action_Attack:retain();

	local pHurtAnim=createWithSingleFrameNameAndCount("mons2_dead_", 2, 0.2, 1);
	self.action_Hurt=cc.Sequence:create(cc.Animate:create(pHurtAnim),cc.CallFunc:create(function(node,value)
		self:onEndHurt();
	end));
	self.action_Hurt:retain();
	
	local pDeadAnim = createWithSingleFrameName("mons2_dead_", 0.2, 1);
	self.action_Dead=cc.Sequence:create(cc.Animate:create(pDeadAnim),cc.Blink:create(3, 9),cc.CallFunc:create(function(node,value)
		self:onEndDead();
	end));
	self.action_Dead:retain();	

	self:BecomeStand()
end


--Monster type 3
----------------------------------------
function MonsterNode.create_3()
	local node=MonsterNode.new()
	node:init_3()
	return node;
end

function MonsterNode:init_3()
	self:InitDefaultParams_3();
	self:InitComponents_3();
	self:InitEventHandlers_3();
	self:InitAnimations_3();
	self:InitUpdate();
	return true;
end

function MonsterNode:InitDefaultParams_3()
	self:InitDefaultParams();
	self.speedrate=1.5;
end

function MonsterNode:InitComponents_3()
	self:InitComponents();
	local sp = cc.Sprite:create("Mons//mons3d.png");
	sp:setContentSize(cc.size(88, 101));
	sp:setName("sp");
	sp:setAnchorPoint(0.5, 0.5);
	self.sprite=sp;
	self.rootNode:addChild(sp);
end

function MonsterNode:InitEventHandlers_3()
	self:InitEventHandlers();
end

function MonsterNode:InitAnimations_3()
	self:InitAnimations();
	local frameCache = cc.SpriteFrameCache:getInstance();
	frameCache:addSpriteFrames("Mons\\mons3.plist", "Mons\\mons3.png");

	local pIdleAnim=createWithSingleFrameName("Mons3_atk_", 0.2, 1);
	self.action_Idle=cc.RepeatForever:create(cc.Animate:create(pIdleAnim));
	self.action_Idle:retain();
	
	local pAttackAnim=createWithSingleFrameName("Mons3_stand_", 0.2, 1);
	self.action_Attack=cc.Sequence:create(cc.Animate:create(pAttackAnim),cc.CallFunc:create(function(node,value)
		self:onEndATK();
	end));
	self.action_Attack:retain();

	local pHurtAnim=createWithSingleFrameNameAndCount("Mons3_atk_", 2, 0.2, 1);
	self.action_Hurt=cc.Sequence:create(cc.Animate:create(pHurtAnim),cc.CallFunc:create(function(node,value)
		self:onEndHurt();
	end));
	self.action_Hurt:retain();
	
	local pDeadAnim = createWithSingleFrameName("Mons3_atk_", 0.2, 1);
	self.action_Dead=cc.Sequence:create(cc.Animate:create(pDeadAnim),cc.Blink:create(3, 9),cc.CallFunc:create(function(node,value)
		self:onEndDead();
	end));
	self.action_Dead:retain();	

	self:BecomeStand()
end
