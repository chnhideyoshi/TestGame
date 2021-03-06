#ifndef PLAYERNODES_H
#define PLAYERNODES_H
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"
#include "SimpleAudioEngine.h"
#include "MyUtils.h"
#include "MainLayer.h"

USING_NS_CC;
USING_NS_CC::ui;
enum PlayerOnceState
{
	O_STATE_NONE = 10,
	O_STATE_ATK1,
	O_STATE_ATK2,
	O_STATE_ATK3,
	O_STATE_ATK4,
	O_STATE_ATK5,
	O_STATE_ATK6,
	O_STATE_ATK7,
	O_STATE_HURT,
	O_STATE_DEAD,
	O_STATE_WELOME,
	O_STATE_WIN
};
enum PlayerLastingState
{
	L_STATE_STAND=0,
	L_STATE_FORWARD,
	L_STATE_DEFEND
};
class MainLayer;
class PlayerNode :public Sprite
{
public:
	CREATE_FUNC(PlayerNode);
	PlayerNode() : ac_stand(NULL), ac_forward(NULL), ac_hurt(NULL), ac_dead(NULL), ac_win(NULL), ac_defend(NULL), ac_welcome(NULL),
		ac_atk1(NULL), ac_atk2(NULL), ac_atk3(NULL), ac_atk4(NULL), ac_atk5(NULL), ac_atk6(NULL), ac_atk7(NULL)
	{
	}
	~PlayerNode()
	{
		CC_SAFE_RELEASE_NULL(ac_stand);
		CC_SAFE_RELEASE_NULL(ac_forward);
		CC_SAFE_RELEASE_NULL(ac_atk1);
		CC_SAFE_RELEASE_NULL(ac_atk2);
		CC_SAFE_RELEASE_NULL(ac_atk3);
		CC_SAFE_RELEASE_NULL(ac_atk4);
		CC_SAFE_RELEASE_NULL(ac_atk5);
		CC_SAFE_RELEASE_NULL(ac_atk6);
		CC_SAFE_RELEASE_NULL(ac_atk7);
		CC_SAFE_RELEASE_NULL(ac_welcome);
		CC_SAFE_RELEASE_NULL(ac_win);
		CC_SAFE_RELEASE_NULL(ac_defend);
		CC_SAFE_RELEASE_NULL(ac_hurt);
		CC_SAFE_RELEASE_NULL(ac_dead);
		
	}
	virtual bool init()
	{
		if (!Sprite::init())
		{
			return false;
		}
		this->InitDefaultParms();
		this->InitComponents();
		this->InitEventHandlers();
		this->InitAnimations();
		this->scheduleUpdate();
		return true;
	}
	void CheckLastingStatedChanged()
	{
		bool islastMoving = directionStack[0].x != 0 || directionStack[0].y != 0;
		bool isCurMoving = directionStack[1].x != 0 || directionStack[1].y != 0;
		if (islastMoving&&isCurMoving)
			return;
		if (!islastMoving&&!isCurMoving)
			return;
		if (islastMoving&&!isCurMoving)
			SetLastingState(L_STATE_STAND);
		if (!islastMoving&&isCurMoving)
			SetLastingState(L_STATE_FORWARD);
		
	}
	virtual void update(float delta)
	{
		directionStack[0] = directionStack[1];
		directionStack[1] = curDirection;
		CheckLastingStatedChanged();
		onRecoverMp();
#if TEST
		Rect rect(0, -160, 230, 290);
		Size sz = this->getContentSize();
		sz.width *= 0.5;
		sz.height *= 0.5;
		rect.origin +=sz;
		Tools::CreateRectPanel(rect, Color3B(0, 255, 255), 30, this);
#endif
		
	}
	PlayerLastingState GetLastingState()
	{
		return curLState;
	}
	PlayerOnceState GetOnceState()
	{
		return curOState;
	}
	Point GetCurDirection()
	{
		return curDirection;
	}
	bool GetInMove()
	{
		return curDirection.x != 0 || curDirection.y != 0;
	}
	void SetLastingState(PlayerLastingState state)
	{
		this->curLState = state;
		if (!InOAction())
		{
			if (state == L_STATE_STAND)
				BecomeStand();
			else if (state == L_STATE_FORWARD)
				BecomeForward();
			else
				BecomeDefend();
		}
	}
	void SetOnceState(PlayerOnceState state)
	{
		curOState = state;
		if (state == O_STATE_ATK1)
			StartATK1();
		else if (state == O_STATE_ATK2)
			StartATK2();
		else if (state == O_STATE_ATK3)
			StartATK3();
		else if (state == O_STATE_ATK4)
			StartATK4();
		else if (state == O_STATE_ATK5)
			StartATK5();
		else if (state == O_STATE_ATK6)
			StartATK6();
		else if (state == O_STATE_ATK7)
			StartATK7();
		else if (state == O_STATE_DEAD)
			StartDead();
		else if (state == O_STATE_WELOME)
			StartWelcome();
		else if (state == O_STATE_HURT)
			StartHurt();
		else if (state == O_STATE_WIN)
			StartWin();
		else if (state == O_STATE_NONE)
			stopAllActions();
		else
			return;
	}
	void ChangeHp(int hp)
	{
		if (hp < this->hp)
		{
			if (hp < 0)
				hp = 0;
			this->setHp(hp);
			if (HpChanged != NULL)
				HpChanged(this);
			if (hp == 0)
			{
				if (OnceStateChanged != NULL)
					OnceStateChanged(this, O_STATE_DEAD);
			}
			else
			{
				if (curOState==O_STATE_NONE)
					SetOnceState(O_STATE_HURT);
			}
		}
		else if (hp> this->hp)
		{
			if (hp > maxhp)
				hp = maxhp;
			this->setHp(hp);
			if (HpChanged != NULL)
				HpChanged(this);
		}
	}
	void ChangeMp(int mp)
	{
		if (mp == this->mp)
			return;
		if (mp > maxmp)
			mp = maxmp;
		if (mp < 0)
			mp = 0;
		this->setMp(mp);
		if (MpChanged != NULL)
			MpChanged(this);
	}
	void ShowMessage(std::string msg)
	{
		FlowWord* flow = (FlowWord*)this->getChildByName("flow");
		flow->showWord2(msg.c_str());
	}
public:
	std::function<void(PlayerNode*,PlayerOnceState)> OnceStateChanged;
	std::function<void(PlayerNode*)> HpChanged;
	std::function<void(PlayerNode*)> MpChanged;
	std::function<void(PlayerNode*)> WelcomeEnd;
	std::function<void(PlayerNode*)> WinEnd;
	std::function<void(PlayerNode*)> DeadEnd;
	std::function<bool(PlayerNode*, PlayerOnceState)> ATKReadyChecked;
protected:
	void InitDefaultParms()
	{
		this->curOState = O_STATE_NONE;
		this->curLState = L_STATE_STAND;
		this->speed = 5;
	}
	void InitComponents()
	{
		this->initWithFile("Sprites//reimud.png");
		FlowWord* flow = FlowWord::create();
		flow->setName("flow");
		flow->setAnchorPoint(ccp(0.5, 0.5));
		flow->setPosition(190, 100);
		this->addChild(flow);
	}
	void InitEventHandlers()
	{
		auto listenerKeyboard = EventListenerKeyboard::create();
		listenerKeyboard->onKeyPressed = CC_CALLBACK_2(PlayerNode::onKeyPressed, this);
		listenerKeyboard->onKeyReleased = CC_CALLBACK_2(PlayerNode::onKeyReleased, this);
		_eventDispatcher->addEventListenerWithSceneGraphPriority(listenerKeyboard, this);
	}
	void InitAnimations()
	{
		SpriteFrameCache* frameCache = SpriteFrameCache::getInstance();
		frameCache->addSpriteFramesWithFile("Sprites\\reimu2.plist", "Sprites\\reimu2.png");

		Animation* pStandAnim = Tools::createWithSingleFrameName("reimu_stand_", 0.1f, -1);
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
		this->setDeadAction(Sequence::create(Animate::create(pDeadAnim), Blink::create(3, 9), CallFunc::create(this, SEL_CallFunc(&PlayerNode::onEndDead)), NULL));

	}
	void onRecoverMp()
	{
		if (this->mp < maxmp)
		{
			this->mp += 1;
			if (mp>maxmp)
				mp = maxmp;
			if (MpChanged != NULL)
				MpChanged(this);
		}
	}
private:
	void onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event)
	{
		if (keyCode == EventKeyboard::KeyCode::KEY_Z)
		{
			if (!InOAction() && AttackChecked(O_STATE_ATK1))
			{
				curOState = O_STATE_ATK1;
				StartATK1();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_X)
		{
			if (!InOAction() && AttackChecked(O_STATE_ATK2))
			{
				curOState = O_STATE_ATK2;
				StartATK2();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_C)
		{
			if (!InOAction() && AttackChecked(O_STATE_ATK3))
			{
				curOState = O_STATE_ATK3;
				StartATK3();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_A)
		{
			if (!InOAction() && AttackChecked(O_STATE_ATK4))
			{
				curOState = O_STATE_ATK4;
				StartATK4();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_S)
		{
			if (!InOAction() && AttackChecked(O_STATE_ATK5))
			{
				curOState = O_STATE_ATK5;
				StartATK5();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_D)
		{
			if (!InOAction() && AttackChecked(O_STATE_ATK6))
			{
				curOState = O_STATE_ATK6;
				StartATK6();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_Q)
		{
			if (!InOAction() && AttackChecked(O_STATE_ATK7))
			{
				curOState = O_STATE_ATK7;
				StartATK7();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_H)
		{
			if (!InOAction())
			{
				curOState = O_STATE_HURT;
				StartHurt();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_J)
		{
			if (!InOAction())
			{
				curOState = O_STATE_DEAD;
				StartDead();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_K)
		{
			if (!InOAction())
			{
				curOState = O_STATE_WIN;
				StartWin();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_SPACE)
		{
			isDefend = true;
			SetLastingState(L_STATE_DEFEND);
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_LEFT_ARROW)
		{
			curDirection += Point(-1, 0);
			CheckFlip();
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_RIGHT_ARROW)
		{
			curDirection += Point(1, 0);
			CheckFlip();
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_UP_ARROW)
		{
			curDirection += Point(0, 1);
			CheckFlip();
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_DOWN_ARROW)
		{
			curDirection += Point(0, -1);
			CheckFlip();
			return;
		}
	}
	void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
	{
		if (keyCode == EventKeyboard::KeyCode::KEY_LEFT_ARROW)
		{
			curDirection -= Point(-1, 0);
			CheckFlip();
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_RIGHT_ARROW)
		{
			curDirection -= Point(1, 0);
			CheckFlip();
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_UP_ARROW)
		{
			curDirection -= Point(0, 1);
			CheckFlip();
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_DOWN_ARROW)
		{
			curDirection -= Point(0, -1);
			CheckFlip();
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_SPACE)
		{
			isDefend = false;
			SetLastingState(L_STATE_STAND);
			CheckFlip();
			return;
		}
		CheckFlip();
	}
	void BecomeStand()
	{
		this->stopAllActions();
		this->runAction(ac_stand);
	}
	void BecomeForward()
	{
		this->stopAllActions();
		this->runAction(ac_forward);
	}
	void BecomeDefend()
	{
		this->stopAllActions();
		this->runAction(ac_defend);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//lazer.wav");
	}
	void StartATK1()
	{
		this->stopAllActions();
		this->runAction(ac_atk1);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_ATK1);
		
	}
	void StartATK2()
	{
		this->stopAllActions();
		this->runAction(ac_atk2);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_ATK2);
	}
	void StartATK3()
	{
		this->stopAllActions();
		this->runAction(ac_atk3);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_ATK3);
		
	}
	void StartATK4()
	{
		this->stopAllActions();
		this->runAction(ac_atk4);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_ATK4);
		
	}
	void StartATK5()
	{
		this->stopAllActions();
		this->runAction(ac_atk5);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_ATK5);
		
	}
	void StartATK6()
	{
		this->stopAllActions();
		this->runAction(ac_atk6);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_ATK6);
		
	}
	void StartATK7()
	{
		this->stopAllActions();
		this->runAction(ac_atk7);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_ATK7);
	
	}
	void StartHurt()
	{
		this->stopAllActions();
		this->runAction(ac_hurt);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_HURT);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//hurt.wav");
	}
	void StartDead()
	{
		this->stopAllActions();
		this->runAction(ac_dead);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_DEAD);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//dead.wav");
	}
	void StartWelcome()
	{
		this->stopAllActions();
		this->runAction(ac_welcome);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_WELOME);
		//CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("Sound//dead.wav");
	}
	void StartWin()
	{
		this->stopAllActions();
		this->runAction(ac_win);
		if (OnceStateChanged != NULL)
			OnceStateChanged(this, O_STATE_WIN);
		CocosDenshion::SimpleAudioEngine::getInstance()->playEffect("Sound//win.wav");
	}
	void onEndATK1()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
	}
	void onEndATK2()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
	}
	void onEndATK3()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
	}	
	void onEndATK4()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
	}
	void onEndATK5()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
	}
	void onEndATK6()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
	}
	void onEndATK7()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
	}
	void onEndHurt()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
	}
	void onEndDead()
	{
		curOState = O_STATE_NONE;
		if (DeadEnd != NULL)
			DeadEnd(this);
	}
	void onEndWelcome()
	{
		curOState = O_STATE_NONE;
		onBackToLastingState();
		if (WelcomeEnd != NULL)
			WelcomeEnd(this);
	}
	void onEndWin()
	{
		curOState = O_STATE_NONE;
		if (WinEnd != NULL)
			WinEnd(this);
	}
	void onBackToLastingState()
	{
		CheckFlip();
		if (curLState == L_STATE_STAND)
			BecomeStand();
		else if (curLState == L_STATE_FORWARD)
			BecomeForward();
		else
			BecomeDefend();
	}
	bool InOAction()
	{
		return this->curOState != O_STATE_NONE;
	}
	bool InMove()
	{
		return curDirection.x != 0 || curDirection.y != 0;
	}
	bool IsOnceStateKeyCode(EventKeyboard::KeyCode keycode)
	{
		if (keycode == EventKeyboard::KeyCode::KEY_Z)
			return true;
		if (keycode == EventKeyboard::KeyCode::KEY_X)
			return true;
		if (keycode == EventKeyboard::KeyCode::KEY_C)
			return true;
		if (keycode == EventKeyboard::KeyCode::KEY_A)
			return true;
		if (keycode == EventKeyboard::KeyCode::KEY_S)
			return true;
		if (keycode == EventKeyboard::KeyCode::KEY_D)
			return true;
		if (keycode == EventKeyboard::KeyCode::KEY_Q)
			return true;
		if (keycode == EventKeyboard::KeyCode::KEY_SPACE)
			return true;
		return false;
	}
	bool AttackChecked(PlayerOnceState state)
	{
		if (ATKReadyChecked != NULL)
			return ATKReadyChecked(this, state);
		else
			return true;
	}
	void CheckFlip()
	{
		if (InOAction())
			return;
		if (curDirection.x > 0)
		{
			this->setFlippedX(false);
		}
		else if (curDirection.x < 0)
		{
			this->setFlippedX(true);
		}
	}

