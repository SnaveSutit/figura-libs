local animator = require("libs/animator")
local boneMap = {}
local function mapBones(t)
	for _, v in pairs(t:getChildren()) do
		if (type(v) == "userdata" and v:getType() == "GROUP") then
			boneMap[v.name] = animator.Bone:new {part = v}
			mapBones(v)
		end
	end
end
mapBones(models)
-- log('boneMap:', boneMap)
return boneMap
