#ifndef  SCENES_H
#define  SCENES_H
#include "cocos2d.h"
#include "MainLayer.h"
#include "MainMenuLayer.h"

class Scenes
{

public:
	static Scene* GetStartScene()
	{
		auto scene = Scene::create();
		auto layer = MainMenuLayer::create();
		layer->onNextSceneCalled = Scenes::onStartSceneCallingNext;
		scene->addChild(layer);
		return scene;
	}
	static Scene* GetMainScene()
	{
		auto scene = Scene::create();
		auto layer = MainLayer::create();
		layer->onNextSceneCalled = Scenes::onMainSceneCallingNext;
		scene->addChild(layer);
		return scene;
	}
private:
	static void onStartSceneCallingNext(int type)
	{
		if (type == 1)
		{
			Director::getInstance()->replaceScene(TransitionProgressInOut::create(0.2f, GetMainScene()));
		}
		if (type == 4)
		{
			Director::getInstance()->end();
		}
	}
	static void onMainSceneCallingNext(int type)
	{
		if (type == 1)
		{
			Director::getInstance()->replaceScene(TransitionProgressInOut::create(0.2f, GetStartScene()));
		}
		if (type == 4)
		{
			Director::getInstance()->end();
		}
	}
};



#endif