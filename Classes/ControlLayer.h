#ifndef __CONTROLLAYER_SCENE_H__
#define __CONTROLLAYER_SCENE_H__

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"

USING_NS_CC;
USING_NS_CC::ui;
class ControlLayer : public cocos2d::Layer
{
public:
	ControlLayer(){}
	~ControlLayer(){}
public:
	bool init()
	{
		if (!Layer::init())
		{
			return false;
		}
		

		return true;
	}


	CREATE_FUNC(ControlLayer);

};

#endif // __HELLOWORLD_SCENE_H__






