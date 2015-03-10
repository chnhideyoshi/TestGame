
function GetStartScene()
	prints("load start scene!")
	local sceneGame = cc.Scene:create()
	local layer= MainMenuLayer.create();
	layer.NextSceneCalled=function(type)
		if type == 1 then
			cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.1,GetTaskScene()))
		end
		if type == 4 then
			cc.Director:getInstance():endToLua();
		end
	end;
	sceneGame:addChild(layer);
	prints("load start scene cmp")
	return sceneGame;
end

function GetTaskScene()
	prints("load task scene!")
	local sceneGame = cc.Scene:create()
	local layer= MainTaskLayer.create();
	layer.NextSceneCalled=function(type)
		if type == 1 then
			cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.1,GetMainScene()))
		end
	end;
	sceneGame:addChild(layer);
	prints("load start scene cmp")
	return sceneGame;
end

function GetMainScene()
	prints("load main scene!")
	local sceneGame = cc.Scene:create()
	local layer= MapLayer.create();
	layer.MapEnd=function(result)
		prints("MapEnd")
		if result then
			MessageBoxShow(layer,"胜利啦~",1,function()
				cc.Director:getInstance():resume();
				cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.1,GetStartScene()))
			end)
			
		else
			MessageBoxShow(layer,"失败咯~",2,function()
				cc.Director:getInstance():resume();
				cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.1,GetStartScene()))
			end)
		end
	end
	PlayMusic("Sound//map1.mp3");
	sceneGame:addChild(layer);
	prints("load main scene cmp!")
	return sceneGame;
end