

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
	self.speed=5;
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
			--print("nima")
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
	
	local pHurtAni = createWithSingleFrameName("reimu_hurt_", 0.1, 1);
	self.action_Hurt=cc.Sequence:create(cc.Animate:create(pHurtAni),cc.CallFunc:create(function(node,value)
		self:EndATK();
	end));
	self.action_Hurt:retain();
	
	local pStartAni = createWithSingleFrameName("reimu_start_", 0.1, 1);
	self.action_Welcome=cc.Sequence:create(cc.Animate:create(pStartAni),cc.CallFunc:create(function(node,value)
		self:EndWelcome();
	end));
	self.action_Welcome:retain();
	
	local pDeadAni = createWithSingleFrameName("reimu_dead_", 0.1, 1);
	self.action_Dead=cc.Sequence:create(cc.Animate:create(pDeadAni),cc.Blink:create(3, 9),cc.CallFunc:create(function(node,value)
		self:EndDead();
	end));
	self.action_Dead:retain();
	
	local pWinAni = createWithSingleFrameName("reimu_win_", 0.1, 1);
	self.action_Win=cc.Sequence:create(cc.Animate:create(pWinAni),cc.CallFunc:create(function(node,value)
		self:EndWin();
	end));
	self.action_Win:retain();
	
end

function PlayerNode:SetOnceState(state)
	self.curOState = state;
	if state == O_STATE_ATK1 then
		self:StartATK1();
	elseif state == O_STATE_ATK2 then
		self:StartATK2();
	elseif state == O_STATE_ATK3 then
		self:StartATK3();
	elseif state == O_STATE_ATK4 then
		self:StartATK4();
	elseif state == O_STATE_ATK5 then
		self:StartATK5();
	elseif state == O_STATE_ATK6 then
		self:StartATK6();
	elseif state == O_STATE_ATK7 then
		self:StartATK7();
	elseif state == O_STATE_DEAD then
		self:StartDead();
	elseif state == O_STATE_WELOME then
		self:StartWelcome();
	elseif state == O_STATE_HURT then
		self:StartHurt();
	elseif state == O_STATE_WIN then
		self:StartWin();
	elseif state == O_STATE_NONE then
		self:stopAllActions();
	else
		return;
	end
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

function PlayerNode:StartHurt()
	self:stopAllActions();
	self:runAction(self.action_Hurt);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_HURT);
	end
end

function PlayerNode:StartDead()
	self:stopAllActions();
	self:runAction(self.action_Dead);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_DEAD);
	end
end

function PlayerNode:StartWelcome()
	self:stopAllActions();
	self:runAction(self.action_Welcome);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_WELOME);
	end
end

function PlayerNode:StartWin()
	self:stopAllActions();
	self:runAction(self.action_Win);
	if self.OnceStateChanged ~= nil then
		self.OnceStateChanged(self, O_STATE_WIN);
	end
end

function PlayerNode:EndATK()
	self.curOState = O_STATE_NONE;
	self:onBackToLastingState();
end

function PlayerNode:EndWin()
	self.curOState = O_STATE_NONE;
	if self.End~=nil then
		self.End(self,1);
	end
	self:onBackToLastingState();
end

function PlayerNode:EndDead()
	self.curOState = O_STATE_NONE;
	if self.End~=nil then
		self.End(self,0);
	end
	self:onBackToLastingState();
end

function PlayerNode:EndWelcome()
	self.curOState = O_STATE_NONE;
	if self.End~=nil then
		self.End(self,2);
	end
	self:onBackToLastingState();
end

function PlayerNode:onBackToLastingState()
	self:CheckFlip();
	if self.curLState == L_STATE_STAND then
		self:BecomeStand();
	elseif curLState == L_STATE_FORWARD then
		self:BecomeForward();
	else
		self:BecomeForward();
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