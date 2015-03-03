--PlayerOnceState
O_STATE_NONE= 10
O_STATE_ATK1= 11
O_STATE_ATK2= 12
O_STATE_ATK3= 13
O_STATE_ATK4= 14
O_STATE_ATK5= 15
O_STATE_ATK6= 16
O_STATE_ATK7= 17
O_STATE_HURT= 18
O_STATE_DEAD= 19
O_STATE_WELOME= 20
O_STATE_WIN= 21

--PlayerLastingState
L_STATE_STAND=0
L_STATE_FORWARD=1
L_STATE_DEFEND=2

--KEYS
KEY_UP=28;
KEY_DOWN=29;
KEY_LEFT=26;
KEY_RIGHT=27;

KEY_Z=149;
KEY_X=147;
KEY_C=126;
KEY_A=124;
KEY_S=142;
KEY_D=127;
KEY_Q=140;

PlayerNode = class("PlayerNode",function()
    return cc.Sprite:create();

end)

function PlayerNode.createPlayer()
	local sp=PlayerNode.new()
	sp:init_my()
	return sp;
end

function PlayerNode:ctor()
	
end

function PlayerNode:init_my()
	self:InitDefaultParms();
	self:InitComponents();
	self:InitEventHandlers();
	self:InitAnimations();
	self:InitUpdate();
	return true;
end

function PlayerNode:InitDefaultParms()
	self.curOState = O_STATE_NONE;
	self.curLState = L_STATE_STAND;
	self.speed = 5;
	self.curDirectionX=0;
	self.curDirectionY=0;
	self.directionStack0X=0;
	self.directionStack0Y=0;
	self.directionStack1X=0;
	self.directionStack1Y=0;
end

function PlayerNode:InitComponents()
	print("InitComponents")
	self:setSpriteFrame(cc.SpriteFrame:create("Sprites//reimud.png", cc.rect(0,0,362,279)) )
	print("~InitComponents")
end

function PlayerNode:InitEventHandlers()
	print("InitEventHandlers")
	local function onKeyPressed(keyCode, event)
        if keyCode == KEY_UP then --
            self.curDirectionY=self.curDirectionY+1;
			self:CheckFlip()
        elseif keyCode == KEY_DOWN then
            self.curDirectionY=self.curDirectionY-1;
			self:CheckFlip()
        elseif keyCode == KEY_LEFT then
            self.curDirectionX=self.curDirectionX-1;
			self:CheckFlip()
        elseif keyCode == KEY_RIGHT then
            self.curDirectionX=self.curDirectionX+1;
			self:CheckFlip()
        elseif keyCode == KEY_Z then 
            if not self:InOAction() then
				self.curOState = O_STATE_ATK1;
				self:StartATK1();
			end
        elseif keyCode == KEY_X then
           if not self:InOAction() then
				self.curOState = O_STATE_ATK2;
				self:StartATK2();
			end
        elseif keyCode == KEY_C then
           if not self:InOAction() then
				self.curOState = O_STATE_ATK3;
				self:StartATK3();
			end
        elseif keyCode == KEY_A then 
           if not self:InOAction() then
				self.curOState = O_STATE_ATK4;
				self:StartATK4();
			end
        elseif keyCode == KEY_S then 
           if not self:InOAction() then
				self.curOState = O_STATE_ATK5;
				self:StartATK5();
			end
        elseif keyCode == KEY_D then 
           if not self:InOAction() then
				self.curOState = O_STATE_ATK6;
				self:StartATK6();
			end
        elseif keyCode == KEY_Q then 
           if not self:InOAction() then
				self.curOState = O_STATE_ATK7;
				self:StartATK7();
			end
		end
	end
	local function onKeyReleased(keyCode, event)
        if keyCode == KEY_UP then
			self.curDirectionY=self.curDirectionY-1;
			self:CheckFlip()
        elseif keyCode == KEY_DOWN then
            self.curDirectionY=self.curDirectionY+1;
			self:CheckFlip()
        elseif keyCode == KEY_LEFT then
            self.curDirectionX=self.curDirectionX+1;
			self:CheckFlip()
        elseif keyCode == KEY_RIGHT then
            self.curDirectionX=self.curDirectionX-1;
			self:CheckFlip()
		else
			print("nima")
		end
	end
	
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
	print("~InitEventHandlers")
end

function PlayerNode:InitUpdate()
	self:scheduleUpdateWithPriorityLua(function(dt)
		self.directionStack0X=self.directionStack1X;
		self.directionStack0Y=self.directionStack1Y;
		self.directionStack1X=self.curDirectionX;
		self.directionStack1Y=self.curDirectionY;
		self:CheckLastingStatedChanged();
		
    end,0)
