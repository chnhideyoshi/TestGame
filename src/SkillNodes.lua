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
	self.isforward=true;
	self.removeDelayTime=0;
	self.executeDelayTime=0;
end

function SkillNode:Start()
	print("SkillNode:Start");
	local scheduler = cc.Director:getInstance():getScheduler();
	local scheduleId=scheduler:scheduleScriptFunc(function(dt)
		print("SkillNode:scheduleId_1");
		self:onExecuteDamage(dt);
		scheduler:unscheduleScriptEntry(self.scheduleId_1)
	end,self.executeDelayTime,false);
	self.scheduleId_1=scheduleId;
end

function SkillNode:onExecuteDamage(delta)
	print("SkillNode:onExecuteDamage");                                                                                                                                               
	if self.ExecuteDamage ~= nil then
		self.ExecuteDamage(self);
	end
	local scheduler = cc.Director:getInstance():getScheduler();
	scheduler:scheduleScriptFunc(function(dt)
		self:onSkillEnd(dt);
	end, self.removeDelayTime,true);
end

function SkillNode:onSkillEnd(dt)
	print("SkillNode:onSkillEnd");
	if self.SkillEnd ~= nil then
		self.SkillEnd(self);
	end
end

function SkillNode:IsSkillRangeCover(pos)
	print("SkillNode:IsSkillRangeCover");
	for i=1,#self.coverRanges do
		local actualRec=self:GetActualRect(self.coverRanges[i]);
		if cc.rectContainsPoint(actualRec,pos) then
			return true;
		end
	end
	return false;
end

function SkillNode:ShowDamage(monster,index)
	print("SkillNode:ShowDamage");
end

function SkillNode:GetDamage()
	print("SkillNode:GetDamage");
	return GetCenterFloatRandom(self.damage,0.25);
end

function SkillNode:GetActualRect(coverTemplate)
	print("SkillNode:GetActualRect");
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
	print("SkillNode:MovePos");
	local posX,posY = self:getPosition();
	posX=posX+deltaX;
	posY=posY+deltaY;
	self:setPosition(posX,posY);
end

--SkillNode_ATK1
---------------------------------------------------
SkillNode_ATK1=class("SkillNode_ATK1",SkillNode)

function SkillNode_ATK1.create()
	print("SkillNode_ATK1.create");
	local layer=SkillNode_ATK1.new()
	layer:InitParms_Sub()
	return layer;
end

function SkillNode_ATK1:InitParms_Sub()
	print("SkillNode_ATK1:InitParms_Sub");
	self:InitParms();
	table.insert(self.coverRanges,cc.rect(0, -160, 220, 260));
	self.executeDelayTime = 0.25;
	self.removeDelayTime = 0.1;
	self.mpneed = 10;
	self.damage = 560;
	
end

function SkillNode_ATK1:onExecuteDamage_Sub(delta)
	print("SkillNode_ATK1:onExecuteDamage_Sub");
	PlaySound("Sound//hit.wav");
	self:onExecuteDamage(delta);
end

--SkillNode_ATK2
---------------------------------------------------
