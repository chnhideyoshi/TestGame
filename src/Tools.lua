
--PlayerOnceState
O_STATE_NONE= 10
O_STATE_ATK1= 11
O_STATE_ATK2= 12
O_STATE_ATK3= 13
O_STATE_ATK4= 14
O_STATE_ATK5= 15
O_STATE_ATK6= 16
O_STATE_ATK7= 17
O_STATE_HURT= 18
O_STATE_DEAD= 19
O_STATE_WELOME= 20
O_STATE_WIN= 21

--PlayerLastingState
L_STATE_STAND=0
L_STATE_FORWARD=1
L_STATE_DEFEND=2


--MonsterAction
ACTION_STATE_NONE=0
ACTION_STATE_IDLE=1
ACTION_STATE_WALK=2
ACTION_STATE_ATTACK=3
ACTION_STATE_HURT=4
ACTION_STATE_DEAD=5
ACTION_STATE_REMOVE=6


--KEYS
KEY_UP=28;
KEY_DOWN=29;
KEY_LEFT=26;
KEY_RIGHT=27;
KEY_SPACE=59;
KEY_Z=149;
KEY_X=147;
KEY_C=126;
KEY_A=124;
KEY_S=142;
KEY_D=127;
KEY_Q=140;

-- Skills
PLAYER_SKILL_ATK1=0
PLAYER_SKILL_ATK2=1
PLAYER_SKILL_ATK3=2
PLAYER_SKILL_ATK4=3
PLAYER_SKILL_ATK5=4
PLAYER_SKILL_ATK6=5
PLAYER_SKILL_ATK7=6

MONSTER_SKILL_1=7




function createWithSingleFrameName(name,delay,loop)
	local frameCache = cc.SpriteFrameCache:getInstance();	
	local index=1;
	local frameVec={};
	while true do
		local frame=frameCache:getSpriteFrame(string.format("%s%d.png",name,index));
		index=index+1;
		if frame==nil then
			break;
		end
		table.insert(frameVec,frame);
	end
	local animation = cc.Animation:createWithSpriteFrames(frameVec);
	animation:setDelayPerUnit(delay);
	animation:setLoops(loop);
	return animation;
end

function createWithSingleFrameNameAndCount(name,count,delay,loop)
	local frameCache = cc.SpriteFrameCache:getInstance();	
	local index=1;
	local frameVec={};
	while true do
		local frame=frameCache:getSpriteFrame(string.format("%s%d.png",name,index));
		index=index+1;
		if frame==nil then
			break;
		end
		table.insert(frameVec,frame);
		if(index==count+1) then
			break;
		end
	end
	local animation = cc.Animation:createWithSpriteFrames(frameVec);
	animation:setDelayPerUnit(delay);
	animation:setLoops(loop);
	return animation;
end

function GetFlowWordNode()
	local node=cc.Node:create();
	local ttfConfig = {}
	ttfConfig.fontFilePath="fonts/Marker Felt.ttf"
	ttfConfig.fontSize=35        
    local  m_textLab = cc.Label:createWithTTF(ttfConfig,"", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,260) 
	m_textLab:setName("Label");
	m_textLab:setColor(cc.c3b(255,215,0));
	m_textLab:setAnchorPoint(0.5, 0.5);
	m_textLab:setVisible(false);
	m_textLab:setPosition(0, 100);
	node:addChild(m_textLab);
	return node;
end

function ShowWord1(node,text)
	local m_textLab=node:getChildByName("Label");
	m_textLab:setVisible(true);
	m_textLab:setString(text);
	local scaleLarge=cc.ScaleTo:create(0.3,2.2,2.2);
	local scaleSmall = cc.ScaleTo:create(0.5, 0.5, 0.5);
	callFunc = cc.CallFunc:create(function(node,value)
		m_textLab:setVisible(false);
	end);
	local actions=cc.Sequence:create(scaleLarge, scaleSmall, callFunc);
	m_textLab:runAction(actions);
end

function ShowWord2(node,text)
	local m_textLab=node:getChildByName("Label");
	m_textLab:setVisible(true);
	m_textLab:setString(text);
	local scaleLarge=cc.ScaleTo:create(0.3,1.5,1.5);
	local scaleSmall = cc.ScaleTo:create(0.5, 0.5, 0.5);
	m_textLab:setColor(cc.c3b(255,255,255))
	callFunc = cc.CallFunc:create(function(node,value)
		m_textLab:setVisible(false);
	end);
	local actions=cc.Sequence:create(scaleLarge, scaleSmall, callFunc);
	m_textLab:runAction(actions);
end

function GetRandPointsInRect(minX,minY,maxX,maxY,count)
	local vec={};
	math.randomseed(tostring(os.time()):reverse():sub(1, 6));
	for i=1,count do
		local x=math.random(minX,maxX);
		local y=math.random(minY,maxY);
		local p=cc.p(x,y);
		table.insert(vec,p);
	end
	return vec;
end

function GetCenterFloatRandom(d,rate)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6));
	local maxd=d+d*rate;
	local mind=d-d*rate;
	return math.random(mind,maxd);
end

function PlaySound(name)
    cc.SimpleAudioEngine:getInstance():playEffect(name,false);
end

function PlayMusic(name)
    cc.SimpleAudioEngine:getInstance():playEffect(name,true);
end


------------------------------------------------------------
TestLayer = class("TestLayer",function()
    return cc.Layer:create();
end)

function TestLayer.create()
	local obj=TestLayer.new();
	obj:Init();
	return obj;
end

function TestLayer:Init()
	self.p1=0;
end

function TestLayer:Start()
	print("base start");
end

TestLayerSub=class("TestLayerSub",TestLayer)

function TestLayerSub.create()
	local obj=TestLayerSub.new();
	obj:Init();
	return obj;
end

function TestLayerSub:Start()
	TestLayer.super.Start(self);
	print("sub");
	print(self.p1);
end

TestLayerSub2=class("TestLayerSub2",function()
	return TestLayer.create();
end)

function TestLayerSub2.create()
	local obj=TestLayerSub2.new();
	obj:Init();
	return obj;
end

function TestLayerSub2:Start()
	--TestLayer.super.Start(self);
	print("sub2");
	print(self.p1);
end