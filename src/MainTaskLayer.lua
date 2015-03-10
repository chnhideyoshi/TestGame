MainTaskLayer = class("MainTaskLayer",function()
    return cc.Layer:create();

end)


function MainTaskLayer.create()
	local layer=MainTaskLayer.new()
	layer:init()
	return layer;
end

function MainTaskLayer:ctor()
	
end

function MainTaskLayer:init()
	self:InitComponents();
	self:InitEventHandlers();
	return true;
end

function MainTaskLayer:InitComponents()
	self.rootNode=cc.CSLoader:createNode("LY_MainMenu2.csb");
	self:addChild(self.rootNode);
end

function MainTaskLayer:InitEventHandlers()
	local btn=self:GetButton1();
	btn:addTouchEventListener(function(sender,etype)
		if etype==2 then
			if(self.NextSceneCalled~=nil) then
				self.NextSceneCalled(1);
			end	
		end
	end);
	local btn2=self:GetButton2();
	btn2:addTouchEventListener(function(sender,etype)
		if etype==2 then
			MessageBoxShow(self,"",0);
		end
	end);
	local btn3=self:GetButton3();
	btn3:addTouchEventListener(function(sender,etype)
		if etype==2 then
			MessageBoxShow(self,"",0);
		end
	end);
end

function MainTaskLayer:GetButton1()
	local ctrl0=self.rootNode:getChildByTag(89);
	local ctrl1=ctrl0:getChildByTag(92);
	return ctrl1;
end

function MainTaskLayer:GetButton2()
	local ctrl0=self.rootNode:getChildByTag(89);
	local ctrl1=ctrl0:getChildByTag(94);
	return ctrl1;
end

function MainTaskLayer:GetButton3()
	local ctrl0=self.rootNode:getChildByTag(89);
	local ctrl1=ctrl0:getChildByTag(95);
	return ctrl1;
end

