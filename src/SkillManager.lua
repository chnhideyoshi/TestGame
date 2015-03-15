SkillManager = class("SkillManager")

function SkillManager.create()
	local sk=SkillManager.new();
	sk:InitParms();
	return sk;
end


function SkillManager:InitParms()
	self.playerStateToSkillTable={};
	self.skillsTable={};
	self.player=nil;
	self.monsters={};
	self:RegisterAllSkills();
end

function SkillManager:RegisterAllSkills()
	prints("SkillManager:RegisterAllSkills")
	local frameCache = cc.SpriteFrameCache:getInstance();
	frameCache:addSpriteFrames("Skill\\atk7.plist", "Skill\\atk7.png");
	frameCache:addSpriteFrames("Skill\\atk6.plist", "Skill\\atk6.png");	
	frameCache:addSpriteFrames("Skill\\atk7a.plist", "Skill\\atk7a.png");	
	frameCache:addSpriteFrames("Skill\\nima.plist", "Skill\\nima.png");		
	
	self.playerStateToSkillTable[O_STATE_ATK1] = PLAYER_SKILL_ATK1;
	self.playerStateToSkillTable[O_STATE_ATK2] = PLAYER_SKILL_ATK2;
	self.playerStateToSkillTable[O_STATE_ATK3] = PLAYER_SKILL_ATK3;
	self.playerStateToSkillTable[O_STATE_ATK4] = PLAYER_SKILL_ATK4;
	self.playerStateToSkillTable[O_STATE_ATK5] = PLAYER_SKILL_ATK5;
	self.playerStateToSkillTable[O_STATE_ATK6] = PLAYER_SKILL_ATK6;
	self.playerStateToSkillTable[O_STATE_ATK7] = PLAYER_SKILL_ATK7;
	
	self:RegisterPlayerSkill(SkillNode_ATK1.create(),PLAYER_SKILL_ATK1,"atk1");
	self:RegisterPlayerSkill(SkillNode_ATK2.create(),PLAYER_SKILL_ATK2,"atk2");
	self:RegisterPlayerSkill(SkillNode_ATK3.create(),PLAYER_SKILL_ATK3,"atk3");
	self:RegisterPlayerSkill(SkillNode_ATK4.create(),PLAYER_SKILL_ATK4,"atk4");
	self:RegisterPlayerSkill(SkillNode_ATK5.create(),PLAYER_SKILL_ATK5,"atk5");
	self:RegisterPlayerSkill(SkillNode_ATK6.create(),PLAYER_SKILL_ATK6,"atk6");
	--self:RegisterPlayerSkill(SkillNode_ATK7.create(),PLAYER_SKILL_ATK7,"atk7");
	self:RegisterMonsterSkill(SkillNode_Mons1.create(),MONSTER_SKILL_1,"mons1")
end

function SkillManager:GetChecked(playerstate)
	prints("SkillManager:GetChecked")
	local sk = self.skillsTable[self.playerStateToSkillTable[playerstate]];
	if (sk.mpneed > self.player.Mp) then
		return false;
	else
		return true;
	end
end

function SkillManager:PlayerExecuteSkill(skillType,map)
	prints("SkillManager:PlayerExecuteSkill")
	local sk=self.skillsTable[skillType];
	if sk==nil then
		return false;
	end
	local mp=sk.mpneed;
	if mp< self.player.Mp then
		self.player:ChangeMp(self.player.Mp-mp);
		sk:setPosition(cc.p(self.player:getPosition()));
		sk.startPosition=cc.p(self.player:getPosition());
		sk.isforward=not(self.player:isFlippedX());
		self:AddOrShow(map,sk);
		sk:Start();
		return true;
	else
		return false;
	end
end

function SkillManager:MonsterExecuteSkill(mon, skillType,map)
	prints("SkillManager:MonsterExecuteSkill")
	local sk=self.skillsTable[skillType];
	if sk==nil then
		return false;
	end
	sk.startPosition=cc.p(mon:getPosition());
	sk:setPosition(cc.p(mon:getPosition()));
	sk.isforward=not(mon.sprite:isFlippedX());
	self:AddOrShow(map, sk);
	sk:Start();
	return true;
end

function SkillManager:PlayerCalculateDamage(skill)
	prints("SkillManager:PlayerCalculateDamage")
	skill.startPosition=cc.p(skill:getPosition());
	for i=1,#self.monsters do
		if(self.monsters[i]~=nil) then
			local posX,posY=(self.monsters[i]):getPosition()
			local id=self.monsters[i].id;
			local ret=skill:IsSkillRangeCover(cc.p(posX,posY))
			if ret then
				if skill.oncelocked then
					if(skill.lockedTable[id]==nil) then
						skill.lockedTable[id]=true;
						prints(string.format("%d locked",id));
						local hp=self.monsters[i].curHp;
						self.monsters[i]:ChangeHp(hp - skill:GetDamage(), 0);
					end
				else
					local hp=self.monsters[i].curHp;
					local rebtype=1;
					if skill:getName()~="atk5" then
						rebtype=0; 
					end
					self.monsters[i]:ChangeHp(hp - skill:GetDamage(), rebtype);
					skill:ShowDamage(self.monsters[i],i);
				end
			end
		end
	end
end

function SkillManager:MonsterCalculateDamage(skill)
	prints("SkillManager:MonsterCalculateDamage")
	if self.player.curOState==O_STATE_DEAD then
		return;
	end
	if self.player.Hp==0 then
		return;
	end
	if(self==nil or self.player==nil) then
		return;
	end
	pcall(function() 
		local pos=cc.p(self.player:getPosition());
		if skill:IsSkillRangeCover(pos) then
			local hp=skill:GetDamage();
			self.player:ChangeHp(self.player.Hp-hp);
		end
	end)
	
	
end

function SkillManager:AddOrShow(map,sk)
	prints("SkillManager:AddOrShow")
	if map:getChildByName(sk:getName()) == nil then
		map:addChild(sk);
		sk:setGlobalZOrder(11);
		sk:setVisible(true);
	else
		sk:setVisible(true);
	end
end

function SkillManager:RegisterPlayerSkill(atk,key,name)
	prints("SkillManager:RegisterPlayerSkill")
	atk:retain();
	atk:setName(name);
	atk.SkillEnd=function(sk)
		sk:removeFromParent();
	end;
	atk.ExecuteDamage=function(sk)
		self:PlayerCalculateDamage(sk);
	end
	self.skillsTable[key]=atk;
end

function SkillManager:RegisterMonsterSkill(atk,key,name)
	prints("SkillManager:RegisterMonsterSkill")
	atk:retain();
	atk:setName(name);
	atk.SkillEnd=function(sk)
		sk:removeFromParent();
	end;
	atk.ExecuteDamage=function(sk)
		self:MonsterCalculateDamage(sk);
	end
	self.skillsTable[key]=atk;	
end