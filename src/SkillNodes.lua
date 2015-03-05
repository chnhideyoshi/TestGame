SkillNode = class("SkillNode",function()
    return cc.Layer:create();

end)

function SkillNode.create()
	local layer=SkillNode.new()
	layer:init()
	return layer;
end

function SkillNode:ctor()
	
end

function SkillNode:init()
	self:InitComponents();
	self:InitEventHandlers();
	return true;
end

function SkillNode:InitComponents()
	print("InitComponents")
	
	print("~InitComponents")
end

function SkillNode:InitEventHandlers()
	print("InitEventHandlers")
	
	print("~InitEventHandlers")
end


return SkillNode