#ifndef STARTSCENE_H
#define  STARTSCENE_H

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"
USING_NS_CC;
USING_NS_CC::ui;
class MainMenuLayer :public Layer
{
public:
	void(*onNextSceneCalled)(int type);
	static cocos2d::Scene* createScene()
	{
		auto scene = Scene::create();
		auto layer = MainMenuLayer::create();
		scene->addChild(layer);
		return scene;
	}
	MainMenuLayer(){}
	~MainMenuLayer()
	{
	}
	bool init()
	{
		if (!Layer::init())
		{
			return false;
		}
		this->InitComponents();
		this->InitEventHandler();
		return true;
	}
	CREATE_FUNC(MainMenuLayer);
private:
	Button* GetStartButton()
	{
		return startButton;
	}
	Button* GetContinueButton()
	{
		return continueButton;
	}
	Button* GetSettingsButton()
	{
		return settingsButton;
	}
	Button* GetExitButton()
	{
		return exitButton;
	}
	void InitComponents()
	{
		Node* rootNode = CSLoader::createNode("LY_MainMenu.csb");
		rootNode->setAnchorPoint(Point(0, 0));
		rootNode->setPosition(0, 0);
		this->addChild(rootNode);
		this->startButton = (Button*)Helper::seekWidgetByTag((Widget*)rootNode,145);
		this->continueButton = (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 147);
		this->settingsButton = (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 148);
		this->exitButton = (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 149);
	}
	void InitEventHandler()
	{
		GetStartButton()->addTouchEventListener(Widget::ccWidgetTouchCallback(CC_CALLBACK_2(MainMenuLayer::onStartButtonClicked, this)));
		GetContinueButton()->addTouchEventListener(Widget::ccWidgetTouchCallback(CC_CALLBACK_2(MainMenuLayer::onContinueButtonClicked, this)));
		GetSettingsButton()->addTouchEventListener(Widget::ccWidgetTouchCallback(CC_CALLBACK_2(MainMenuLayer::onSettingsButtonClicked, this)));
		GetExitButton()->addTouchEventListener(Widget::ccWidgetTouchCallback(CC_CALLBACK_2(MainMenuLayer::onExitButtonClicked, this)));
	}
	void onStartButtonClicked(Ref* ref, Widget::TouchEventType eventType)
	{
		if (onNextSceneCalled != NULL)
			onNextSceneCalled(1);
	}
	void onContinueButtonClicked(Ref* ref, Widget::TouchEventType eventType)
	{
		if (onNextSceneCalled != NULL)
			onNextSceneCalled(2);
	}
	void onSettingsButtonClicked(Ref* ref, Widget::TouchEventType eventType)
	{
		if (onNextSceneCalled != NULL)
			onNextSceneCalled(3);
	}
	void onExitButtonClicked(Ref* ref, Widget::TouchEventType eventType)
	{
		if (onNextSceneCalled != NULL)
			onNextSceneCalled(4);
	}
private:
	Node* rootNode;
	Button* startButton;
	Button* continueButton;
	Button* settingsButton;
	Button* exitButton;
};

#endif