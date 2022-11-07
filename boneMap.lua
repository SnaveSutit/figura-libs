local animator = require("libs/animator")
local boneMap = {}
local function mapBones(t)
	for _, v in pairs(t:getChildren()) do
		if (v:getType() == "GROUP") then
			boneMap[v:getName()] = animator.Bone:new {part = v}
			mapBones(v)
		end
	end
end
mapBones(models)
-- log('boneMap:', boneMap)
return boneMap
