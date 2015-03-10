MainMenuLayer = class("MainMenuLayer",function()
    return cc.Layer:create();

end)


function MainMenuLayer.create()
	local layer=MainMenuLayer.new()
	layer:init()
	return layer;
end

function MainMenuLayer:ctor()
	
end

function MainMenuLayer:init()
	self:InitComponents();
	self:InitEventHandlers();
	return true;
end

function MainMenuLayer:InitComponents()
	self.rootNode=cc.CSLoader:createNode("LY_MainMenu.csb");
	self:addChild(self.rootNode);
end

function MainMenuLayer:InitEventHandlers()
	local btn=self:GetStartButton();
	btn:addTouchEventListener(function(sender,etype)
		if etype==2 then
			if(self.NextSceneCalled~=nil) then
				self.NextSceneCalled(1);
			end	
		end
	end);
	local btnclose=self:GetCloseButton();
	btnclose:addTouchEventListener(function(sender,etype)
		if etype==2 then
			if(self.NextSceneCalled~=nil) then
				self.NextSceneCalled(4);
			end	
		end
	end);
	local btncontinue=self:GetContinueButton();
	btncontinue:addTouchEventListener(function(sender,etype)
		if etype==2 then
			MessageBoxShow(self,"",0);
		end
	end);
	
	local btnset=self:GetSettingsButton();
	btnset:addTouchEventListener(function(sender,etype)
		if etype==2 then
			MessageBoxShow(self,"",0);
		end
	end);
end

function MainMenuLayer:GetStartButton()
	local ctrl0=self.rootNode:getChildByTag(143);
	local ctrl1=ctrl0:getChildByTag(145);
	return ctrl1;
end

function MainMenuLayer:GetContinueButton()
	local ctrl0=self.rootNode:getChildByTag(143);
	local ctrl1=ctrl0:getChildByTag(147);
	return ctrl1;
end

function MainMenuLayer:GetSettingsButton()
	local ctrl0=self.rootNode:getChildByTag(143);
	local ctrl1=ctrl0:getChildByTag(148);
	return ctrl1;
end

function MainMenuLayer:GetCloseButton()
	local ctrl0=self.rootNode:getChildByTag(143);
	local ctrl1=ctrl0:getChildByTag(149);
	return ctrl1;
end

return MainMenuLayer
