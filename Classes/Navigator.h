#ifndef __NAVIGATOR_H__
#define __NAVIGATOR_H__

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"

USING_NS_CC;
USING_NS_CC::ui;
class NavigatorLayer : public cocos2d::Layer
{
public:
	NavigatorLayer(){}
	~NavigatorLayer(){}
	bool init()
	{
		if (!Layer::init())
		{
			return false;
		}
		rootNode = CSLoader::createNode("LY_Navigator.csb");
		this->addChild(rootNode);
		rootNode->setAnchorPoint(Point(0, 1));
		Size visibleSize = Director::getInstance()->getVisibleSize();
		rootNode->setPosition(0,visibleSize.height);
		SetMpPercentage(100);
		SetHpPercentage(100);
		SetHpValue(1000);
		SetHpValue(1000);
		return true;
	}
	void SetHpPercentage(int percentage)
	{
		if (percentage <= 0)
		{
			GetHpStSprite()->setVisible(false);
			GetHpEdSprite()->setVisible(false);
			GetHpMidSprite()->setPercent(0);
		}
		else if (percentage >= 100)
		{
			GetHpStSprite()->setVisible(true);
			GetHpEdSprite()->setVisible(true);
			GetHpMidSprite()->setPercent(100);
		}
		else
		{
			GetHpStSprite()->setVisible(true);
			GetHpEdSprite()->setVisible(false);
			GetHpMidSprite()->setPercent(percentage);
		}
	}
	int GetHpPercetage()
	{
		return (int)GetHpMidSprite()->getPercent();
	}
	void SetMpPercentage(int percentage)
	{
		if (percentage <= 0)
		{
			GetMpStSprite()->setVisible(false);
			GetMpEdSprite()->setVisible(false);
			GetMpMidSprite()->setPercent(0);
		}
		else if (percentage >= 100)
		{
			GetMpStSprite()->setVisible(true);
			GetMpEdSprite()->setVisible(true);
			GetMpMidSprite()->setPercent(100);
		}		 
		else   
		{		 
			GetMpStSprite()->setVisible(true);
			GetMpEdSprite()->setVisible(false);
			GetMpMidSprite()->setPercent(percentage);
		}
	}
	int GetMpPercetage()
	{
		return (int)GetMpMidSprite()->getPercent();
	}
	CREATE_FUNC(NavigatorLayer);
	void SetHpValue(int hp)
	{
		Text* text = GetHpText();
		std::string str = StringUtils::format("HP : %d", hp);
		text->setString(str);
	}
	void SetMpValue(int mp)
	{
		GetMpText()->setString(StringUtils::format("MP : %d", mp));
	}
private:
	Sprite* GetHeadFrameSprite()
	{
		return (Sprite*)Helper::seekWidgetByTag((Widget*)rootNode, 437);
	}
	Text* GetHpText()
	{
		return (Text*)Helper::seekWidgetByTag((Widget*)rootNode, 98);
	}
	Text* GetMpText()
	{
		return (Text*)Helper::seekWidgetByTag((Widget*)rootNode, 99);
	}
	ImageView* GetHpStSprite()
	{
		return (ImageView*)Helper::seekWidgetByTag((Widget*)rootNode, 443);
	}
	ImageView* GetHpEdSprite()
	{
		return (ImageView*)Helper::seekWidgetByTag((Widget*)rootNode, 442);
	}
	LoadingBar* GetHpMidSprite()
	{
		return (LoadingBar*)Helper::seekWidgetByTag((Widget*)rootNode, 441);
	}
	ImageView* GetMpStSprite()
	{
		return (ImageView*)Helper::seekWidgetByTag((Widget*)rootNode, 61);
	}
	ImageView* GetMpEdSprite()
	{
		return (ImageView*)Helper::seekWidgetByTag((Widget*)rootNode, 60);
	}
	LoadingBar* GetMpMidSprite()
	{
		return (LoadingBar*)Helper::seekWidgetByTag((Widget*)rootNode, 62);
	}
	Button* GetSysButton()
	{
		return (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 58);
	}

private:
	Size visibleSize;
	float maxHpScale;
	Node* rootNode;


};
#endif