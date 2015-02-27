#ifndef SKILLNODES_H
#define SKILLNODES_H
#include "PlayerNode.h"

class Skill :public Node
{
public:
	virtual bool init()
	{
		if (!Node::init())
		{
			return false;
		}
		InitParams();
		return true;
	}
	virtual void Start()
	{
		this->scheduleOnce(SEL_SCHEDULE(&Skill::onExecuteDamage), executeDelayTime);
	}
	virtual bool IsSkillRangeCover(Rect rect)
	{
		for (size_t i = 0; i < coverRanges.size(); i++)
		{
			Rect actualRec = GetActualRect(coverRanges[i]);
			if (actualRec.intersectsRect(rect))
				return true;
		}
		return false;
	}
	virtual bool IsSkillRangeCover(Point pos)
	{
		for (size_t i = 0; i < coverRanges.size(); i++)
		{
			Rect actualRec = GetActualRect(coverRanges[i]);
			if (actualRec.containsPoint(pos))
				return true;
		}
		return false;
	}
	virtual void ShowDamage(MonsterNode* mon,int index)
	{
		
	}
	virtual void ShowPanel(bool visible)
	{
#if TEST
		if (coverPanels.size() == 0)
		{
			for (size_t i = 0; i < coverRanges.size(); i++)
			{
				Layout* panel = Layout::create();
				panel->setSize(coverRanges[i].size);
				panel->setBackGroundColorType(Layout::BackGroundColorType::SOLID);
				panel->setBackGroundColor(Color3B(255, 0, 0));
				panel->setBackGroundColorOpacity(128);
				panel->setAnchorPoint(ccp(0, 0));
				panel->setVisible(visible);
				if (isfoward)
				{
					panel->setPosition(coverRanges[i].origin);
				}
				else
				{
					panel->setPosition(Vec2(-coverRanges[i].origin.x - coverRanges[i].size.width,coverRanges[i].origin.y));
				}
				coverPanels.push_back(panel);
				this->addChild(panel);
			}
		}
		else
		{
			for (size_t i = 0; i < coverPanels.size(); i++)
			{
				if (isfoward)
				{
					coverPanels[i]->setPosition(coverRanges[i].origin);
				}
				else
				{
					coverPanels[i]->setPosition(Vec2(-coverRanges[i].origin.x - coverRanges[i].size.width, coverRanges[i].origin.y));
				}
				coverPanels[i]->setVisible(visible);
			}
		}
#endif
	}
	virtual void SetMpNeed(int mpneed)
	{
		this->mpneed = mpneed;
	}
	virtual void SetSkillStartPosition(Point start)
	{
		this->startPosition = start;
	}
	virtual void SetIsForward(bool forward)
	{
		this->isforward = forward;
	}
	virtual int GetMpUsed()
	{
		return mpneed;
	}
	virtual int GetDamage()
	{
		return Tools::GetCenterFloatRandom(damage, 0.25f);
	}
	virtual int GetIsForward()
	{
		return isforward;
	}
	CREATE_FUNC(Skill);
	std::function<void(Skill*)> ExecuteDamage;
	std::function<void(Skill*)> SkillEnd;
protected:
	virtual void InitParams()
	{
		this->executeDelayTime = 0;
		this->mpneed = 0;
		this->removeDelayTime = 0;
		this->setAnchorPoint(Point(0, 0));
	}
	virtual void onExecuteDamage(float delta)
	{
		if (ExecuteDamage != NULL)
		{
			ExecuteDamage(this);
		}
		this->scheduleOnce(SEL_SCHEDULE(&Skill::onSkillEnd), removeDelayTime);
	}
	virtual void onSkillEnd(float dt)
	{
		if (SkillEnd != NULL)
			SkillEnd(this);
	}
	Rect GetActualRect(Rect coverTemplate)
	{
		Point or = coverTemplate.origin;
		Size sz = coverTemplate.size;
		if (isforward)
		{
			return Rect(or.x + startPosition.x, or.y + startPosition.y, sz.width, sz.height);
		}
		else
		{
			return Rect(startPosition.x - or.x - sz.width, or.y + startPosition.y, sz.width, sz.height);
		}
	}
	void MovePos(float deltaX, float deltaY)
	{
		Point pos = this->getPosition();
		pos += Vec2(deltaX, deltaY);
		this->setPosition(pos);
	}
protected:
	std::vector<Rect> coverRanges;
	std::vector<Layout*> coverPanels;
	Point startPosition;
	int damage;
	int mpneed;
	bool isforward;
	float removeDelayTime;
	float executeDelayTime;
};

