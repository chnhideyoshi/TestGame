#ifndef __CONSOLELAYER_H__
#define __CONSOLELAYER_H__

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"

USING_NS_CC;
USING_NS_CC::ui;

class WatchItem:public Ref
{
public:
	std::string name;
	Value value;
	std::string message;
	Text* control;
};
class ConsoleLayer : public cocos2d::Layer
{
	static ConsoleLayer* console;
public:
	static void SetConsoleInstance(ConsoleLayer* instance)
	{
		console = instance;
	}
	static ConsoleLayer* GetConsoleInstance()
	{
		return console;
	}
public:
	bool init()
	{
		if (!Layer::init())
		{
			return false;
		}
		Size visibleSize = Director::getInstance()->getVisibleSize();
		rootNode = CSLoader::createNode("LY_Console.csb");
		rootNode->setAnchorPoint(Point(0, 1));
		rootNode->setPosition(visibleSize.width - rootNode->getContentSize().width, visibleSize.height);
		this->addChild(rootNode);
		count = 0;
		intervalInvoke = 1;
		watchAll = false;
		DisableWatcher();
		this->scheduleUpdate();
		return true;
	}
	virtual void update(float delta)
	{
		RefreshWatcher();
	}
	CREATE_FUNC(ConsoleLayer);
public:
	bool Enabled()
	{
		return watchAll;
	}
	void EnableWatcher()
	{
		watchAll = true;
		this->setVisible(true);
	}
	void DisableWatcher()
	{
		watchAll = false;
		this->setVisible(false);
	}
	void ClearWatcher()
	{
		for (const auto&e : watchMap)
		{
			delete e.second;
		}
	}
	void SetInvokeInterval(int interval)
	{
		this->count = 0;
		this->intervalInvoke = interval;
	}
	void RefreshWatcher()
	{
		if (!watchAll)
			return;
		if (count >= intervalInvoke)
		{
			count = 0;
			for (const auto&e : watchMap)
			{
				std::string message = (e.second)->message;
				NotificationCenter::getInstance()->postNotification(message,e.second);
				Text* control = e.second->control;
				control->setString(e.first+Value(": ").asString()+e.second->value.asString());
			}
		}
		else
			count++;
	}
	void AddWatchingValue(std::string name, Value value, std::string message)
	{
		WatchItem* it = new WatchItem();
		WatchItem& item = *it;
		item.name = name;
		item.value = value;
		item.message = message;
		Text* text = Text::create();
		item.control = text;
		text->setFontName("fonts/fontNormal.ttf");
		text->setFontSize(16);
		text->setAnchorPoint(Point(0,1));
		SetContentValue(item);
		GetMainList()->addChild(text);
		watchMap.insert(name, it);
	}
private:
	void SetContentValue(WatchItem& item)
	{
		Text* text = item.control;
		text->setString(item.name+Value(" : ").asString()+item.value.asString());
	}
	ListView* GetMainList()
	{
		return (ListView*)Helper::seekWidgetByTag((Widget*)this->rootNode, 66);
	}
	TextField* GetTitle()
	{
		return (TextField*)Helper::seekWidgetByTag((Widget*)this->rootNode, 67);
	}
	Map<std::string, WatchItem*> watchMap;
	Node* rootNode;
	bool watchAll;
	int intervalInvoke;
	int count;

};
ConsoleLayer* ConsoleLayer::console = NULL;
#endif // __HELLOWORLD_SCENE_H__