private:
	CC_SYNTHESIZE_RETAIN(Action*, ac_stand, StandAction);
	CC_SYNTHESIZE_RETAIN(Action*, ac_forward, ForwardAction);
	CC_SYNTHESIZE_RETAIN(Action*, ac_atk1, ATK1Action);
	CC_SYNTHESIZE_RETAIN(Action*, ac_atk2, ATK2Action);
	CC_SYNTHESIZE_RETAIN(Action*, ac_atk3, ATK3Action);
	CC_SYNTHESIZE_RETAIN(Action*, ac_atk4, ATK4Action);
	CC_SYNTHESIZE_RETAIN(Action*, ac_atk5, ATK5Action);
	CC_SYNTHESIZE_RETAIN(Action*, ac_atk6, ATK6Action);
	CC_SYNTHESIZE_RETAIN(Action*, ac_atk7, ATK7Action);
	CC_SYNTHESIZE_RETAIN(Action*, ac_welcome, WelcomeAction);
	CC_SYNTHESIZE_RETAIN(Action*, ac_win, WinAction);
	CC_SYNTHESIZE_RETAIN(Action*, ac_defend, DefendAction);
	CC_SYNTHESIZE_RETAIN(Action*, ac_hurt, HurtAction);
	CC_SYNTHESIZE_RETAIN(Action*, ac_dead, DeadAction);
	Map<PlayerOnceState, Action*> onceMap;
	PlayerOnceState curOState;
	PlayerLastingState curLState;
	Point directionStack[2];
	Point curDirection;
	bool isDefend;
	CC_SYNTHESIZE(int, hp , Hp);
	CC_SYNTHESIZE(int, mp, Mp);
	CC_SYNTHESIZE(int, maxhp, MaxHp);
	CC_SYNTHESIZE(int, maxmp, MaxMp);
	CC_SYNTHESIZE(int, speed, Speed);
};





#endif