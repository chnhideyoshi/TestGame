#ifndef UNTILS_H
#define UNTILS_H

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"
USING_NS_CC;
USING_NS_CC::ui;
#define  TEST 0;
class Tools
{
public:
	/* 根据文件名字前缀创建动画对象 */
	static Animation* createWithSingleFrameName(const char* name, float delay, int iLoops)
	{
		SpriteFrameCache* cache = SpriteFrameCache::getInstance();

		Vector<SpriteFrame*> frameVec;
		SpriteFrame* frame = NULL;
		int index = 1;
		do {
			frame = cache->getSpriteFrameByName(StringUtils::format("%s%d.png", name, index++));

			/* 不断地获取SpriteFrame对象，直到获取的值为NULL */
			if (frame == NULL) {
				break;
			}

			frameVec.pushBack(frame);
		} while (true);

		Animation* animation = Animation::createWithSpriteFrames(frameVec);
		animation->setLoops(iLoops);
		animation->setRestoreOriginalFrame(false);
		animation->setDelayPerUnit(delay);

		return animation;
	}

	/* 根据文件名字前缀创建动画对象，指定动画图片数量 */
	static Animation* createWithFrameNameAndNum(const char* name, int iNum, float delay, int iLoops)
	{
		SpriteFrameCache* cache = SpriteFrameCache::getInstance();

		Vector<SpriteFrame*> frameVec;
		SpriteFrame* frame = NULL;
		int index = 1;
		for (int i = 1; i <= iNum; i++) {
			std::string file = StringUtils::format("%s%d.png", name, i);
			frame = cache->getSpriteFrameByName(file);

			if (frame == NULL) {
				break;
			}

			frameVec.pushBack(frame);
		}

		Animation* animation = Animation::createWithSpriteFrames(frameVec);
		animation->setLoops(iLoops);
		animation->setRestoreOriginalFrame(true);
		animation->setDelayPerUnit(delay);

		return animation;
	}

	static Animation* createAnimation(const char* formatStr, int frameCount, int fps)
	{
		Vector<SpriteFrame *> pFrames;
		for (int i = 0; i < frameCount; ++i)
		{
			const char* imgName = String::createWithFormat(formatStr, i)->getCString();
			SpriteFrame *pFrame = SpriteFrameCache::getInstance()->getSpriteFrameByName(imgName);
			pFrames.pushBack(pFrame);
		}
		return Animation::createWithSpriteFrames(pFrames, 1.0f / fps);
	}

	static void CreateRectPanel(Rect rec,Color3B color,unsigned int opacity,Node* parent)
	{
		if (parent->getChildByName("RectPanel") == NULL)
		{
			Layout* panel = Layout::create();
			panel->setSize(rec.size);
			panel->setName("RectPanel");
			panel->setBackGroundColorType(Layout::BackGroundColorType::SOLID);
			panel->setBackGroundColor(color);
			panel->setBackGroundColorOpacity(opacity);
			panel->setAnchorPoint(ccp(0, 0));
			panel->setVisible(true);
			panel->setPosition(rec.origin);
			parent->addChild(panel);
		}
		return;
	}
	
	static int GetRand(int start, int end)
	{
		float i = CCRANDOM_0_1()*(end - start + 1) + start; 
		return (int)i;
	}

	static void GetRandPointsInRect(int startX,int startY,int width,int height,int count,std::vector<Point>& points)
	{
		points.clear();
		for(int i = 0; i < count; i++)
		{
			int _randX = GetRand(startX, startX+width);
			int _randY = GetRand(startY, startY + height);
			points.push_back(Point(_randX, _randY));
		}
	}
	static int GetCenterFloatRandom(int d,float rate)
	{
		int dmax = (int)(d*rate + d);
		int dmin = (int)(-d*rate + d);
		return GetRand(dmin, dmax);
	}

	static void FlipUsingAnchorPoint(Sprite* node)
	{
		float posX = node->getPositionX();
		Point p = node->getAnchorPoint();
		Size sz = node->getContentSize();
		float delta = -(sz.width - 2 * p.x*sz.width);
		node->setFlippedX(true);
		node->setPositionX(posX+delta);
	}

};


#endif