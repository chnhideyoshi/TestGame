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
	print("SkillManager:RegisterAllSkills")
--[[	
		RegisterPlayerSkill(Skill_ATK1::create(), PLAYER_SKILL_ATK1, "atk1");
		RegisterPlayerSkill(Skill_ATK2::create(), PLAYER_SKILL_ATK2, "atk2");
		RegisterPlayerSkill(Skill_ATK3::create(), PLAYER_SKILL_ATK3, "atk3");
		RegisterPlayerSkill(Skill_ATK4::create(), PLAYER_SKILL_ATK4, "atk4");
		RegisterPlayerSkill(Skill_ATK5::create(), PLAYER_SKILL_ATK5, "atk5");
		RegisterPlayerSkill(Skill_ATK6::create(), PLAYER_SKILL_ATK6,"atk6");
		RegisterPlayerSkill(Skill_ATK7::create(), PLAYER_SKILL_ATK7, "atk7");
		RegisterMonsterSkill(Skill_Mons1::create(), MONSTER_SKILL_1,"mons1");--]]
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
	
end

function SkillManager:GetChecked(playerstate)
	print("SkillManager:GetChecked")
	
end

function SkillManager:PlayerExecuteSkill(skillType,map)
	print("SkillManager:PlayerExecuteSkill")
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
	print("SkillManager:MonsterExecuteSkill")
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
	print("SkillManager:PlayerCalculateDamage")
	for i=1,#self.monsters do
		local monrec=self.monsters[i]:getBoundingBox();
		if skill:IsSkillRangeCover(cc.p(self.monsters[i]:getPosition())) then
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

function SkillManager:MonsterCalculateDamage(skill)
	print("SkillManager:MonsterCalculateDamage")
	if self.player.curOState==O_STATE_DEAD then
		return;
	end
	if skill:IsSkillRangeCover(cc.p(self.player:getPosition())) then
		local hp=skill:GetDamage();
		self.player:ChangeHp(self.player.Hp-hp);
	end
	
end

function SkillManager:AddOrShow(map,sk)
	print("SkillManager:AddOrShow")
	if map:getChildByName(sk:getName()) == nil then
		map:addChild(sk);
		sk:setGlobalZOrder(11);
		sk:setVisible(true);
	else
		sk:setVisible(true);
	end
end

function SkillManager:RegisterPlayerSkill(atk,key,name)
	print("SkillManager:RegisterPlayerSkill")
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
	print("SkillManager:RegisterMonsterSkill")
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