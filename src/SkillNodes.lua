SkillNode = class("SkillNode",function()
    return cc.Node:create();
end)

function SkillNode.create()
	local layer=SkillNode.new()
	layer:InitParms()
	return layer;
end

function SkillNode:ctor()
	
end

function SkillNode:InitParms()
	self.ExecuteDamage=nil;
	self.SkillEnd=nil;
	self.coverRanges={};
	self.startPosition=cc.p(0,0);
	self.damage=1;
	self.mpneed=1;
	self.oncelocked=false;
	self.lockedTable={};
	self.isforward=true;
	self.removeDelayTime=0;
	self.executeDelayTime=0;
end

function SkillNode:Start_d()
	prints("SkillNode:Start");
	local scheduler = cc.Director:getInstance():getScheduler();
	local scheduleId=scheduler:scheduleScriptFunc(function(dt)
		prints("SkillNode:scheduleId_1");
		self:onExecuteDamage(dt);
		scheduler:unscheduleScriptEntry(self.scheduleId_1)
	end,self.executeDelayTime,false);
	self.scheduleId_1=scheduleId;
end

function SkillNode:Start()
	if self.Start_Sub~=nil then
		self:Start_Sub();
	else
		self:Start_d();
	end
end

function SkillNode:onExecuteDamage_d(delta)
	prints("SkillNode:onExecuteDamage");                                                                                                                                               
	if self.ExecuteDamage ~= nil then
		self.ExecuteDamage(self);
	end
	local scheduler = cc.Director:getInstance():getScheduler();
	local scheduleId=scheduler:scheduleScriptFunc(function(dt)
		self:onSkillEnd(dt);
		scheduler:unscheduleScriptEntry(self.scheduleId_2)
	end, self.removeDelayTime,false);
	self.scheduleId_2=scheduleId;	
end

function SkillNode:onExecuteDamage(delta)
	if(self.onExecuteDamage_Sub~=nil) then
		self:onExecuteDamage_Sub(dt);
	else
		self:onExecuteDamage_d(dt);
	end
end

function SkillNode:onSkillEnd_d(dt)
	prints("SkillNode:onSkillEnd");
	if self.SkillEnd ~= nil then
		self.SkillEnd(self);
	end
end

function SkillNode:onSkillEnd(dt)
	if self.onSkillEnd_Sub~=nil then
		self:onSkillEnd_Sub(dt);
	else
		self:onSkillEnd_d(dt);
	end
end

function SkillNode:IsSkillRangeCover(pos)
	prints("SkillNode:IsSkillRangeCover");
	for i=1,#self.coverRanges do
		local actualRec=self:GetActualRect(self.coverRanges[i]);
		if cc.rectContainsPoint(actualRec,pos) then
			return true;
		end
	end
	return false;
end

function SkillNode:ShowDamage(monster,index)
	prints("SkillNode:ShowDamage");
end

function SkillNode:GetDamage()
	prints("SkillNode:GetDamage");
	return GetCenterFloatRandom(self.damage,0.25);
end

function SkillNode:GetActualRect(coverTemplate)
	prints("SkillNode:GetActualRect");
	local minx=cc.rectGetMinX(coverTemplate)
	local miny=cc.rectGetMinY(coverTemplate)
	local maxx=cc.rectGetMaxX(coverTemplate)
	local maxy=cc.rectGetMaxY(coverTemplate)
	local width=maxx-minx;
	local height=maxy-miny;
	local sx=self.startPosition.x;
	local sy=self.startPosition.y;
	if self.isforward then
		return cc.rect(minx+sx,miny+sy,width,height);
	else
		return cc.rect(sx-minx-width,miny+sy,width,height);
	end
end

function SkillNode:MovePos(deltaX,deltaY)
	prints("SkillNode:MovePos");
	local posX,posY = self:getPosition();
	posX=posX+deltaX;
	posY=posY+deltaY;
	self:setPosition(posX,posY);
end

--SkillNode_ATK1
---------------------------------------------------
SkillNode_ATK1=class("SkillNode_ATK1",SkillNode)

function SkillNode_ATK1.create()
	prints("SkillNode_ATK1.create");
	local layer=SkillNode_ATK1.new()
	layer:InitParms_Sub()
	return layer;
end

function SkillNode_ATK1:InitParms_Sub()
	prints("SkillNode_ATK1:InitParms_Sub");
	self:InitParms();
	table.insert(self.coverRanges,cc.rect(0, -160, 220, 260));
	self.executeDelayTime = 0.25;
	self.removeDelayTime = 0.1;
	self.mpneed = 10;
	self.damage = 560;
	
end

function SkillNode_ATK1:onExecuteDamage_Sub(delta)
	prints("SkillNode_ATK1:onExecuteDamage_Sub");
	PlaySound("Sound//hit.wav");
	self:onExecuteDamage_d(delta);
end

--SkillNode_ATK2
---------------------------------------------------
SkillNode_ATK2=class("SkillNode_ATK2",SkillNode)

