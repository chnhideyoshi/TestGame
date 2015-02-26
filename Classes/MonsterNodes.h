#ifndef MONSTERNODES_H
#define MONSTERNODES_H
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"
#include "MyUtils.h"
#include "MainLayer.h"

USING_NS_CC;
USING_NS_CC::ui;
using namespace cocostudio::timeline;

class FlowWord : public Node 
{
public:
	CREATE_FUNC(FlowWord);
	virtual bool init()
	{
		m_textLab = Label::create("", "Arial", 35);
		m_textLab->setColor(ccc3(255, 215, 0));
		m_textLab->setAnchorPoint(ccp(0.5,0.5));
		m_textLab->setVisible(false);
		m_textLab->setPosition(0, 100);
		this->addChild(m_textLab);
		return true;
	}

public:
	void showWord(const char* text)
	{
		m_textLab->setString(text);
		m_textLab->setVisible(true);
		auto scaleLarge = ScaleTo::create(0.3f, 2.2f, 2.2f);
		auto scaleSmall = ScaleTo::create(0.5f, 0.5f, 0.5f);
		auto callFunc = CallFunc::create([&]()
		{
			m_textLab->setVisible(false);
		});
		auto actions = Sequence::create(scaleLarge, scaleSmall, callFunc, NULL);
		m_textLab->runAction(actions);
	}
private:
	Label* m_textLab;
};

typedef enum {
	ACTION_STATE_NONE = 0,
	ACTION_STATE_IDLE,
	ACTION_STATE_WALK,
	ACTION_STATE_ATTACK,
	ACTION_STATE_HURT,
	ACTION_STATE_DEAD,
	ACTION_STATE_REMOVE,
}ActionState;