enum SkillTypes
{
	PLAYER_SKILL_ATK1,
	PLAYER_SKILL_ATK2,
	PLAYER_SKILL_ATK3,
	PLAYER_SKILL_ATK4,
	PLAYER_SKILL_ATK5,
	PLAYER_SKILL_ATK6,
	PLAYER_SKILL_ATK7,

	MONSTER_SKILL_1
};

class Skill_ATK1:public Skill
{
public:
	CREATE_FUNC(Skill_ATK1);
protected:
	void InitParams()
	{
		Skill::InitParams();
		coverRanges.push_back(Rect(0, -160, 220, 260));
		executeDelayTime = 0.25f;
		removeDelayTime = 0.1f;
		mpneed = 10;
		damage = 560;
	}
	void onExecuteDamage(float delta)
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hit.wav");
		Skill::onExecuteDamage(delta);
	}
};

class Skill_ATK2 :public Skill
{
public:
	CREATE_FUNC(Skill_ATK2);
	void Start()
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//tiren.wav");
		Skill::Start();
	}
protected:
	void InitParams()
	{
		Skill::InitParams();
		coverRanges.push_back(Rect(0, -170, 140, 180));
		executeDelayTime = 0.25f;
		removeDelayTime = 0;
		mpneed = 11;
		damage = 400;
	}
};

class Skill_ATK3 :public Skill
{
public:
	CREATE_FUNC(Skill_ATK3);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		InitParams();
		return true;
	}
	void Start()
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hit2.wav");
		Skill::Start();
	}
protected:
	void InitParams()
	{
		Skill::InitParams();
		coverRanges.push_back(Rect(0, -100, 200, 220));
		executeDelayTime = 0.55f;
		removeDelayTime = 0;
		mpneed = 11;
		damage = 630;
	}
};

class Skill_ATK4 :public Skill
{
public:
	Skill_ATK4()
	{
		sk_ac = NULL;
	}
	~Skill_ATK4()
	{
		sk_ac->release();
		sk_ac = NULL;
	}
	CREATE_FUNC(Skill_ATK4);
	virtual void Start()
	{
		Skill::Start();
		auto sp1 = (Sprite*)this->getChildByName("sp1");
		sp1->stopAllActions();
		sp1->runAction(sk_ac);
		this->ShowPanel(true);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hit3.wav");
	}
protected:
	void InitParams()
	{
		Skill::InitParams();
		coverRanges.push_back(Rect(-80, -100, 260, 200));
		executeDelayTime = 0.6;
		removeDelayTime = 0;
		mpneed = 200;
		damage = 850;
		Sprite* sp1 = Sprite::create("Skill\\atk4d.png");
		sp1->setAnchorPoint(Point(0.5, 0.5));
		sp1->setPosition(-20, 0);
		sp1->setName("sp1");
		this->addChild(sp1);
		Animation* pATK4 = Tools::createWithSingleFrameName("sk6_", 0.02f, 13);
		this->sk_ac=Sequence::create(DelayTime::create(0.2), Animate::create(pATK4), NULL);
		this->sk_ac->retain();
	}
private:
	Action* sk_ac;
};

