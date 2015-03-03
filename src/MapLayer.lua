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
	return true;
end

function MapLayer:InitDefaultParms()
	
	
end

function MapLayer:InitComponents()
	print("InitComponents")
	self.rootNode=cc.CSLoader:createNode("LY_Map.csb");
	self:addChild(self.rootNode);
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
	self.player:setPosition(100,100);
	self:addChild(self.player);
	print("~InitPlayer")

end

function MapLayer:InitMonsters()
	print("InitMonsters")
	
	print("~InitMonsters")

end

return MapLayer