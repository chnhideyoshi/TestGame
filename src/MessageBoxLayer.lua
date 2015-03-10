MessageBoxLayer = class("MessageBoxLayer",function()
    return cc.Layer:create();

end)


function MessageBoxLayer.create()
	local layer=MessageBoxLayer.new()
	layer:init()
	return layer;
end

function MessageBoxLayer:init()
	self:InitComponents();
	self:InitEventHandlers();
	return true;
end

function MessageBoxLayer:InitComponents()
	self.rootNode=cc.CSLoader:createNode("LY_Menu2.csb")
	self.rootNode:setAnchorPoint(0, 0);
	self.rootNode:setPosition(0, 0);
	self:addChild(self.rootNode);
	self.Return=nil;
end

function MessageBoxLayer:InitEventHandlers()
	local btn=self:GetButton();
	btn:addTouchEventListener(function(sender,etype)
		if etype==2 then
			if(self.Return~=nil) then
				self.Return();
			end
			self:removeFromParent();
		end
	end);
end

function MessageBoxLayer:SetMessage(msg)
	local lb=self.rootNode:getChildByTag(73);
	lb:setString(msg);
end

function MessageBoxLayer:SetImage(itype)
	self.rootNode:getChildByTag(74):setVisible(false);
	self.rootNode:getChildByTag(75):setVisible(false);
	self.rootNode:getChildByTag(76):setVisible(false);
	if itype==0 then
		self.rootNode:getChildByTag(74):setVisible(true);
	elseif itype==1 then
		self.rootNode:getChildByTag(75):setVisible(true);
	elseif itype==2 then
		self.rootNode:getChildByTag(76):setVisible(true);
	end
	
end

function MessageBoxLayer:GetButton()
	return self.rootNode:getChildByTag(158);
end