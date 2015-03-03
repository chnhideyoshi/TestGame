
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

--KEYS
KEY_UP=28;
KEY_DOWN=29;
KEY_LEFT=26;
KEY_RIGHT=27;

KEY_Z=149;
KEY_X=147;
KEY_C=126;
KEY_A=124;
KEY_S=142;
KEY_D=127;
KEY_Q=140;





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

function GetFlowWordNode()
	local node=cc.Node:create();
	local m_textLab=cc.Label:create("","Arial",35);
	m_textLab:setName("Label");
	m_textLab:setColor(cc.c3b(255,215,0));
	m_textLab:setAnchorPoint(0.5, 0.5);
	m_textLab:setVisible(false);
	m_textLab:setPosition(0, 100);
	node:addChild(m_textLab);
	return node;
end

function ShowWord1(node)
	local m_textLab=node:getChildByName("Label");
	m_textLab:setVisible(true);
	local scaleLarge=cc.ScaleTo:create(0.3,2.2,2.2);
	local scaleSmall = cc.ScaleTo:create(0.5, 0.5, 0.5);
	local callFunc = CallFunc:create(function()
		m_textLab:setVisible(false);
	end);
	local actions=cc.Sequence:create(scaleLarge, scaleSmall, callFunc);
	m_textLab:runAction(actions);
end

function ShowWord2()
	local m_textLab=node:getChildByName("Label");
	m_textLab:setVisible(true);
	local scaleLarge=cc.ScaleTo:create(0.3,1.5,1.5);
	local scaleSmall = cc.ScaleTo:create(0.5, 0.5, 0.5);
	m_textLab:setColor(cc.c3b(255,255,255))
	local callFunc = CallFunc:create(function()
		m_textLab:setVisible(false);
	end);
	local actions=cc.Sequence:create(scaleLarge, scaleSmall, callFunc);
	m_textLab:runAction(actions);
end