class MonsterNode:public Node
{
public:
	MonsterNode() :
		m_pIdleAction(NULL),
		m_pAttackAction(NULL),
		m_pHurtAction(NULL),
		m_pDeadAction(NULL)
	{}
	~MonsterNode()
	{
		CC_SAFE_RELEASE_NULL(m_pIdleAction);
		CC_SAFE_RELEASE_NULL(m_pAttackAction);
		CC_SAFE_RELEASE_NULL(m_pHurtAction);
		CC_SAFE_RELEASE_NULL(m_pDeadAction);
	}
	CREATE_FUNC(MonsterNode);
	virtual bool init()
	{
		if (!Node::init())
		{
			return false;
		}
		this->InitDefaultParms();
		this->InitComponents();
		this->InitAnimations();
		this->InitEventHandlers();
		this->scheduleUpdate();
		return true;
	}	
	virtual void SetEnableTargetSeeking(bool enable)
	{
		this->enableTargetSeeking = enable;
	}
	virtual void SetTargetNode(Node* target)
	{
		this->target = target;
	}
	virtual void ChangeHp(int hp)
	{
		if (hp < 0)
			hp = 0;
		if (hp>maxHp)
			hp = maxHp;
		if (hp < curHp)
		{
			if (hp != 0)
			{
				Rebound(curHp-hp);
				StartHurt();
				GetFlowWord()->showWord(Value(hp - curHp).asString().c_str());
			}
			else
			{
				StartDead();
			}
		}
		this->SetHp(hp);
	}
	virtual bool IsForward()
	{
		return !GetMonsterSprite()->isFlippedX();
	}
	virtual int GetHp()
	{
		return curHp;
	}
	virtual void update(float delta)
	{
		if (enableTargetSeeking&&!inATK)
		{
			CheckFilp();
			MarchingToTargetPerFrame();
		}
		if (ConditionMeets_ATK())
		{
			StartATK();
			cumlativeTime_ATK = 0;
		}
		else
		{
			cumlativeTime_ATK += delta;
		}
	}
	std::function<void(MonsterNode*)> onDead;
	std::function<void(MonsterNode*)> onAttak;
public:
	virtual Sprite* GetMonsterSprite()
	{
		return (Sprite*)rootNode->getChildByName("sp");
	}
	virtual FlowWord* GetFlowWord()
	{
		return (FlowWord*) this->getChildByName("FLWord");
	}
	virtual LoadingBar* GetHpLoadingBar()
	{
		return (LoadingBar*)rootNode->getChildByName("lb");
	}
	virtual void SetHp(int hp)
	{
		this->curHp = hp;
		LoadingBar* bar = GetHpLoadingBar();
		bar->setPercent(100 * curHp / maxHp);
	}
	virtual void SetMaxHp(int maxHp)
	{
		this->maxHp = maxHp;
	}
	virtual void InitDefaultParms()
	{
		this->maxHp = 10000;
		this->curHp = this->maxHp;
		this->speedrate = 2;
		this->enableTargetSeeking = false;
		this->intervalTime_ATK = 1.5;
		this->cumlativeTime_ATK = this->intervalTime_ATK;
		this->inATK = false;
	}
	virtual void InitComponents()
	{
	
	}
	virtual void InitAnimations()
	{
		
	}
	virtual void InitEventHandlers()
	{
		auto listenerKeyboard = EventListenerKeyboard::create();
		listenerKeyboard->onKeyPressed = CC_CALLBACK_2(MonsterNode::onKeyPressed, this);
		_eventDispatcher->addEventListenerWithSceneGraphPriority(listenerKeyboard, this);
	}
	virtual void onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event)
	{
		if (keyCode == EventKeyboard::KeyCode::KEY_P)
		{
			StartATK();
		}
	}
	virtual bool ChangeState(ActionState actionState)
	{
		if ((m_currActionState == ACTION_STATE_DEAD && actionState != ACTION_STATE_REMOVE) || m_currActionState == actionState)
		{
			return false;
		}
		inATK = false;
		GetMonsterSprite()->stopAllActions();
		this->m_currActionState = actionState;
		if (actionState == ACTION_STATE_REMOVE)
			return false;
		else
			return true;
	}
	virtual void BecomeStand()
	{
		if (ChangeState(ACTION_STATE_IDLE))
		{
			Sprite* mon = GetMonsterSprite();
			mon->runAction(m_pIdleAction);
		}
	}
	virtual void StartATK()
	{
		if (ChangeState(ACTION_STATE_ATTACK))
		{
			Sprite* mon = GetMonsterSprite();
			inATK = true;
			mon->runAction(m_pAttackAction);
			if (onAttak != NULL)
				onAttak(this);
		}
	}
	virtual void onEndATK()
	{
		BecomeStand();
	}
	virtual void StartHurt()
	{
		if (ChangeState(ACTION_STATE_HURT))
		{
			Sprite* mon = GetMonsterSprite();
			inATK = true;
			mon->runAction(m_pHurtAction);
		}
	}
	virtual void onEndHurt()
	{
		BecomeStand();
	}
	virtual void StartDead()
	{
		if (ChangeState(ACTION_STATE_DEAD))
		{
			Sprite* mon = GetMonsterSprite();
			inATK = true;
			mon->runAction(m_pDeadAction);
		}
	}
	virtual void onEndDead()
	{
		if (onDead != NULL)
			onDead(this);
	}
	virtual void MarchingToTargetPerFrame()
	{
		Point pos = getPosition();
		Point tpos = target->getPosition();
		Vec2 delta = tpos - pos;
		curDirection = delta.getNormalized();
		if (delta.length() > speedrate)
		{
			pos += curDirection*speedrate;
			setPosition(pos);
		}
		else
			setPosition(tpos);
	}
	virtual void CheckFilp()
	{
		bool isOnTargetLeft = (getPositionX() < target->getPositionX() ? true : false);
		GetMonsterSprite()->setFlippedX(!isOnTargetLeft);
	}
	virtual void Rebound(int deltaHp)
	{
		this->stopAllActions();
		float leng = deltaHp/10;
		Point t = target->getPosition();
		Point p = this->getPosition();
		float len = t.distance(p);
		Vec2 delta((p.x - t.x)*leng / len, (p.y - t.y)*leng / len);
		this->runAction(MoveBy::create(0.1f, Point(delta.x, delta.y)));
	}
	virtual bool IsInmove()
	{
		return abs(curDirection.getLength()) > MATH_FLOAT_SMALL;
	}
	virtual bool ConditionMeets_ATK()
	{
		if (m_currActionState == ACTION_STATE_DEAD)
			return false;
		if (cumlativeTime_ATK > intervalTime_ATK)
		{
			Vec2 delta = target->getPosition() - getPosition();
			if (delta.length() < 30)
			{
				return true;
			}
			return false;
		}
		else
		{
			return false;
		}
	}
