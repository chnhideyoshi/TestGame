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
		this->executeDelay = 0;
		this->mpused = 0;
		this->removeDelay = 0;
		this->setAnchorPoint(Point(0, 0));
		return true;
	}
	virtual void Start()
	{
		this->scheduleOnce(SEL_SCHEDULE(&Skill::ExecuteDamageOnce), executeDelay);
	}
	std::function<void(Skill*)> onExecuteDamage;
	std::function<void(Skill*)> onEnd;
	CREATE_FUNC(Skill);
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
	virtual int GetDamage()
	{
		return Tools::GetCenterFloatRandom(damage, 0.25f);
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
	virtual void ExecuteDamageOnce(float delta)
	{
		if (onExecuteDamage != NULL)
		{
			onExecuteDamage(this);
		}
		this->scheduleOnce(SEL_SCHEDULE(&Skill::End), removeDelay);
	}
	void End(float dt)
	{
		if (onEnd != NULL)
			onEnd(this);
	}
	Rect GetActualRect(Rect coverTemplate)
	{
		Point or = coverTemplate.origin;
		Size sz = coverTemplate.size;
		if (isfoward)
		{
			return Rect(or.x + startPositon.x, or.y + startPositon.y, sz.width, sz.height);
		}
		else
		{
			return Rect(startPositon.x - or.x - sz.width, or.y + startPositon.y, sz.width, sz.height);
		}
	}
	std::vector<Rect> coverRanges;
	std::vector<Layout*> coverPanels;
	int damage;
	CC_SYNTHESIZE(Point, startPositon, StartPosition);
	CC_SYNTHESIZE(float, executeDelay, ExecuteDelay);
	CC_SYNTHESIZE(float, removeDelay, RemoveDelay);
	CC_SYNTHESIZE(bool, isfoward, Isfoward);
	CC_SYNTHESIZE(int, mpused, MpUsed);
};

enum Skills
{
	P_SKILL_ATK1,
	P_SKILL_ATK2,
	P_SKILL_ATK3,
	P_SKILL_ATK4,
	P_SKILL_ATK5,
	P_SKILL_ATK6,
	P_SKILL_ATK7,
	M_SKILL_1
};

class Skill_ATK1:public Skill
{
public:
	Skill_ATK1()
	{
		
	}
	~Skill_ATK1()
	{
	}
	CREATE_FUNC(Skill_ATK1);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		coverRanges.push_back(Rect(0, -160, 220, 260));
		executeDelay = 0.25f;
		removeDelay = 0.1f;
		mpused = 100;
		damage = 800;
		return true;
	}
	virtual void Start()
	{
		Skill::Start();
	}
	void ExecuteDamageOnce(float delta)
	{
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hit.wav");
		Skill::ExecuteDamageOnce(delta);
	}
};

class Skill_ATK2 :public Skill
{
public:
	Skill_ATK2() 
	{

	}
	~Skill_ATK2()
	{
		
	}
	CREATE_FUNC(Skill_ATK2);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		coverRanges.push_back(Rect(0, -170, 140, 180));
		executeDelay = 0.25f;
		removeDelay = 0;
		mpused = 100;
		damage = 600;
		return true;
	}
	virtual void Start()
	{
		Skill::Start();
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//tiren.wav");
	}
};

class Skill_ATK3 :public Skill
{
public:
	Skill_ATK3()
	{

	}
	~Skill_ATK3()
	{

	}
	CREATE_FUNC(Skill_ATK3);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		coverRanges.push_back(Rect(0, -100, 200, 220));
		executeDelay = 0.55f;
		removeDelay = 0;
		mpused = 100;
		damage = 800;
		return true;
	}
	virtual void Start()
	{
		Skill::Start();
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hit2.wav");
	}
};

class Skill_ATK4 :public Skill
{
public:
	Skill_ATK4() :sk_ac(NULL)
	{

	}
	~Skill_ATK4()
	{
		CC_SAFE_RELEASE_NULL(sk_ac);
	}
	CREATE_FUNC(Skill_ATK4);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		coverRanges.push_back(Rect(-80,-100, 260, 200));
		executeDelay = 0.6;
		removeDelay = 0;
		mpused = 100;
		damage = 1200;
		Sprite* sp1 = Sprite::create("Skill\\atk4d.png");
		sp1->setAnchorPoint(Point(0.5, 0.5));
		sp1->setPosition(-20, 0);
		sp1->setName("sp1");
		this->addChild(sp1);

