local util = {
	tick = 0,
	seconds = 0
}

local playerPos = {
	last = player:getPos(),
	next = player:getPos()
}
local playerVelocity3D = vec(0,0,0)
local playerVelocity2D = vec(0, 0)

local function updatePlayerVelocity()
	playerPos.last = playerPos.next
	playerPos.next = player:getPos()
	playerVelocity3D = playerPos.last - playerPos.next
	playerVelocity2D = vectors.vec(playerVelocity3D.x, playerVelocity3D.z)
end

local function getPlayerSpeed3D()
	return playerVelocity3D:length()
end
local function getPlayerSpeed2D()
	return playerVelocity2D:length()
end

local function getPlayerSpeedVertical()
	return playerVelocity3D.y
end

local function fromAngle(angle, mag)
	return vec(math.cos(angle) * mag, math.sin(angle) * mag)
end

local function getPlayerForthBackMovement()
	local a = playerVelocity2D:copy():normalized()
	local b = fromAngle(math.rad(player:getBodyYaw() + 90), 1)
	return a:dot(b)
end

local function getPlayerLeftRightMovement()
	local a = playerVelocity2D:copy():normalized()
	local b = fromAngle(math.rad(player:getBodyYaw()), 1)
	return a:dot(b)
end

local function classInit(self)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

events.TICK:register(
	function()
		util.tick = util.tick + 1
		util.seconds = util.tick / 20
		updatePlayerVelocity()
	end
)

-- Exports
util.classInit = classInit
util.playerPos = playerPos
util.playerVelocity3D = playerVelocity3D
util.playerVelocity2D = playerVelocity2D
util.getPlayerSpeed3D = getPlayerSpeed3D
util.getPlayerSpeed2D = getPlayerSpeed2D
util.getPlayerForthBackMovement = getPlayerForthBackMovement
util.getPlayerLeftRightMovement = getPlayerLeftRightMovement
util.getPlayerSpeedVertical = getPlayerSpeedVertical
return util