class Skill_ATK5 :public Skill
{
public:
	Skill_ATK5() :sk_ac(NULL)
	{

	}
	~Skill_ATK5()
	{
		sk_ac->release();
		sk_ac = NULL;
	}
	CREATE_FUNC(Skill_ATK5);
	void Start()
	{
		Skill::Start();
		auto sp1 = (Sprite*)this->getChildByName("sp1");
		sp1->stopAllActions();
		sp1->setVisible(true);
		sp1->runAction(sk_ac);
		this->ShowPanel(true);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hit3.wav");
	}
	void ShowDamage(MonsterNode* mon, int index)
	{
		Sprite* sp1a = Sprite::create("Skill\\atk5da.png");
		sp1a->setAnchorPoint(Point(0.5, 0.5));
		Point pos = mon->getPosition() - this->getPosition();
		sp1a->setPositionX(pos.x);
		sp1a->setPositionY(pos.y + 50);
		this->addChild(sp1a);
		Animation* pATK5a = Tools::createWithSingleFrameName("sk3_", 0.03f, 1);
		Action* ac = Sequence::create(Animate::create(pATK5a), CallFuncN::create([=](Node* sp)
		{
			sp->removeFromParentAndCleanup(true);
		}), NULL);
		sp1a->runAction(ac);
	}
protected:
	void InitParams()
	{
		Skill::InitParams();
		coverRanges.push_back(Rect(-400, -200, 800, 400));
		executeDelayTime = 0.8f;
		removeDelayTime = 0.5f;
		mpneed = 300;
		damage = 1200;
		Sprite* sp1 = Sprite::create("Skill\\atk5d.png");
		sp1->setAnchorPoint(Point(0.5, 0.5));
		sp1->setName("sp1");
		sp1->setVisible(true);
		sp1->setGlobalZOrder(9);
		this->addChild(sp1);
		Animation* pATK5 = Tools::createWithSingleFrameName("sk1_", 0.05f, 10);
		sk_ac=Sequence::create(DelayTime::create(0), Animate::create(pATK5), CallFuncN::create([&](Node* sp)
		{
			sp->setVisible(false);
		}), NULL);
		sk_ac->retain();
	}
	void onExecuteDamage(float delta)
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//bomb.wav");
		Sprite* sp1 = (Sprite*)this->getChildByName("sp1");
		sp1->setVisible(false);
		Skill::onExecuteDamage(delta);
	}
private:
	Action* sk_ac;
};

class Skill_ATK6 :public Skill
{
public:
	Skill_ATK6() 
	{
		sk_ac = NULL;
		sk_ac1 = NULL;
	}
	~Skill_ATK6()
	{
		sk_ac->release();
		sk_ac = NULL;
		sk_ac1->release();
		sk_ac1 = NULL;
	}
	CREATE_FUNC(Skill_ATK6);
	void Start()
	{
		Skill::Start();
		MovePos(0, -20);
		GetSprite_1()->setVisible(false);
		GetSprite_1r()->setVisible(false);
		Sprite* sp1 = NULL;
		if (isforward)
			sp1 = GetSprite_1();
		else
			sp1 = GetSprite_1r();
		auto sp2 = GetSprite_2();
		sp2->setVisible(true);
		sp1->setVisible(false);
		sp2->stopAllActions();
		sp2->runAction(sk_ac1);
		this->ShowPanel(true);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//thunder.wav");
	}
protected:
	void InitParams()
	{
		Skill::InitParams();
		coverRanges.push_back(Rect(-70, -100, 880, 350));
		executeDelayTime = 2;
		removeDelayTime = 0.5f;
		mpneed = 500;
		damage = 2000;


		Sprite* sp1 = Sprite::create("Skill\\atk6d.png");
		sp1->setAnchorPoint(Point(0.04, 0.5));
		sp1->setPosition(0, 0);
		sp1->setName("sp1");
		sp1->setVisible(false);
		Sprite* sp1r = Sprite::create("Skill\\atk6d.png");
		sp1r->setAnchorPoint(Point(0.96, 0.5));
		sp1r->setPosition(0, 0);
		sp1r->setName("sp1r");
		sp1r->setFlippedX(true);
		sp1r->setVisible(false);
		Animation* pATK6 = Tools::createWithSingleFrameName("atk6_", 0.05f, 15);
		sk_ac=Sequence::create(Animate::create(pATK6), NULL);
		sk_ac->retain();
		Sprite* sp2 = Sprite::create("Skill\\atk7ad.png");
		sp2->setAnchorPoint(Point(0.5, 0.5));
		sp2->setPosition(0, 0);
		sp2->setName("sp2");
		sp2->setVisible(false);

		Animation* pATK6a = Tools::createWithSingleFrameName("atk7a_", 0.1f, 3);
		sk_ac1=Sequence::create(Animate::create(pATK6a), CallFunc::create(this, SEL_CallFunc(&Skill_ATK6::onEnd1Part)), NULL);
		sk_ac1->retain();
		this->addChild(sp2);
		this->addChild(sp1);
		this->addChild(sp1r);

	}	
private:
	Sprite* GetSprite_1()
	{
		return (Sprite*)this->getChildByName("sp1");
	}
	Sprite* GetSprite_1r()
	{
		return (Sprite*)this->getChildByName("sp1r");
	}
	Sprite* GetSprite_2()
	{
		return (Sprite*)this->getChildByName("sp2");
	}
	void onEnd1Part()
	{
		Sprite* sp1 = NULL;
		if (isforward)
			sp1 = GetSprite_1();
		else
			sp1 = GetSprite_1r();
		Sprite* sp2 =GetSprite_2();
		sp2->setVisible(false);
		sp1->setVisible(true);
		sp1->stopAllActions();
		sp1->setScale(1.5, 1.7);
		sp1->runAction(sk_ac);
	}
private:
	Action* sk_ac;
	Action* sk_ac1;
};

