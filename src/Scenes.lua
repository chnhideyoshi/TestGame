
function GetStartScene()
	prints("load start scene!")
	local sceneGame = cc.Scene:create()
	local layer= MainMenuLayer.create();
	local callback=function(type)
		cc.MessageBox("","");
		
		if type == 1 then
			cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.2,GetMainScene()))
		end
		if type == 4 then
			cc.Director:getInstance():endToLua();
		end
	end;
	layer.NextSceneCalled=callback;
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
		StopMusic();
		if result then
			cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.2,GetStartScene()))
		else
			cc.Director:getInstance():replaceScene(cc.TransitionProgressInOut:create(0.2,GetStartScene()))
		end
	end
	PlayMusic("Sound//map1.mp3");
	sceneGame:addChild(layer);
	prints("load main scene cmp!")
	return sceneGame;
end