#ifndef __MainLayer_SCENE_H__
#define __MainLayer_SCENE_H__

#include "cocos2d.h"
#include "MyUtils.h"
#include "ControlLayer.h"
#include "ConsoleLayer.h"
#include "Navigator.h"
#include "MapLayer.h"
#include "PromptMenuLayer.h"
#include "EscMenu.h"


USING_NS_CC;

class MainLayer : public cocos2d::Layer
{
public:
	MainLayer()
	{

	}
	~MainLayer()
	{

	}
	void(*onNextSceneCalled)(int type);
	virtual bool init()
	{
		if (!Layer::init())
		{
			return false;
		}
		InitEventHandlers();
		InitLayers();
		return true;
	}
	CREATE_FUNC(MainLayer);
private:
	Point GetCenter()
	{
		Size visibleSize = Director::getInstance()->getVisibleSize();
		return Point(visibleSize.width*0.5f, visibleSize.height*0.5f);
	}
	ConsoleLayer* GetConsole()
	{
		return (ConsoleLayer*)this->getChildByName("LY_Console");
	}
	MapLayer* GetMap()
	{
		return (MapLayer*)this->getChildByName("LY_Map");
	}
	void onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event)
	{
		if (keyCode == EventKeyboard::KeyCode::KEY_F1)
		{
			if (this->getChildByName("LY_PromptMenu") == nullptr)
			{
				PromptMenu* layer = PromptMenu::create();
				layer->setPosition(GetCenter());
				layer->setName("LY_PromptMenu");
				layer->onPromptConfirmed = [=](PromptMenuPostData* data)
				{
					Director::getInstance()->resume();
					return;
				};
				this->addChild(layer);
				Director::getInstance()->pause();
			}
			else
			{
				this->removeChild(this->getChildByName("LY_PromptMenu"), true);
				Director::getInstance()->resume();
			}
			return;
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_ESCAPE)
		{
			if (this->getChildByName("LY_ESCMenu") == nullptr)
			{
				EscMenuLayer* layer = EscMenuLayer::create();
				layer->setAnchorPoint(Point(0, 0));
				layer->setPosition(0,0);
				layer->setName("LY_ESCMenu");
				layer->onReturn = [=]()
				{
					Director::getInstance()->resume();
				};
				this->addChild(layer);
				Director::getInstance()->pause();
			}
			else
			{
				this->removeChild(this->getChildByName("LY_ESCMenu"), true);
				Director::getInstance()->resume();
			}
		}
		if (keyCode == EventKeyboard::KeyCode::KEY_F2)
		{
			ConsoleLayer* layer = GetConsole();
			layer->EnableWatcher();
			return;
		}
	}
	void InitEventHandlers()
	{
		auto listenerKeyboard = EventListenerKeyboard::create();
		listenerKeyboard->onKeyPressed = CC_CALLBACK_2(MainLayer::onKeyPressed, this);
		_eventDispatcher->addEventListenerWithSceneGraphPriority(listenerKeyboard, this);
	}
	void InitLayers()
	{
		ConsoleLayer* console = ConsoleLayer::create();
		ConsoleLayer::SetConsoleInstance(console);
		console->setAnchorPoint(Point(0, 0));
		console->setPosition(0, 0);
		console->setName("LY_Console");
	   
		
		MapLayer* map = MapLayer::create();
		map->setName("LY_Map");
		map->onMapEnd = [&](bool suc)
		{
			if (suc)
			{
				MessageBox("guoguan", "haha");
				if (onNextSceneCalled != NULL)
					onNextSceneCalled(1);
			}
			else
			{
				MessageBox("meiguo", "hehe");
				if (onNextSceneCalled != NULL)
					onNextSceneCalled(1);
			}
				
		};


		
		
		this->addChild(map);
		this->addChild(console);

		
	}
};

#endif // __MainLayer_SCENE_H__
