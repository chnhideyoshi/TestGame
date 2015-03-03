MapLayer = class("MapLayer",function()
    return cc.Layer:create();

end)

function MapLayer.createLayer()
	local layer=MapLayer.new()
	layer:init()
	return layer;
end

function MapLayer:ctor()
	
end

function MapLayer:init()
	self:InitDefaultParms();
	self:InitComponents();
	self:InitEventHandlers();
	self:InitPlayer();
	self:InitMonsters();
	self:InitUpdate();
	return true;
end

function MapLayer:InitDefaultParms()
	self.movementYBound0 = 80;
	self.movementYBound1 = 323;
	self.movementXOffsetThreshold = 200;
	
end

function MapLayer:InitComponents()
	print("InitComponents")
	self.rootNode=cc.CSLoader:createNode("LY_Map.csb");
	self:addChild(self.rootNode);
	self.mapPanel=self.rootNode:getChildByTag(102);
	print("~InitComponents")
end

function MapLayer:InitEventHandlers()
	print("InitEventHandlers")

	print("~InitEventHandlers")
end

function MapLayer:InitPlayer()
	print("InitPlayer")
	self.player=PlayerNode.createPlayer();
	self.player:setAnchorPoint(0.5,0.35);
	self.player:setPosition(400, 200);
	self.mapPanel:addChild(self.player);
	self.player:SetOnceState(O_STATE_WELOME);
	print("~InitPlayer")

end

function MapLayer:InitMonsters()
	print("InitMonsters")
	
	print("~InitMonsters")

end

function MapLayer:InitUpdate()
	self:scheduleUpdateWithPriorityLua(function(dt)
		local inAni = self.player.curOState ~= O_STATE_NONE;
		local inMove = not (self.player.curDirectionX==0 and self.player.curDirectionY==0)
		if not inAni then
			if inMove then
				self:ManagePlayerMovement();
			end
		end
		
    end,0)
end

function MapLayer:ManagePlayerMovement()
	local movementXOffsetThreshold=self.movementXOffsetThreshold;
	local curPosX,curPosY=self.player:getPosition();
	local controlspeedrate=self.player.speed;
	local curDirectionX=self.player.curDirectionX;
	local curDirectionY=self.player.curDirectionY;
	local curBakPosX,curBakPosY=self.mapPanel:getPosition();
	local backSize=self.mapPanel:getContentSize();
	local visibleSize=cc.Director:getInstance():getVisibleSize();
	local newx=curPosX + controlspeedrate*curDirectionX;
	local newy=curPosY + controlspeedrate*curDirectionY;
	local newbackx=curBakPosX;
	if newy> self.movementYBound1 or newy < self.movementYBound0 then
		newy=curPosY;
	end
	if newx<=0 or newx>= backSize.width then
		newx=curPosX;
	end
	self.player:setPosition(newx,newy);
	
	local screenPosX=newx+curBakPosX;
	if screenPosX< movementXOffsetThreshold then
		if curBakPosX<0 then
			newbackx=curBakPosX-controlspeedrate*curDirectionX;
		end
	end
	if screenPosX>visibleSize.width-movementXOffsetThreshold then
		if curBakPosX>visibleSize.width-backSize.width then
			newbackx=curBakPosX-controlspeedrate*curDirectionX;
		end
	end
	self.mapPanel:setPosition(newbackx,curBakPosY);
end

return MapLayer