protected:
	CC_SYNTHESIZE_RETAIN(Action*, m_pIdleAction, IdleAction);
	CC_SYNTHESIZE_RETAIN(Action*, m_pAttackAction, AttackAction);
	CC_SYNTHESIZE_RETAIN(Action*, m_pHurtAction, HurtAction);
	CC_SYNTHESIZE_RETAIN(Action*, m_pDeadAction, DeadAction);
	CC_SYNTHESIZE(ActionState, m_currActionState, CurrActionState);
	Node* rootNode;
	int maxHp;
	int curHp;
	Vec2 curDirection;
	bool enableTargetSeeking;
	Node* target;
	bool inATK;
	float speedrate;
	float intervalTime_ATK;
	float cumlativeTime_ATK;
};

class Monster_1 :public MonsterNode
{
public:
	Monster_1(){}
	~Monster_1(){}
	CREATE_FUNC(Monster_1);
protected:
	virtual void InitDefaultParms()
	{
		MonsterNode::InitDefaultParms();
		this->speedrate = 1;
	}
	virtual void InitComponents()
	{
		MonsterNode::InitComponents();
		rootNode = Node::create();
		Sprite* sp = Sprite::create("Mons//mons1d.png");
		sp->setContentSize(Size(88, 101));
		sp->setName("sp");
		sp->setAnchorPoint(ccp(0.5, 0.5));
		rootNode->addChild(sp);
		LoadingBar* lb = LoadingBar::create();
		lb->setSize(Size(100, 10));
		lb->setPercent(100);
		lb->setPosition(ccp(0, 61));
		lb->setScaleX(0.6);
		lb->setScaleY(0.44);
		lb->setAnchorPoint(ccp(0.5, 0.5));
		lb->loadTexture("Mons/hps.png");
		lb->setName("lb");
		rootNode->addChild(lb);
		rootNode->setAnchorPoint(Point(0.5, 0.5));
		rootNode->setPosition(0, 0);
		this->addChild(rootNode);
		FlowWord* fl = FlowWord::create();
		fl->setName("FLWord");
		fl->setPosition(0, 0);
		this->addChild(fl);
#if TEST
		Tools::CreateRectPanel(GetMonsterSprite()->getBoundingBox(), Color3B(0, 255, 0), 30, this);
#endif
	}
	virtual void InitAnimations()
	{
		SpriteFrameCache* frameCache = SpriteFrameCache::getInstance();
		frameCache->addSpriteFramesWithFile("Mons\\mons1.plist", "Mons\\mons1.png");
		Animation* pIdleAnim = Tools::createWithSingleFrameName("mons1_", 0.2f, 1);
		this->setIdleAction(RepeatForever::create(Animate::create(pIdleAnim)));

		Animation *pAttackAnim = Tools::createWithSingleFrameName("mons2_", 0.2f, 1);
		this->setAttackAction(Sequence::create(Animate::create(pAttackAnim), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndATK)), NULL));

		Animation *pHurtAnim = Tools::createWithFrameNameAndNum("mons4_", 2, 0.2f, 1);
		this->setHurtAction(Sequence::create(Animate::create(pHurtAnim), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndHurt)), NULL));

		Animation *pDeadAnim = Tools::createWithSingleFrameName("mons4_", 0.2f, 1);
		this->setDeadAction(Sequence::create(Animate::create(pDeadAnim), Blink::create(3, 9), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndDead)), NULL));

		this->BecomeStand();
	}
private:
};