end

function PlayerNode:InitAnimations()
	local frameCache = cc.SpriteFrameCache:getInstance();
	frameCache:addSpriteFrames("Sprites//reimu2.plist","Sprites//reimu2.png");
	
--[[		Animation* pStandAnim = Tools::createWithSingleFrameName("reimu_stand_", 0.1f, -1);
		this->setStandAction(RepeatForever::create(Animate::create(pStandAnim)));

		Animation* pForwardAnim = Tools::createWithSingleFrameName("reimu_forward_", 0.1f, -1);
		this->setForwardAction(RepeatForever::create(Animate::create(pForwardAnim)));

		Animation* pDefendAnim = Tools::createWithSingleFrameName("reimu_defend_", 0.1f, 1);
		this->setDefendAction(Sequence::create(Animate::create(pDefendAnim), NULL));

		Animation* pATK1Anim = Tools::createWithSingleFrameName("reimu_atk1_", 0.1f, 1);
		this->setATK1Action(Sequence::create(Animate::create(pATK1Anim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndATK1)), NULL));

		Animation* pATK2Anim = Tools::createWithSingleFrameName("reimu_atk2_", 0.1f, 1);
		this->setATK2Action(Sequence::create(Animate::create(pATK2Anim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndATK2)), NULL));

		Animation* pATK3Anim = Tools::createWithSingleFrameName("reimu_atk3_", 0.1f, 1);
		this->setATK3Action(Sequence::create(Animate::create(pATK3Anim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndATK3)), NULL));

		Animation* pATK4Anim = Tools::createWithSingleFrameName("reimu_atk4_", 0.1f, 1);
		this->setATK4Action(Sequence::create(Animate::create(pATK4Anim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndATK4)), NULL));

		Animation* pATK5Anim = Tools::createWithSingleFrameName("reimu_atk5_", 0.1f, 1);
		this->setATK5Action(Sequence::create(Animate::create(pATK5Anim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndATK5)), NULL));

		Animation* pATK6Anim = Tools::createWithSingleFrameName("reimu_atk6_", 0.1f, 1);
		this->setATK6Action(Sequence::create(Animate::create(pATK6Anim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndATK6)), NULL));

		Animation* pATK7Anim = Tools::createWithSingleFrameName("reimu_atk7_", 0.1f, 1);
		this->setATK7Action(Sequence::create(Animate::create(pATK7Anim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndATK7)), NULL));

		Animation* pHurtAnim = Tools::createWithSingleFrameName("reimu_hurt_", 0.1f, 1);
		this->setHurtAction(Sequence::create(Animate::create(pHurtAnim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndHurt)), NULL));

		Animation* pStartAnim = Tools::createWithSingleFrameName("reimu_start_", 0.1f, 1);
		this->setWelcomeAction(Sequence::create(Animate::create(pStartAnim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndWelcome)), NULL));

		Animation* pWinAnim = Tools::createWithSingleFrameName("reimu_win_", 0.1f, 1);
		this->setWinAction(Sequence::create(Animate::create(pWinAnim), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndWin)), NULL));

		Animation* pDeadAnim = Tools::createWithSingleFrameName("reimu_dead_", 0.1f, 1);
		this->setDeadAction(Sequence::create(Animate::create(pDeadAnim), Blink::create(3, 9), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndDead)), NULL));--]]

	local pStandAni=createWithSingleFrameName("reimu_stand_",0.1,-1);
	self.action_Stand=cc.RepeatForever:create(cc.Animate:create(pStandAni));
	self.action_Stand:retain();
	
	local pForwardAni=createWithSingleFrameName("reimu_forward_",0.1,-1);
	self.action_Forward=cc.RepeatForever:create(cc.Animate:create(pForwardAni));
	self.action_Forward:retain();
	
	local pATK1Ani = createWithSingleFrameName("reimu_atk1_", 0.1, 1);
	self.action_ATK1=cc.Sequence:create(cc.Animate:create(pATK1Ani),cc.CallFunc:create(function(node,value)
		self:EndATK();
	end));
	self.action_ATK1:retain();
	
	local pATK2Ani = createWithSingleFrameName("reimu_atk2_", 0.1, 1);
	self.action_ATK2=cc.Sequence:create(cc.Animate:create(pATK2Ani),cc.CallFunc:create(function(node,value)
		self:EndATK();
	end));
	self.action_ATK2:retain();
	
	local pATK3Ani = createWithSingleFrameName("reimu_atk3_", 0.1, 1);
	self.action_ATK3=cc.Sequence:create(cc.Animate:create(pATK3Ani),cc.CallFunc:create(function(node,value)
		self:EndATK();
	end));
	self.action_ATK3:retain();
	
	local pATK4Ani = createWithSingleFrameName("reimu_atk4_", 0.1, 1);
	self.action_ATK4=cc.Sequence:create(cc.Animate:create(pATK4Ani),cc.CallFunc:create(function(node,value)
		self:EndATK();
	end));
	self.action_ATK4:retain();
	
	local pATK5Ani = createWithSingleFrameName("reimu_atk5_", 0.1, 1);
	self.action_ATK5=cc.Sequence:create(cc.Animate:create(pATK5Ani),cc.CallFunc:create(function(node,value)
		self:EndATK();
	end));
	self.action_ATK5:retain();
	
	local pATK6Ani = createWithSingleFrameName("reimu_atk6_", 0.1, 1);
	self.action_ATK6=cc.Sequence:create(cc.Animate:create(pATK6Ani),cc.CallFunc:create(function(node,value)
		self:EndATK();
	end));
	self.action_ATK6:retain();
	
	local pATK7Ani = createWithSingleFrameName("reimu_atk7_", 0.1, 1);
	self.action_ATK7=cc.Sequence:create(cc.Animate:create(pATK7Ani),cc.CallFunc:create(function(node,value)
		self:EndATK();
	end));
	self.action_ATK7:retain();
	
	
	