		Animation* pATK4 = Tools::createWithSingleFrameName("sk6_", 0.02f, 13);
		this->setATK4Action(Sequence::create(DelayTime::create(0.2),Animate::create(pATK4), NULL));
		return true;
	}
	virtual void Start()
	{
		Skill::Start();
		auto sp1 = (Sprite*)this->getChildByName("sp1");
		sp1->stopAllActions();
		sp1->runAction(sk_ac);
		this->ShowPanel(true);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hit3.wav");
	}
	CC_SYNTHESIZE_RETAIN(Action*, sk_ac, ATK4Action);
};

class Skill_ATK5 :public Skill
{
public:
	Skill_ATK5() :sk_ac(NULL), sk_aca(NULL)
	{

	}
	~Skill_ATK5()
	{
		CC_SAFE_RELEASE_NULL(sk_ac);
		CC_SAFE_RELEASE_NULL(sk_aca);
	}
	CREATE_FUNC(Skill_ATK5);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		coverRanges.push_back(Rect(-400, -200, 800, 400));
		executeDelay = 1;
		removeDelay = 2;
		mpused = 100;
		damage = 1200;
		Sprite* sp1 = Sprite::create("Skill\\atk5d.png");
		sp1->setAnchorPoint(Point(0.5, 0.5));
		sp1->setName("sp1");
		this->addChild(sp1);
		Animation* pATK5 = Tools::createWithSingleFrameName("sk1_", 0.1f, 1);
		this->setATK5Action(Sequence::create(DelayTime::create(0), Animate::create(pATK5), NULL));

		
		Animation* pATK5a = Tools::createWithSingleFrameName("sk3_", 0.2f, 1);
		Action* ac = Sequence::create(DelayTime::create(0), Animate::create(pATK5a), CallFunc::create(this, SEL_CallFunc(&Skill_ATK5::OnShowEnd)),NULL);
		ac->setTag(999);
		this->setATK5aAction(ac);
		return true;
	}
	virtual void ShowDamage(MonsterNode* mon,int index)
	{
		Sprite* sp1a = Sprite::create("Skill\\atk5da.png");
		sp1a->setAnchorPoint(Point(0.5, 0.5));
		sp1a->setTag(5*index);
		this->addChild(sp1a);
		sp1a->runAction(sk_aca);
	}
	void OnShowEnd()
	{
		Vector<Node*> &sps=this->getChildren();
		for (int i = 0; i < sps.size(); i++)
		{
			Node* node = sps.at(i);
			if (node->getName() != std::string("sp1"))
			{
				Sprite* sp = (Sprite*)node;
				Action* ac = sp->getActionByTag(999);
				if (ac->isDone())
				{
					sp->removeFromParentAndCleanup(true);
				}
			}
		}
	}
	virtual void Start()
	{
		Skill::Start();
		auto sp1 = (Sprite*)this->getChildByName("sp1");
		sp1->stopAllActions();
		sp1->runAction(sk_ac);
		this->ShowPanel(true);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hit3.wav");
	}
	CC_SYNTHESIZE_RETAIN(Action*, sk_ac, ATK5Action);
	CC_SYNTHESIZE_RETAIN(Action*, sk_aca, ATK5aAction);
};

class Skill_ATK6 :public Skill
{
public:
	Skill_ATK6() :sk_ac(NULL),sk_aca(NULL)
	{

	}
	~Skill_ATK6()
	{
		CC_SAFE_RELEASE_NULL(sk_ac);
		CC_SAFE_RELEASE_NULL(sk_aca);
	}
	CREATE_FUNC(Skill_ATK6);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		coverRanges.push_back(Rect(-70, -100,880, 350));
		executeDelay = 2;
		removeDelay = 0.5f;
		mpused = 200;
		damage = 3000;


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
		this->setATK6Action(Sequence::create(Animate::create(pATK6), NULL));

		Sprite* sp2 = Sprite::create("Skill\\atk7ad.png");
		sp2->setAnchorPoint(Point(0.5, 0.5));
		sp2->setPosition(0, 0);
		sp2->setName("sp2");
		sp2->setVisible(false);
		
