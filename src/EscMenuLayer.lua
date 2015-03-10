EscMenuLayer = class("EscMenuLayer",function()
    return cc.Layer:create();

end)


function EscMenuLayer.create()
	local layer=EscMenuLayer.new()
	layer:init()
	return layer;
end

function EscMenuLayer:init()
	self:InitComponents();
	self:InitEventHandlers();
	return true;
end

function EscMenuLayer:InitComponents()
	self.rootNode=cc.CSLoader:createNode("LY_Menu0.csb")
	self.rootNode:setAnchorPoint(0, 0);
	self.rootNode:setPosition(0, 0);
	self:addChild(self.rootNode);
	self.Return=nil;
end

function EscMenuLayer:InitEventHandlers()
	local btn=self:GetReturnButton();
	btn:addTouchEventListener(function(sender,etype)
		if etype==2 then
			if(self.Return~=nil) then
				self.Return();
			end
			self:removeFromParent();
		end
	end);
	btn=self:GetExitButton();
	btn:addTouchEventListener(function(sender,etype)
		if etype==2 then
			if(self.Exit~=nil) then
				self.Exit();
			end
		end
	end);
	
end

function EscMenuLayer:GetReStartButton()
	return self.rootNode:getChildByTag(156);
end

function EscMenuLayer:GetReturnButton()
	return self.rootNode:getChildByTag(158);
end

function EscMenuLayer:GetExitButton()
	return self.rootNode:getChildByTag(159);
end

function EscMenuLayer:GetSettingsButton()
	return self.rootNode:getChildByTag(157);
end