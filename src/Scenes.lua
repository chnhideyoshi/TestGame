
function GetStartScene()
	print("load start scene!")
	local sceneGame = cc.Scene:create()
	local layer= MainMenuLayer.createLayer();
	local callback=function(type)
		if type == 1 then
			cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.2,GetMainScene()))
		end
		if type == 4 then
			cc.Director:getInstance():endToLua();
		end
	end;
	layer.NextSceneCalled=callback;
	sceneGame:addChild(layer);
	print("load start scene cmp")
	return sceneGame;
end

function GetMainScene()
	print("load main scene!")
	local sceneGame = cc.Scene:create()
	local layer= MapLayer.createLayer();
	local callback=function(type)
		if type == 1 then
			cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.2,GetStartScene()))
		end
		if type == 4 then
			cc.Director:getInstance():endToLua();
		end
	end;
	layer.NextSceneCalled=callback;
	sceneGame:addChild(layer);
	print("load main scene cmp!")
	return sceneGame;
end