		Animation* pATK6a = Tools::createWithSingleFrameName("atk7a_", 0.1f, 3);
		this->setATK6aAction(Sequence::create(Animate::create(pATK6a), CallFunc::create(this, SEL_CallFunc(&Skill_ATK6::onEnd1Part)), NULL));

		this->addChild(sp2);
		this->addChild(sp1);
		this->addChild(sp1r);
		

		return true;
	}
	virtual void Start()
	{
		Skill::Start();
		Point pos = this->getPosition();
		pos += Vec2(0, -20);
		this->setPosition(pos); 
		((Sprite*)this->getChildByName("sp1"))->setVisible(false);
		((Sprite*)this->getChildByName("sp1r"))->setVisible(false);
		Sprite* sp1=NULL;
		if (isfoward)
			sp1 = (Sprite*)this->getChildByName("sp1");
		else
			sp1 = (Sprite*)this->getChildByName("sp1r");
		auto sp2 = (Sprite*)this->getChildByName("sp2");
		sp2->setVisible(true);
		sp2->stopAllActions();
		sp2->runAction(sk_aca);
		sp1->setVisible(false);
		this->ShowPanel(true);
		this->scheduleOnce(SEL_SCHEDULE(&Skill_ATK6::ExecuteDamageOnce), executeDelay);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//thunder.wav");
	}
	CC_SYNTHESIZE_RETAIN(Action*, sk_ac, ATK6Action);
	CC_SYNTHESIZE_RETAIN(Action*, sk_aca, ATK6aAction);
	void onEnd1Part()
	{
		Sprite* sp1 = NULL;
		if (isfoward)
			sp1 = (Sprite*)this->getChildByName("sp1");
		else
			sp1 = (Sprite*)this->getChildByName("sp1r");
		auto sp2 = (Sprite*)this->getChildByName("sp2");
		sp2->setVisible(false);
		sp1->setVisible(true);
		sp1->stopAllActions();
		sp1->setScale(1.5, 1.7);
		sp1->runAction(sk_ac);
	}
};

class Skill_ATK7 :public Skill
{
public:
	Skill_ATK7() :sk_ac(NULL)
	{

	}
	~Skill_ATK7()
	{
		CC_SAFE_RELEASE_NULL(sk_ac);
	}
	CREATE_FUNC(Skill_ATK7);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		coverRanges.push_back(Rect(-50,0, 255, 160));
		executeDelay = 0.5f;
		mpused = 200;
		damage = 1500;


		Sprite* sp1 = Sprite::create("Skill\\atk7d.png");
		sp1->setAnchorPoint(Point(0.5, 0.5));
		sp1->setPosition(0, 0);
		sp1->setName("sp1");
		this->addChild(sp1);
		
		Animation* pATK7 = Tools::createWithSingleFrameName("atk7_", 0.1f, 1);
		this->setATK7Action(Sequence::create(Animate::create(pATK7),NULL));
		return true;
	}
	virtual void Start()
	{
		Skill::Start();
		Point pos = this->getPosition();
		pos += Vec2(50,-50);
		this->setPosition(pos);
		auto sp1 = (Sprite*)this->getChildByName("sp1");
		sp1->stopAllActions();
		sp1->setScale(1, 1);
		sp1->runAction(sk_ac);
		this->ShowPanel(true);
		this->scheduleOnce(SEL_SCHEDULE(&Skill_ATK7::ExecuteDamageOnce), executeDelay);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//wind.wav");
	}
	CC_SYNTHESIZE_RETAIN(Action*, sk_ac, ATK7Action);
};

