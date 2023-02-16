local util = require('libs.util')
local boneMap = require('libs.boneMap')
local elapsedTime
local lastTime = util.seconds
local leftOverTime = 0

local rope = {
	boneMap.rope_segment0,
	boneMap.rope_segment1,
	boneMap.rope_segment2,
	boneMap.rope_segment3,
}

events.TICK:register(
	function()
		if not player:isLoaded() then return end
		elapsedTime = lastTime - util.seconds
		lastTime = util.seconds

		elapsedTime = elapsedTime + leftOverTime

		local timesteps = math.floor(elapsedTime / 20)
		leftOverTime = elapsedTime - timesteps * 20

		local matrix = boneMap.rope_anchor.part:partToWorldMatrix()
		local ropePos = matrix:getColumn(4)
		ropePos = vec(ropePos.x, ropePos.y, ropePos.z) * 16
		local playerPos = player:getPos()
		-- log(playerPos)
		-- log(ropePos)
		boneMap.rope_segment0.pos.next = ropePos

		for i = 0, timesteps, 1 do
			for k, v in pairs(rope) do
				--
				-- log(k)

			end
		end
	end
)

events.RENDER:register(
	function(delta)
		if not player:isLoaded() then return end
		for k, v in pairs(rope) do
			v.part:setPos(math.lerp(v.pos.last, v.pos.next, delta))
		end
	end
)
