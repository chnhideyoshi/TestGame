function createWithSingleFrameName(name,delay,loop)
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