class Skill_ATK7 :public Skill
{
public:
	Skill_ATK7()
	{
		sk_ac = NULL;
	}
	~Skill_ATK7()
	{
		sk_ac->release();
		sk_ac = NULL;
	}
	CREATE_FUNC(Skill_ATK7);
	void Start()
	{
		Skill::Start();
		MovePos(50, -50);
		auto sp1 = (Sprite*)this->getChildByName("sp1");
		sp1->stopAllActions();
		sp1->setScale(1, 1);
		sp1->runAction(sk_ac);
		this->ShowPanel(true);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//wind.wav");
	}
protected:
	void InitParams()
	{
		Skill::InitParams();
		coverRanges.push_back(Rect(-50, 0, 255, 160));
		executeDelayTime = 0.5f;
		mpneed = 500;
		damage = 1100;
		Sprite* sp1 = Sprite::create("Skill\\atk7d.png");
		sp1->setAnchorPoint(Point(0.5, 0.5));
		sp1->setPosition(0, 0);
		sp1->setName("sp1");
		this->addChild(sp1);
		Animation* pATK7 = Tools::createWithSingleFrameName("atk7_", 0.1f, 1);
		sk_ac=Sequence::create(Animate::create(pATK7), NULL);
		sk_ac->retain();
	}
private:
	Action* sk_ac;
};

class Skill_Mons1:public Skill
{
public:
	CREATE_FUNC(Skill_Mons1);
protected:
	void InitParams()
	{
		this->coverRanges.push_back(Rect(0, -50, 100, 100));
		this->damage = 800;
		this->executeDelayTime = 0;
		this->removeDelayTime = 0;
	}
};

