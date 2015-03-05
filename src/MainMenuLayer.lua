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
	local this=self;
	local startButtonClickedCallback=function(node,type)
		print(type);
		if(self.NextSceneCalled~=nil) then
			self.NextSceneCalled(1);
		end	
	end
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerMouse:create();
    listener:registerScriptHandler(startButtonClickedCallback, cc.Handler.EVENT_MOUSE_DOWN);
    dispatcher:addEventListenerWithSceneGraphPriority(listener,btn);
	
end

function MainMenuLayer:SetNextSceneCalledCallBack(callback)
	self.NextSceneCalled=callback;
end

function MainMenuLayer:GetStartButton()
	local ctrl0=self.rootNode:getChildByTag(143);
	local ctrl1=ctrl0:getChildByTag(145);
	return ctrl1;
end

return MainMenuLayer
