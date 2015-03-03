
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

-- CC_USE_DEPRECATED_API = true
require "cocos.init"

require("Tools")
require("MainMenuLayer")
require("PlayerNode")
require("MonsterNodes")
require("SkillNodes")
require("MapLayer")
require("Scenes")

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end


local function GetTestLayer()
	local layer=cc.Layer:create();
	local sp=cc.Sprite:create("Sprites//reimud.png");
	sp:setPosition(100,200);
	sp:setAnchorPoint(0.5,0.5);
	local ac1=cc.MoveBy:create(1,cc.p(50,50));
	local ac2=cc.ScaleTo:create(1,2,2);
	local out="asd";
	local ac3=cc.CallFunc:create(function(node,value)
		print("is "..out.." and "..value.x);
	end,{x=1,y=2});
	
	layer:addChild(sp);
	
	layer:scheduleUpdateWithPriorityLua(function(dt)
       --print("nima");
    end,0)
	
	local function onKeyPressed(keyCode, event)
		print("1111");
	end
	local function onKeyReleased(keyCode, event)
		print("2222");
	end
	
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener,layer);
	
	local frameCache = cc.SpriteFrameCache:getInstance();
	frameCache:addSpriteFrames("Sprites//reimu2.plist","Sprites//reimu2.png");
	
	local function createWithSingleFrameName(name,delay,loop)
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
	
	local animation=createWithSingleFrameName("reimu_stand_",0.1,-1);
	local animate=cc.Animate:create(animation);
	--local ac=cc.Sequence:create(animate,ac1,ac2,ac3);
	sp:runAction(animate);
	

	
	
	return layer;
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    -- initialize director
    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    if nil == glview then
        glview = cc.GLViewImpl:createWithRect("cocos2dx homework (lua version) -chenyuexi", cc.rect(0,0,960,640))
        director:setOpenGLView(glview)
    end
    glview:setDesignResolutionSize(960, 640, cc.ResolutionPolicy.NO_BORDER)
    director:setDisplayStats(false)
    director:setAnimationInterval(1.0 / 60)
    local schedulerID = 0
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
	local sceneGame=GetStartScene();
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(sceneGame)
    else
        cc.Director:getInstance():runWithScene(sceneGame)
    end

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