class SkillManager
{
public:
	SkillManager()
	{
		player = NULL;
		monsters = NULL;
		RegisterAllSkills();
	}
	~SkillManager()
	{
		for (const auto&e : skillsTable)
		{
			e.second->release();
		}
		skillsTable.clear();
	}
	void SetPlayer(PlayerNode* player)
	{
		this->player = player;
	}
	void SetMonsters(std::vector<MonsterNode*>* monsters)
	{
		this->monsters = monsters;
	}
	bool GetChecked(PlayerNode* player, PlayerOnceState skill)
	{
		Skill* sk =skillsTable.at(playerStateToSkillTable[skill]);
		if (sk->GetMpUsed() > player->getMp())
			return false;
		else
		{
			return true;
		}
	}
	bool PlayerExecuteSkill(PlayerNode* player, SkillTypes skillType, Layout* map)
	{
		Skill* sk = skillsTable.at(skillType);
		if (sk == NULL)
			return false;
		int mp=sk->GetMpUsed();
		if (mp < player->getMp())
		{
			player->ChangeMp(player->getMp() - mp);
			sk->setPosition(player->getPosition());
			sk->SetSkillStartPosition(player->getPosition());
			sk->SetIsForward(!player->isFlippedX());
			AddOrShow(map, sk);
			sk->Start();
			return true;
		}
		else
		{
			return false;
		}
	}
	bool MonsterExecuteSkill(MonsterNode* mon, SkillTypes skillType, Layout* map)
	{
		Skill* sk = skillsTable.at(skillType);
		sk->SetSkillStartPosition(mon->getPosition());
		sk->setPosition(mon->getPosition());
		sk->SetIsForward(mon->IsForward());
		AddOrShow(map, sk);
		sk->Start();
		return true;
	}
private:
	void PlayerCalculateDamage(Skill*skill)
	{
		
		for (size_t i = 0; i < monsters->size(); i++)
		{
			Rect monRec = (*monsters)[i]->getBoundingBox();
			if (skill->IsSkillRangeCover((*monsters)[i]->getPosition()))
			{
				int hp = (*monsters)[i]->GetHp();
				int rebtype = skill->getName() == std::string("atk5") ? 1 : 0;
				(*monsters)[i]->ChangeHp(hp - skill->GetDamage(), rebtype);
				skill->ShowDamage((*monsters)[i],i);
			}
		}
	}
	void MonsterCaculteDamage(Skill*skill)
	{
		if (player->GetOnceState() == O_STATE_DEAD)
			return;
		if (skill->IsSkillRangeCover(player->getPosition()))
		{
			int hp = skill->GetDamage();
			player->ChangeHp(player->getHp() - hp);
		}
	}
	void AddOrShow(Layout* map,Skill* sk)
	{
		if (map->getChildByName(sk->getName()) == NULL)
		{
			map->addChild(sk);
			sk->setGlobalZOrder(11);
			sk->setVisible(true);
		}
		else
		{
			sk->setVisible(true);
		}
	}
	void RegisterAllSkills()
	{
		SpriteFrameCache* frameCache = SpriteFrameCache::getInstance();
		frameCache->addSpriteFramesWithFile("Skill\\atk7.plist", "Skill\\atk7.png");
		frameCache->addSpriteFramesWithFile("Skill\\atk6.plist", "Skill\\atk6.png");
		frameCache->addSpriteFramesWithFile("Skill\\atk7a.plist", "Skill\\atk7a.png");
		frameCache->addSpriteFramesWithFile("Skill\\nima.plist", "Skill\\nima.png");

		playerStateToSkillTable.resize(100);
		playerStateToSkillTable[O_STATE_ATK1] = PLAYER_SKILL_ATK1;
		playerStateToSkillTable[O_STATE_ATK2] = PLAYER_SKILL_ATK2;
		playerStateToSkillTable[O_STATE_ATK3] = PLAYER_SKILL_ATK3;
		playerStateToSkillTable[O_STATE_ATK4] = PLAYER_SKILL_ATK4;
		playerStateToSkillTable[O_STATE_ATK5] = PLAYER_SKILL_ATK5;
		playerStateToSkillTable[O_STATE_ATK6] = PLAYER_SKILL_ATK6;
		playerStateToSkillTable[O_STATE_ATK7] = PLAYER_SKILL_ATK7;

		RegisterPlayerSkill(Skill_ATK1::create(), PLAYER_SKILL_ATK1, "atk1");
		RegisterPlayerSkill(Skill_ATK2::create(), PLAYER_SKILL_ATK2, "atk2");
		RegisterPlayerSkill(Skill_ATK3::create(), PLAYER_SKILL_ATK3, "atk3");
		RegisterPlayerSkill(Skill_ATK4::create(), PLAYER_SKILL_ATK4, "atk4");
		RegisterPlayerSkill(Skill_ATK5::create(), PLAYER_SKILL_ATK5, "atk5");
		RegisterPlayerSkill(Skill_ATK6::create(), PLAYER_SKILL_ATK6,"atk6");
		RegisterPlayerSkill(Skill_ATK7::create(), PLAYER_SKILL_ATK7, "atk7");
		RegisterMonsterSkill(Skill_Mons1::create(), MONSTER_SKILL_1,"mons1");
	}
	void RegisterPlayerSkill(Skill* atk, SkillTypes key,std::string name)
	{
		atk->retain();
		atk->setName(name);
		atk->SkillEnd = [&](Skill* sk){sk->removeFromParent(); };
		atk->ExecuteDamage = [&](Skill* sk)
		{
			PlayerCalculateDamage(sk);
		};
		skillsTable.insert(key, atk);
	}
	void RegisterMonsterSkill(Skill* sk, SkillTypes key, std::string name)
	{
		sk->retain();
		sk->setName(name);
		sk->SkillEnd = [&](Skill* sk1){sk1->removeFromParent(); };
		sk->ExecuteDamage = [&](Skill* sk1)
		{
			MonsterCaculteDamage(sk1);
		};
		skillsTable.insert(key, sk);
	}
private:
	std::vector<SkillTypes> playerStateToSkillTable;
	Map<SkillTypes, Skill*> skillsTable;
	PlayerNode* player;
	std::vector<MonsterNode*>* monsters;
};
#endif