end

function PlayerNode:BecomeStand()
	self:stopAllActions();
	self:runAction(self.action_Stand);
end

function PlayerNode:BecomeForward()
	self:stopAllActions();
	self:runAction(self.action_Forward);
end

function PlayerNode:StartATK1()
	self:stopAllActions();
	self:runAction(self.action_ATK1);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_ATK1);
	end
end

function PlayerNode:StartATK2()
	self:stopAllActions();
	self:runAction(self.action_ATK2);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_ATK2);
	end
end

function PlayerNode:StartATK3()
	self:stopAllActions();
	self:runAction(self.action_ATK3);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_ATK3);
	end
end

function PlayerNode:StartATK4()
	self:stopAllActions();
	self:runAction(self.action_ATK4);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_ATK4);
	end
end

function PlayerNode:StartATK5()
	self:stopAllActions();
	self:runAction(self.action_ATK5);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_ATK5);
	end
end

function PlayerNode:StartATK6()
	self:stopAllActions();
	self:runAction(self.action_ATK6);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_ATK6);
	end
end

function PlayerNode:StartATK7()
	self:stopAllActions();
	self:runAction(self.action_ATK7);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_ATK7);
	end
end



function PlayerNode:EndATK()
	self.curOState = O_STATE_NONE;
	self:onBackToLastingState();
end

function PlayerNode:onBackToLastingState()
	self:CheckFlip();
	if self.curLState == L_STATE_STAND then
		self:BecomeStand();
	elseif curLState == L_STATE_FORWARD then
		self:BecomeForward();
	else
		print("hhhh");
	end
end

function PlayerNode:SetLastingState(state)
	self.curLState=state;
	if not self:InOAction() then
		if state==L_STATE_STAND then
			self:BecomeStand();
		elseif state==L_STATE_FORWARD then
			self:BecomeForward();
		else
			print("hh");
		end
	end
end

	
function PlayerNode:CheckLastingStatedChanged()
	local islastMoving = self.directionStack0X ~= 0 or self.directionStack0Y ~= 0;
	local isCurMoving = self.directionStack1X ~= 0 or self.directionStack1Y ~= 0;
	if islastMoving and isCurMoving then
		return;
	end
	if (not islastMoving) and (not isCurMoving) then
		return;
	end
	if islastMoving and (not isCurMoving) then
		self:SetLastingState(L_STATE_STAND);
	end
	if (not islastMoving) and isCurMoving then
		self:SetLastingState(L_STATE_FORWARD);
	end

end

function PlayerNode:InOAction()
	if self.curOState ~= O_STATE_NONE then
		return true;
	else
		return false;
	end
end

function PlayerNode:CheckFlip()
	if self:InOAction() then
		return;
	end
	if self.curDirectionX > 0 then
		self:setFlippedX(false);
	end
	if self.curDirectionX < 0 then
		self:setFlippedX(true);
	end
end

return PlayerNode