function SkillNode_ATK2.create()
	prints("SkillNode_ATK2.create");
	local layer=SkillNode_ATK2.new()
	layer:InitParms_Sub()
	return layer;
end

function SkillNode_ATK2:InitParms_Sub()
	prints("SkillNode_ATK2:InitParms_Sub");
	self:InitParms();
	table.insert(self.coverRanges,cc.rect(0, -170, 140, 180));
	self.executeDelayTime = 0.25;
	self.removeDelayTime = 0;
	self.mpneed = 10;
	self.damage = 400;
	
end

function SkillNode_ATK2:Start_Sub()
	PlaySound("Sound//tiren.wav");
	self:Start_d();
end

--SkillNode_ATK3
---------------------------------------------------
SkillNode_ATK3=class("SkillNode_ATK3",SkillNode)

function SkillNode_ATK3.create()
	prints("SkillNode_ATK3.create");
	local layer=SkillNode_ATK3.new()
	layer:InitParms_Sub()
	return layer;
end

function SkillNode_ATK3:InitParms_Sub()
	prints("SkillNode_ATK3:InitParms_Sub");
	self:InitParms();
	table.insert(self.coverRanges,cc.rect(0, -100, 200, 220));
	self.executeDelayTime = 0.55;
	self.removeDelayTime = 0;
	self.mpneed = 10;
	self.damage = 650;
	
end

function SkillNode_ATK3:Start_Sub()
	PlaySound("Sound//hit2.wav");
	self:Start_d();
end

--SkillNode_ATK4
---------------------------------------------------
SkillNode_ATK4=class("SkillNode_ATK4",SkillNode)

function SkillNode_ATK4.create()
	prints("SkillNode_ATK4.create");
	local layer=SkillNode_ATK4.new()
	layer:InitParms_Sub()
	
	return layer;
end

function SkillNode_ATK4:InitParms_Sub()
	prints("SkillNode_ATK4:InitParms_Sub");
	self:InitParms();
	table.insert(self.coverRanges,cc.rect(-10, -80, 20, 160));
	self.executeDelayTime = 0.6;
	self.removeDelayTime = 0;
	self.mpneed = 220;
	self.damage = 850;
	self.speed=12;
	local sp1=cc.Sprite:create("Skill/atk4d.png");
	sp1:setAnchorPoint(0.5, 0.5);
	sp1:setPosition(-20, 0);
	sp1:setName("sp1");
	self:addChild(sp1);
	local pATK4=createWithSingleFrameName("sk6_",0.02,13);
	self.sk_ac=cc.Sequence:create(cc.Animate:create(pATK4));
	self.sk_ac:retain();
	sp1:setVisible(false);
end

function SkillNode_ATK4:BeginUpdate()
	self:scheduleUpdateWithPriorityLua(function(dt)
		if self.oncelocked then
			self:onExecuteDamage_Sub(dt);
		end
    end,0)
end

function SkillNode_ATK4:Start_Sub()
	prints("SkillNode_ATK4:Start_Sub");
	local sp1 = self:getChildByName("sp1");
	sp1:setVisible(true);
	local delta=1500;
	if not self.isforward then
		 delta=-1500;
	end
	self.lockedTable={}
	self.oncelocked=true;
	self.tarpos=cc.p(tarposX,self.startPosition.y);
	sp1:stopAllActions();
	local ac2=cc.Sequence:create(cc.MoveBy:create(1.5,cc.p(delta,0)),cc.CallFunc:create(function(node,value)
		self.oncelocked=false;
		self:onSkillEnd(0);
	end));
	sp1:runAction(self.sk_ac);
	self:runAction(ac2);
	self:BeginUpdate();
	PlaySound("Sound/hit2.wav");
end

function SkillNode_ATK4:onExecuteDamage_Sub(dt)                                                                                                                                             
	if self.ExecuteDamage ~= nil then
		self.ExecuteDamage(self);
	end
end

--SkillNode_ATK5
---------------------------------------------------
SkillNode_ATK5=class("SkillNode_ATK5",SkillNode)

function SkillNode_ATK5.create()
	prints("SkillNode_ATK5.create");
	local layer=SkillNode_ATK5.new()
	layer:InitParms_Sub()
	return layer;
end

function SkillNode_ATK5:InitParms_Sub()
	prints("SkillNode_ATK5:InitParms_Sub");
	self:InitParms();
	table.insert(self.coverRanges,cc.rect(-600, -200, 1200, 400));
	self.executeDelayTime = 0.8;
	self.removeDelayTime = 0.5;
	self.mpneed = 300;
	self.damage = 1300;
	local sp1 = cc.Sprite:create("Skill/atk5d.png");
	sp1:setAnchorPoint(0.5, 0.5);
	sp1:setName("sp1");
	sp1:setVisible(true);
	sp1:setGlobalZOrder(9);
	self:addChild(sp1);
	local pATK5 = createWithSingleFrameName("sk1_", 0.05, 10);
	self.sk_ac=cc.Sequence:create(cc.DelayTime:create(0), cc.Animate:create(pATK5), cc.CallFunc:create(function(sp)
		sp:setVisible(false);
	end));
	self.sk_ac:retain();