class Skill_Mons1:public Skill
{
public:
	Skill_Mons1(){}
	~Skill_Mons1(){}
	CREATE_FUNC(Skill_Mons1);
	virtual bool init()
	{
		if (!Skill::init())
		{
			return false;
		}
		this->coverRanges.push_back(Rect(0,-50,100,100));
		this->damage = 100;
		this->executeDelay = 0;
		return true;
	}
	virtual void Start()
	{
		Skill::Start();
		ShowPanel(true);
		if (onExecuteDamage != NULL)
			onExecuteDamage(this);
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
		for (const auto&e : skills)
		{
			e.second->release();
		}
		skills.clear();
	}
	void SetPlayer(PlayerNode* player)
	{
		this->player = player;
	}
	void SetMonsters(std::vector<MonsterNode*>* monsters)
	{
		this->monsters = monsters;
	}
	void PlayerExecuteSkill(PlayerNode* player, Skills skillType, Layout* map)
	{
		Skill* sk = skills.at(skillType);
		if (sk == NULL)
			return;
		int mp=sk->getMpUsed();
		if (mp < player->getMp())
		{
			player->ChangeMp(player->getMp() - mp);
			sk->setPosition(player->getPosition());
			sk->setStartPosition(player->getPosition());
			sk->setIsfoward(!player->isFlippedX());
			AddOrShow(map, sk);
			sk->Start();
		}
	}
	void MonsterExecuteSkill(MonsterNode* mon, Skills skillType, Layout* map)
	{
		Skill* sk = skills.at(skillType);
		sk->setStartPosition(mon->getPosition());
		sk->setPosition(mon->getPosition());
		sk->setIsfoward(mon->IsForward());
		AddOrShow(map, sk);
		sk->Start();
	}
	Map<Skills, Skill*> skills;
private:
	void PlayerCalculateDamage(Skill*skill)
	{
		
		for (size_t i = 0; i < monsters->size(); i++)
		{
			Rect monRec = (*monsters)[i]->getBoundingBox();
			if (skill->IsSkillRangeCover((*monsters)[i]->getPosition()))
			{
				int hp = (*monsters)[i]->GetHp();
				(*monsters)[i]->ChangeHp(hp - skill->GetDamage());
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
	PlayerNode* player;
	std::vector<MonsterNode*>* monsters;
	void AddOrShow(Layout* map,Skill* sk)
	{
		if (map->getChildByName(sk->getName()) == NULL)
		{
			map->addChild(sk);
			sk->setZOrder(1);
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

		Skill* atk1 = Skill_ATK1::create();
		atk1->retain();
		atk1->setName("atk1");
		atk1->onEnd = [&](Skill* sk){sk->removeFromParent(); };
		atk1->onExecuteDamage = [&](Skill* sk)
		{
			PlayerCalculateDamage(sk);
		};
		skills.insert(P_SKILL_ATK1, atk1);

		Skill* atk2 = Skill_ATK2::create();
		atk2->retain();
		atk2->setName("atk2");
		atk2->onEnd = [&](Skill* sk){sk->removeFromParent(); };
		atk2->onExecuteDamage = [&](Skill* sk)
		{
			PlayerCalculateDamage(sk);
		};
		skills.insert(P_SKILL_ATK2, atk2);

		Skill* atk3 = Skill_ATK3::create();
		atk3->retain();
		atk3->setName("atk3");
		atk3->onEnd = [&](Skill* sk){sk->removeFromParent(); };
		atk3->onExecuteDamage = [&](Skill* sk)
		{
			PlayerCalculateDamage(sk);
		};
		skills.insert(P_SKILL_ATK3, atk3);

		Skill* atk4 = Skill_ATK4::create();
		atk4->retain();
		atk4->setName("atk4");
		atk4->onEnd = [&](Skill* sk){sk->removeFromParent(); };
		atk4->onExecuteDamage = [&](Skill* sk)
		{
			PlayerCalculateDamage(sk);
		};
		skills.insert(P_SKILL_ATK4, atk4);

		Skill* atk7 = Skill_ATK7::create();
		atk7->retain();
		atk7->setName("atk7");
		atk7->onEnd = [&](Skill* sk){sk->removeFromParent(); };
		atk7->onExecuteDamage = [&](Skill* sk)
		{
			PlayerCalculateDamage(sk);
		};
		skills.insert(P_SKILL_ATK7, atk7);

		Skill* atk6 = Skill_ATK6::create();
		atk6->retain();
		atk6->setName("atk6");
		atk6->onEnd = [&](Skill* sk){sk->removeFromParent(); };
		atk6->onExecuteDamage = [&](Skill* sk)
		{
			PlayerCalculateDamage(sk);
		};
		skills.insert(P_SKILL_ATK6, atk6);

		Skill* mons1 = Skill_Mons1::create();
		mons1->retain();
		mons1->setName("mons1");
		mons1->onEnd = [&](Skill* sk){sk->removeFromParent(); };
		mons1->onExecuteDamage = [&](Skill* sk)
		{
			MonsterCaculteDamage(sk);
		};
		skills.insert(M_SKILL_1, mons1);




	}
};
#endif