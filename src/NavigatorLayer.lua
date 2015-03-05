NavigatorLayer = class("NavigatorLayer",function()
    return cc.Layer:create();

end)

function NavigatorLayer.create()
	local nav=NavigatorLayer.new();
	nav:init();
	return nav;
end

function NavigatorLayer:init()
	self:InitDefaultParms();
	self:InitComponents();
end

function NavigatorLayer:InitDefaultParms()
	
end

function NavigatorLayer:InitComponents()
	self.rootNode=cc.CSLoader:createNode("LY_Navigator.csb");
	self:addChild(self.rootNode);
	local visibleSize=cc.Director:getInstance():getVisibleSize();
	self.rootNode:setAnchorPoint(0, 1);
	self.rootNode:setPosition(0,visibleSize.height);	
	local panel1=self.rootNode:getChildByTag(438);
	local hpText=panel1:getChildByTag(98);
	local mpText=panel1:getChildByTag(99);
	local hpLBar=panel1:getChildByTag(441);
	local mpLBar=panel1:getChildByTag(62);
	local hpStSp=panel1:getChildByTag(443);
	local hpEdSp=panel1:getChildByTag(442);
	local mpStSp=panel1:getChildByTag(61);
	local mpEdSp=panel1:getChildByTag(60);
	self.HpText=hpText;
	self.MpText=mpText;
	self.HpBar=hpLBar;
	self.MpBar=mpLBar;
	self.HpStSp=hpStSp;
	self.HpEdSp=hpEdSp;
	self.MpStSp=mpStSp;
	self.MpEdSp=mpEdSp;
	self:SetMpPercentage(100);
	self:SetHpPercentage(100);
	self:SetHpValue(1000);
	self:SetHpValue(1000);
end

function NavigatorLayer:SetHpValue(hp)
	local text=self.HpText;
	local str = string.format("HP : %d", hp);
	text:setString(str);
end

function NavigatorLayer:SetMpValue(mp)
	local text=self.MpText;
	local str = string.format("MP : %d", mp);
	text:setString(str);
end

function NavigatorLayer:SetHpPercentage(percentage)
	if (percentage <= 0) then
		self.HpStSp:setVisible(false);
		self.HpEdSp:setVisible(false);
		self.HpBar:setPercent(0);
	elseif (percentage >= 100) then
		self.HpStSp:setVisible(true);
		self.HpEdSp:setVisible(true);
		self.HpBar:setPercent(100);
	else
		self.HpStSp:setVisible(true);
		self.HpEdSp:setVisible(false);
		self.HpBar:setPercent(percentage);
	end
end

function NavigatorLayer:SetMpPercentage(percentage)
	if (percentage <= 0) then
		self.MpStSp:setVisible(false);
		self.MpEdSp:setVisible(false);
		self.MpBar:setPercent(0);
	elseif (percentage >= 100) then
		self.MpStSp:setVisible(true);
		self.MpEdSp:setVisible(true);
		self.MpBar:setPercent(100);
	else
		self.MpStSp:setVisible(true);
		self.MpEdSp:setVisible(false);
		self.MpBar:setPercent(percentage);
	end	
end

return NavigatorLayer;