class Monster_2:public MonsterNode
{
public:
	Monster_2(){}
	~Monster_2(){}
	CREATE_FUNC(Monster_2);
protected:
	virtual void InitDefaultParms()
	{
		MonsterNode::InitDefaultParms();
		speedrate = 0.5;
	}
	virtual void InitComponents()
	{
		MonsterNode::InitComponents();
		rootNode = Node::create();
		Sprite* sp = Sprite::create("Mons//mons2d.png");
		sp->setContentSize(Size(88, 101));
		sp->setName("sp");
		sp->setAnchorPoint(ccp(0.5, 0.5));
		rootNode->addChild(sp);
		LoadingBar* lb = LoadingBar::create();
		lb->setSize(Size(100, 10));
		lb->setPercent(100);
		lb->setPosition(ccp(0, 61));
		lb->setScaleX(0.6);
		lb->setScaleY(0.44);
		lb->setAnchorPoint(ccp(0.5, 0.5));
		lb->loadTexture("Mons/hps.png");
		lb->setName("lb");
		rootNode->addChild(lb);
		rootNode->setAnchorPoint(Point(0.5, 0.5));
		rootNode->setPosition(0, 0);
		this->addChild(rootNode);
		FlowWord* fl = FlowWord::create();
		fl->setName("FLWord");
		fl->setPosition(0, 0);
		this->addChild(fl);
#if TEST
		Tools::CreateRectPanel(GetMonsterSprite()->getBoundingBox(), Color3B(0, 255, 0), 30, this);
#endif
	}
	virtual void InitAnimations()
	{
		SpriteFrameCache* frameCache = SpriteFrameCache::getInstance();
		frameCache->addSpriteFramesWithFile("Mons\\mons2.plist", "Mons\\mons2.png");
		Animation* pIdleAnim = Tools::createWithSingleFrameName("mons2_stand_", 0.2f, 1);
		this->setIdleAction(RepeatForever::create(Animate::create(pIdleAnim)));

		Animation *pAttackAnim = Tools::createWithSingleFrameName("mons2_atk_", 0.2f, 1);
		this->setAttackAction(Sequence::create(Animate::create(pAttackAnim), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndATK)), NULL));

		Animation *pHurtAnim = Tools::createWithFrameNameAndNum("mons2_dead_", 2, 0.2f, 1);
		this->setHurtAction(Sequence::create(Animate::create(pHurtAnim), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndHurt)), NULL));

		Animation *pDeadAnim = Tools::createWithSingleFrameName("mons2_dead_", 0.2f, 1);
		this->setDeadAction(Sequence::create(Animate::create(pDeadAnim), Blink::create(3, 9), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndDead)), NULL));

		this->BecomeStand();
	}
private:
};

class Monster_3 :public MonsterNode
{
public:
	Monster_3(){}
	~Monster_3(){}
	CREATE_FUNC(Monster_3);
protected:
	virtual void InitDefaultParms()
	{
		MonsterNode::InitDefaultParms();
		speedrate = 1.5;
	}
	virtual void InitComponents()
	{
		MonsterNode::InitComponents();
		rootNode = Node::create();
		Sprite* sp = Sprite::create("Mons//mons3d.png");
		sp->setContentSize(Size(88, 101));
		sp->setName("sp");
		sp->setAnchorPoint(ccp(0.5, 0.5));
		rootNode->addChild(sp);
		LoadingBar* lb = LoadingBar::create();
		lb->setSize(Size(100, 10));
		lb->setPercent(100);
		lb->setPosition(ccp(0, 61));
		lb->setScaleX(0.6);
		lb->setScaleY(0.44);
		lb->setAnchorPoint(ccp(0.5, 0.5));
		lb->loadTexture("Mons/hps.png");
		lb->setName("lb");
		rootNode->addChild(lb);
		rootNode->setAnchorPoint(Point(0.5, 0.5));
		rootNode->setPosition(0, 0);
		this->addChild(rootNode);
		FlowWord* fl = FlowWord::create();
		fl->setName("FLWord");
		fl->setPosition(0, 0);
		this->addChild(fl);
#if TEST
		Tools::CreateRectPanel(GetMonsterSprite()->getBoundingBox(), Color3B(0, 255, 0), 30, this);
#endif
	}
	virtual void InitAnimations()
	{
		SpriteFrameCache* frameCache = SpriteFrameCache::getInstance();
		frameCache->addSpriteFramesWithFile("Mons\\mons3.plist", "Mons\\mons3.png");
		Animation* pIdleAnim = Tools::createWithSingleFrameName("Mons3_atk_", 0.2f, 1);
		this->setIdleAction(RepeatForever::create(Animate::create(pIdleAnim)));

		Animation *pAttackAnim = Tools::createWithSingleFrameName("Mons3_stand_", 0.2f, 1);
		this->setAttackAction(Sequence::create(Animate::create(pAttackAnim), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndATK)), NULL));

		Animation* pHurtAnim = Tools::createWithSingleFrameName("Mons3_atk_", 0.2f, 1);
		this->setHurtAction(Sequence::create(Animate::create(pHurtAnim), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndHurt)), NULL));

		Animation *pDeadAnim = Tools::createWithSingleFrameName("Mons3_atk_", 0.2f, 1);
		this->setDeadAction(Sequence::create(Animate::create(pDeadAnim), Blink::create(3, 9), CallFunc::create(this, SEL_CallFunc(&MonsterNode::onEndDead)), NULL));

		this->BecomeStand();
	}
private:
};







#endif