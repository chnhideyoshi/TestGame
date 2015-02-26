#ifndef __PROMPTMENU_H__
#define __PROMPTMENU_H__

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"

USING_NS_CC;
USING_NS_CC::ui;

class PromptMenuPostData:public Ref
{
public:
	std::string Parm1Name;
	std::string Parm1Value;
	std::string Parm2Name;
	std::string Parm2Value;
	std::string Parm3Name;
	std::string Parm3Value;
	std::string Parm4Name;
	std::string Parm4Value;
};

class PromptMenu : public cocos2d::Layer
{
public:
	PromptMenu(){}
	~PromptMenu()
	{
	}
	bool init()
	{
		if (!Layer::init())
		{
			return false;
		}
		rootNode = CSLoader::createNode("LY_Menu1.csb");
		this->addChild(rootNode);
		rootNode->setAnchorPoint(Point(0.5, 0.5));
		rootNode->setScale(1.28f, 1.28f);
		rootNode->setPosition(0, 0);
		InitEventHandlers();
		return true;
	}

	

	CREATE_FUNC(PromptMenu);
private:
	Button* GetConfirmBTN()
	{
		return (Button*)Helper::seekWidgetByTag((Widget*)rootNode, 23);
	}
	Button* GetCancelBTN()
	{
		return (Button*)Helper::seekWidgetByName((Widget*)rootNode, "Button_1_Copy");
	}
	TextField* GetTB_1()
	{
		return (TextField*)Helper::seekWidgetByTag((Widget*)rootNode, 28);
	}
	TextField* GetTB_2()
	{
		return (TextField*)Helper::seekWidgetByTag((Widget*)rootNode, 59);
	}
	TextField* GetTB_3()
	{
		return (TextField*)Helper::seekWidgetByTag((Widget*)rootNode, 63);
	}
	TextField* GetTB_4()
	{
		return (TextField*)Helper::seekWidgetByTag((Widget*)rootNode,67);
	}
	Text* GetLabel_1()
	{
		return (Text*)Helper::seekWidgetByTag((Widget*)rootNode, 26);
	}
	Text* GetLabel_2()
	{
		return (Text*)Helper::seekWidgetByTag((Widget*)rootNode, 57);
	}
	Text* GetLabel_3()
	{
		return (Text*)Helper::seekWidgetByTag((Widget*)rootNode, 61);
	}
	Text* GetLabel_4()
	{
		return (Text*)Helper::seekWidgetByTag((Widget*)rootNode, 65);
	}
	void InitEventHandlers()
	{
		GetConfirmBTN()->addTouchEventListener(CC_CALLBACK_2(PromptMenu::OnConfirmClicked,this));
		GetCancelBTN()->addTouchEventListener(CC_CALLBACK_2(PromptMenu::OnCancelClicked,this));
	}

	void OnConfirmClicked(Ref* , Widget::TouchEventType type)
	{
		PromptMenuPostData data;
		data.Parm1Name = GetLabel_1()->getString();
		data.Parm1Value = GetTB_1()->getString();
		data.Parm2Name = GetLabel_2()->getString();
		data.Parm2Value = GetTB_2()->getString();
		data.Parm3Name = GetLabel_3()->getString();
		data.Parm3Value = GetTB_3()->getString();
		data.Parm4Name = GetLabel_4()->getString();
		data.Parm4Value = GetTB_4()->getString();
		if (onPromptConfirmed != NULL)
			onPromptConfirmed(&data);
		this->removeFromParentAndCleanup(true);
	}
	void OnCancelClicked(Ref*, Widget::TouchEventType type)
	{
		this->removeFromParentAndCleanup(true);
	}
private:
	Node* rootNode;
public:
	std::function<void(PromptMenuPostData*)> onPromptConfirmed;
};

#endif // __HELLOWORLD_SCENE_H__






