#ifndef  _APP_DELEGATE_H_
#define  _APP_DELEGATE_H_

#include "cocos2d.h"
#include "Scenes.h"
USING_NS_CC;

class  AppDelegate : private cocos2d::Application
{
public:
	AppDelegate(){}
	virtual ~AppDelegate(){}
    virtual void initGLContextAttrs()
	{
		GLContextAttrs glContextAttrs = { 8, 8, 8, 8, 24, 8 };
		GLView::setGLContextAttrs(glContextAttrs);
	}
    virtual bool applicationDidFinishLaunching()
	{
		auto director = Director::getInstance();
		auto glview = director->getOpenGLView();
		if (!glview) {
			glview = GLViewImpl::create("My Game");
			director->setOpenGLView(glview);
		}
		director->setDisplayStats(true);
		director->setAnimationInterval(1.0 / 60);
		director->runWithScene(Scenes::GetMainScene());
		return true;
	}
    virtual void applicationDidEnterBackground()
	{
		Director::getInstance()->stopAnimation();
	}
	virtual void applicationWillEnterForeground()
	{
		Director::getInstance()->startAnimation();
	}
};
#endif // _APP_DELEGATE_H_

