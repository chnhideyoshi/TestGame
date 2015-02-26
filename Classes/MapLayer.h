#ifndef MAPLAYER_H
#define MAPLAYER_H

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"
#include "MonsterNodes.h"
#include "PlayerNode.h"
#include "SkillNodes.h"
USING_NS_CC;
USING_NS_CC::ui;
using namespace cocostudio::timeline;

class MapLayer : public cocos2d::Layer
{
public:
	MapLayer(){}
	~MapLayer()
	{
	}
	bool init()
	{
		if (!Layer::init())
		{
			return false;
		}
		this->InitDefaultParms();
		this->InitComponents();
		this->InitPlayer();
		this->InitMonsters();
		this->InitEventHandlers();
		this->InitWatchItems();
		this->scheduleUpdate();
		return true;
	}
	CREATE_FUNC(MapLayer);
	virtual void update(float delta)
	{
		bool inAni = player->GetOnceState() != O_STATE_NONE;
		bool inMove = player->GetInMove();
		if (!inAni)
		{
			if (inMove)
			{
				ManagePlayerMovement();
			}
		}
	}
	std::function<void(bool )> onMapEnd;
private:
	NavigatorLayer* GetNavigator()
	{
		NavigatorLayer* lay = (NavigatorLayer*)this->getChildByName("LY_Navigator");
		return lay;
	}
	Layout* GetMapPanel()
	{
		return (Layout*)Helper::seekWidgetByTag((Widget*)rootNode, 102);
	}
	Sprite* GetPlayerSprite()
	{
		return player;
	}
	Point GetCenter()
	{
		Size visibleSize = Director::getInstance()->getVisibleSize();
		return Point(0.5*visibleSize.width, 0.5*visibleSize.height);
	}
	void InitComponents()
	{
		Size visibleSize = Director::getInstance()->getVisibleSize();
		rootNode = CSLoader::createNode("LY_Map.csb");
		this->addChild(rootNode);
		rootNode->setAnchorPoint(Point(0, 0));
		rootNode->setPosition(0, 0);

		NavigatorLayer *layn = NavigatorLayer::create();
		layn->setName("LY_Navigator");
		this->addChild(layn);
		//CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic("Sound//map1.mp3",true);

	}
	void InitPlayer()
	{
		PlayerNode* player = PlayerNode::create();
		player->setAnchorPoint(ccp(0.5, 0.5));
		player->setPosition(400, 200);
		this->player = player;
		this->skManager.SetPlayer(player);
		GetMapPanel()->addChild(player);
		player->SetOnceState(O_STATE_WELOME);
		player->setMaxHp(10000);
		player->setMaxMp(1000);
		player->setHp(player->getMaxHp());
		player->setMp(0);
		player->setZOrder(1);
		
		GetNavigator()->SetHpValue(player->getHp());
		GetNavigator()->SetMpValue(0);
		GetNavigator()->SetHpPercentage(player->getHp() * 100 / player->getMaxHp());
		GetNavigator()->SetMpPercentage(0);
		player->onMpChanged = [&](PlayerNode* sender)
		{
			GetNavigator()->SetMpValue(sender->getMp());
			GetNavigator()->SetMpPercentage(sender->getMp()*100/sender->getMaxMp());
		};
		player->onHpChanged = [&](PlayerNode* sender)
		{
			GetNavigator()->SetHpValue(sender->getHp());
			GetNavigator()->SetHpPercentage(sender->getHp() * 100 / sender->getMaxHp());
			if (sender->getHp() == 0)
			{
				sender->SetOnceState(O_STATE_DEAD);
			}
		};
		player->onWinEnd = [&](PlayerNode*)
		{
			Win();
		};
		player->onDeadEnd = [&](PlayerNode*)
		{
			Lose();
		};
		player->onWelcomeEnd = [&](PlayerNode*)
		{

		};
		player->onOnceStateChanged = [&](PlayerNode* sender,OnceState newstate)
		{
			if (newstate == O_STATE_ATK1)
			{
				skManager.PlayerExecuteSkill(sender,P_SKILL_ATK1, GetMapPanel());
			}
			if (newstate == O_STATE_ATK2)
			{
				skManager.PlayerExecuteSkill(sender, P_SKILL_ATK2, GetMapPanel());
			}
			if (newstate == O_STATE_ATK3)
			{
				skManager.PlayerExecuteSkill(sender, P_SKILL_ATK3, GetMapPanel());
			}
			if (newstate == O_STATE_ATK4)
			{
				skManager.PlayerExecuteSkill(sender, P_SKILL_ATK4, GetMapPanel());
			}
			if (newstate == O_STATE_ATK5)
			{
				skManager.PlayerExecuteSkill(sender, P_SKILL_ATK5, GetMapPanel());
			}
			if (newstate == O_STATE_ATK6)
			{
				skManager.PlayerExecuteSkill(sender, P_SKILL_ATK6, GetMapPanel());
			}
			if (newstate == O_STATE_ATK7)
			{
				skManager.PlayerExecuteSkill(sender, P_SKILL_ATK7, GetMapPanel());
			}
		};
	}
	void InitMonsters()
	{
		int count =3;
		std::vector<Point> vec;
		Size sz = this->GetMapPanel()->getContentSize();
		Tools::GetRandPointsInRect(1, movementYBound[0], sz.width - 1, movementYBound[1]-100, count, vec);
		for (int i = 0; i < count; i++)
		{
			MonsterNode* mon;
			mon = CreateMonster(i%3);
			mon->setPosition(vec[i]);
			GetMapPanel()->addChild(mon);
			monsters.push_back(mon);
		}
		this->skManager.SetMonsters(&monsters);
	}
	MonsterNode* CreateMonster(int type)
	{
		MonsterNode* monster;
		if (type==0)
			monster = Monster_1::create();
		else if (type==1)
			monster = Monster_2::create();
		else
			monster = Monster_3::create();
		monster->setAnchorPoint(ccp(0.5, 0.5));
		monster->SetEnableTargetSeeking(true);
		monster->SetTargetNode(this->GetPlayerSprite());
		monster->onAttak = [&](MonsterNode* mon)
		{
			skManager.MonsterExecuteSkill(mon, M_SKILL_1, GetMapPanel());
		};
		monster->onDead = [&](MonsterNode* mon)
		{
			for (size_t i = 0; i < monsters.size(); i++)
			{
				if (mon == monsters[i])
				{
					monsters[i] = monsters[monsters.size() - 1];
					monsters.pop_back();
					break;
				}
			}
			mon->removeFromParent();
			if (monsters.size() == 0)
			{
				player->SetOnceState(O_STATE_WIN);
			}
		};
		return monster;
	}
	void InitEventHandlers()
	{
	}
	void InitDefaultParms()
	{
		movementYBound[0] = 80;
		movementYBound[1] = 323;
		movementXOffsetThreshold = 200;
	}
	void InitWatchItems()
	{
		ConsoleLayer::GetConsoleInstance()->AddWatchingValue("curLState", Value("default"), "curLState");
		NotificationCenter::getInstance()->addObserver(this, SEL_CallFuncO(&MapLayer::onWatch_curLState), "curLState", NULL);

		ConsoleLayer::GetConsoleInstance()->AddWatchingValue("curOState", Value("default"), "curOState");
		NotificationCenter::getInstance()->addObserver(this, SEL_CallFuncO(&MapLayer::onWatch_curOState), "curOState", NULL);

		ConsoleLayer::GetConsoleInstance()->AddWatchingValue("curPos", Value("default"), "curPos");
		NotificationCenter::getInstance()->addObserver(this, SEL_CallFuncO(&MapLayer::onWatch_curPos), "curPos", NULL);

		ConsoleLayer::GetConsoleInstance()->AddWatchingValue("flipedX", Value("default"), "flipedX");
		NotificationCenter::getInstance()->addObserver(this, SEL_CallFuncO(&MapLayer::onWatch_flipedX), "flipedX", NULL);

		ConsoleLayer::GetConsoleInstance()->AddWatchingValue("monPos", Value("default"), "monPos");
		NotificationCenter::getInstance()->addObserver(this, SEL_CallFuncO(&MapLayer::onWatch_monPos), "monPos", NULL);

		ConsoleLayer::GetConsoleInstance()->AddWatchingValue("skillPos", Value("default"), "skillPos");
		NotificationCenter::getInstance()->addObserver(this, SEL_CallFuncO(&MapLayer::onWatch_skillPos), "skillPos", NULL);
	}
	void onWatch_curLState(Ref* sender)
	{
		WatchItem* item = (WatchItem*)sender; item->value = Value(StringUtils::format("[%d]", player->GetLastingState()));
	}
	void onWatch_curOState(Ref* sender)
	{
		WatchItem* item = (WatchItem*)sender; item->value = Value(StringUtils::format("[%d]", player->GetOnceState()));
	}
	void onWatch_curPos(Ref* sender)
	{
		WatchItem* item = (WatchItem*)sender; item->value = Value(StringUtils::format("[%.2f,%.2f]", player->getPositionX(), player->getPositionY()));
	}
	void onWatch_flipedX(Ref* sender)
	{
		WatchItem* item = (WatchItem*)sender; item->value = Value(StringUtils::format("[%d]", player->isFlippedX()));
	}
	void onWatch_monPos(Ref* sender)
	{
		WatchItem* item = (WatchItem*)sender; item->value = Value(StringUtils::format("[%.2f,%.2f]", monsters[0]->getPositionX(), monsters[0]->getPositionY()));
	}
	void onWatch_skillPos(Ref* sender)
	{
		Skill* k = skManager.skills.at(M_SKILL_1);
		WatchItem* item = (WatchItem*)sender; item->value = Value(StringUtils::format("[%.2f,%.2f]", k->getPositionX(), k->getPositionY()));
	}
	void ManagePlayerMovement()
	{
		Sprite* sprite = GetPlayerSprite();
		Point curPos = player->getPosition();
		float controlspeedrate = player->getSpeed();
		Point curDirection = player->GetCurDirection();
		Point curBakPos = GetMapPanel()->getPosition();
		Size backSize = GetMapPanel()->getContentSize();
		Size visibleSize = Director::getInstance()->getVisibleSize();
		float newx = curPos.x + controlspeedrate*curDirection.x;
		float newy = curPos.y + controlspeedrate*curDirection.y;
		float newbackx = curBakPos.x;
		
		if (newy > movementYBound[1] || newy < movementYBound[0])
			newy = curPos.y;
		if (newx <= 0 || newx >= backSize.width)
			newx = curPos.x;
		sprite->setPosition(newx,newy);

		Point screenPos = GetMapPanel()->convertToWorldSpace(GetPlayerSprite()->getPosition());
		if (screenPos.x < movementXOffsetThreshold)
		{
			if(curBakPos.x < 0)
				newbackx = curBakPos.x - controlspeedrate*curDirection.x;
		}
		else if (screenPos.x > visibleSize.width - movementXOffsetThreshold)
		{
			if (curBakPos.x > visibleSize.width - backSize.width)
				newbackx = curBakPos.x - controlspeedrate*curDirection.x;
		}
		GetMapPanel()->setPositionX(newbackx);
	}
	
	void Win()
	{
		if (onMapEnd != nullptr)
			onMapEnd(true);
	}
	void Lose()
	{
		if (onMapEnd != nullptr)
			onMapEnd(false);
	}
private:
	Node* rootNode;
	PlayerNode* player;
	std::vector<MonsterNode*> monsters;
	int movementYBound[2];
	int movementXOffsetThreshold;
	SkillManager skManager;
};

#endif