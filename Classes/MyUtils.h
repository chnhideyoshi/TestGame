#ifndef UNTILS_H
#define UNTILS_H

#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include"cocostudio/CocoStudio.h"
USING_NS_CC;
USING_NS_CC::ui;
#define  TEST 0;

class FlowWord : public Node
{
public:
	CREATE_FUNC(FlowWord);
	virtual bool init()
	{
		m_textLab = Label::create("", "Arial", 35);
		m_textLab->setColor(ccc3(255, 215, 0));
		m_textLab->setAnchorPoint(ccp(0.5, 0.5));
		m_textLab->setVisible(false);
		m_textLab->setPosition(0, 100);
		this->addChild(m_textLab);
		return true;
	}

public:
	void showWord(const char* text)
	{
		m_textLab->setString(text);
		m_textLab->setVisible(true);
		auto scaleLarge = ScaleTo::create(0.3f, 2.2f, 2.2f);
		auto scaleSmall = ScaleTo::create(0.5f, 0.5f, 0.5f);
		auto callFunc = CallFunc::create([&]()
		{
			m_textLab->setVisible(false);
		});
		auto actions = Sequence::create(scaleLarge, scaleSmall, callFunc, NULL);
		m_textLab->runAction(actions);
	}
	void showWord2(const char* text)
	{
		m_textLab->setString(text);
		m_textLab->setVisible(true);
		auto scaleLarge = ScaleTo::create(0.3f, 1.5f, 1.5f);
		auto scaleSmall = ScaleTo::create(0.5f, 0.5f, 0.5f);
		m_textLab->setColor(ccc3(255, 255,255));
		auto callFunc = CallFunc::create([&]()
		{
			m_textLab->setVisible(false);
		});
		auto actions = Sequence::create(scaleLarge, scaleSmall, callFunc, NULL);
		m_textLab->runAction(actions);
	}
private:
	Label* m_textLab;
};
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

	static void ShowTempAnimation(const char* name, float delay, int iLoops, Node* parent,Point pos,FiniteTimeAction* pre)
	{
		Sprite* sp1a = Sprite::create();
		sp1a->setAnchorPoint(Point(0.5, 0.5));
		sp1a->setPosition(pos);
		parent->addChild(sp1a);
		Animation* pATK5a = Tools::createWithSingleFrameName(name, delay, iLoops);
		if (pre == NULL)
			pre = DelayTime::create(0);
		Action* ac = Sequence::create(pre,Animate::create(pATK5a), CallFuncN::create([=](Node* sp)
		{
			sp->removeFromParentAndCleanup(true);
		}), NULL);
		sp1a->runAction(ac);
	}

};


#endif