end

function SkillNode_ATK5:ShowDamage(mon,index)
	local sp1a=cc.Sprite:create("Skill/atk5da.png");
	sp1a:setAnchorPoint(0.5,0.5);
	local monx,mony=mon:getPosition();
	local px,py=self:getPosition();
	sp1a:setPosition(monx-px,mony-py+50);
	self:addChild(sp1a);
	local pATK5a=createWithSingleFrameName("sk3_",0.03,1);
	local ac=cc.Sequence:create(cc.Animate:create(pATK5a),cc.CallFunc:create(function(node,value)
		node:removeFromParent();
	end));
	sp1a:runAction(ac);
end

function SkillNode_ATK5:Start_Sub()
	self:Start_d();
	local sp1 = self:getChildByName("sp1");
	sp1:stopAllActions();
	sp1:setVisible(true);
	sp1:runAction(self.sk_ac);
	PlaySound("Sound//hit3.wav");
end

function SkillNode_ATK5:onExecuteDamage_Sub(delta)
	PlaySound("Sound//bomb.wav");
	local sp1 = self:getChildByName("sp1");
	sp1:setVisible(false);
	self:onExecuteDamage_d(delta);
end

--SkillNode_ATK6
---------------------------------------------------
SkillNode_ATK6=class("SkillNode_ATK6",SkillNode)

function SkillNode_ATK6.create()
	prints("SkillNode_ATK6.create");
	local layer=SkillNode_ATK6.new()
	layer:InitParms_Sub()
	return layer;
end

function SkillNode_ATK6:InitParms_Sub()
	prints("SkillNode_ATK6:InitParms_Sub");
	self:InitParms();
	table.insert(self.coverRanges,cc.rect(-70, -100, 880, 350));
	self.executeDelayTime = 2;
	self.removeDelayTime = 0.5;
	self.mpneed = 550;
	self.damage = 3300;
	local sp1 = cc.Sprite:create("Skill/atk6d.png");
	sp1:setAnchorPoint(0.04, 0.5);
	sp1:setPosition(0,0);
	sp1:setName("sp1");
	sp1:setVisible(false);
	
	local sp1r = cc.Sprite:create("Skill/atk6d.png");
	sp1r:setAnchorPoint(0.96, 0.5);
	sp1r:setPosition(0, 0);
	sp1r:setName("sp1r");
	sp1r:setFlippedX(true);
	sp1r:setVisible(false);
	local pATK6 = createWithSingleFrameName("atk6_", 0.05, 15);
	self.sk_ac=cc.Sequence:create(cc.Animate:create(pATK6));
	self.sk_ac:retain();
	
	local sp2 = cc.Sprite:create("Skill/atk7ad.png");
	sp2:setAnchorPoint(0.5, 0.5);
	sp2:setPosition(0, 0);
	sp2:setName("sp2");
	sp2:setVisible(false);
	local pATK6a = createWithSingleFrameName("atk7a_", 0.1, 3);
	self.sk_ac1=cc.Sequence:create(cc.Animate:create(pATK6a),cc.CallFunc:create(function()
		local sp1i = nil;
		if (self.isforward) then
			sp1i = self:getChildByName("sp1");
		else
			sp1i = self:getChildByName("sp1r");
		end
		local sp2i =self:getChildByName("sp2");
		sp2i:setVisible(false);
		sp1i:setVisible(true);
		sp1i:stopAllActions();
		sp1i:setScale(1.5, 1.7);
		sp1i:runAction(self.sk_ac);
	end));
	self.sk_ac1:retain();
	self:addChild(sp2);
	self:addChild(sp1);
	self:addChild(sp1r);
end

function SkillNode_ATK6:Start_Sub()
	self:Start_d();
	self:MovePos(0, -20);
	local sp1=self:getChildByName("sp1");
	local sp1r=self:getChildByName("sp1r");
	sp1:setVisible(false);
	sp1r:setVisible(false);
	local sp = nil;
	if (self.isforward) then
		sp = sp1;
	else
		sp = sp1r;
	end
	local sp2 = self:getChildByName("sp2");
	sp2:setVisible(true);
	sp:setVisible(false);
	sp2:stopAllActions();
	sp2:runAction(self.sk_ac1);
	PlaySound("Sound/thunder.wav");
end


--SkillNode_Mons1
-------------------------------------

SkillNode_Mons1=class("SkillNode_Mons1",SkillNode)

function SkillNode_Mons1.create()
	prints("SkillNode_Mons1.create");
	local layer=SkillNode_Mons1.new()
	layer:InitParms_Sub()
	return layer;
end

function SkillNode_Mons1:InitParms_Sub()
	prints("SkillNode_Mons1:InitParms_Sub");
	self:InitParms();
	table.insert(self.coverRanges,cc.rect(0, -50, 100, 100));
	self.damage = 800;
	self.executeDelayTime = 0;
	self.removeDelayTime = 0;
end