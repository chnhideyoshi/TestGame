#ifndef ESCMENU_H
#define  ESCMENU_H

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"
USING_NS_CC;
USING_NS_CC::ui;

class EscMenuLayer : public cocos2d::Layer
{
public:
	EscMenuLayer(){}
	~EscMenuLayer(){}
	CREATE_FUNC(EscMenuLayer);
	bool init()
	{
		if (!Layer::init())
		{
			return false;
		}
		this->InitComponents();
		this->InitEventHandlers();
		return true;
	}
private:
	Button* GetReturnButton()
	{
		return (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 158);
	}
	Button* GetRestartButton()
	{
		return (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 156);
	}
	Button* GetSettingsButton()
	{
		return (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 157);
	}
	Button* GetExitButton()
	{
		return (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 159);
	}
	void InitComponents()
	{
		this->rootNode = CSLoader::createNode("LY_Menu0.csb");
		rootNode->setAnchorPoint(Point(0, 0));
		rootNode->setPosition(0, 0);
		this->addChild(rootNode);
	}
	void InitEventHandlers()
	{
		GetReturnButton()->addTouchEventListener(CC_CALLBACK_2(EscMenuLayer::onReturnButtonClicked,this));
		GetRestartButton()->addTouchEventListener(CC_CALLBACK_2(EscMenuLayer::onRestartButtonClicked, this));
		GetSettingsButton()->addTouchEventListener(CC_CALLBACK_2(EscMenuLayer::onSettingsButtonClicked, this));
		GetExitButton()->addTouchEventListener(CC_CALLBACK_2(EscMenuLayer::onExitButtonClicked, this));
	}

	void onReturnButtonClicked(Ref* ,Widget::TouchEventType type)
	{
		if (onReturn != nullptr)
			onReturn();
		this->removeFromParentAndCleanup(true);		
	}
	void onExitButtonClicked(Ref*, Widget::TouchEventType type)
	{
		Director::getInstance()->end();
	}
	void onRestartButtonClicked(Ref*, Widget::TouchEventType type)
	{
		MessageBox("功能尚未开发完成，敬请期待！", "message");
	}
	void onSettingsButtonClicked(Ref*, Widget::TouchEventType type)
	{
		MessageBox("功能尚未开发完成，敬请期待！","message");
	}
private:
	Node* rootNode;
public:
	std::function<void()> onReturn;
};


#endif