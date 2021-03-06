--- A utility library
--- @module "util"
local util = {
	-- Ticks passed since the script started
	ticks = 0,
	--- Seconds passed since the script started
	seconds = 0,
	--- How far the player has moved on x/y/z axis since the script started
	playerDistanceTraveled3D = 0,
	--- How far the player has moved on x/z axis since the script started
	playerDistanceTraveled2D = 0
}

local playerPos = {
	last = player:getPos(),
	next = player:getPos()
}
--- The player's x/y/z velocity
local playerVelocity3D = vec(0, 0, 0)
--- The player's x/z velocity
local playerVelocity2D = vec(0, 0)

local function updatePlayerVelocity()
	playerPos.last = playerPos.next
	playerPos.next = player:getPos()
	playerVelocity3D = playerPos.last - playerPos.next
	playerVelocity2D = vec(playerVelocity3D.x, playerVelocity3D.z)
	util.playerDistanceTraveled3D = util.playerDistanceTraveled3D + playerVelocity3D:length()
	util.playerDistanceTraveled2D = util.playerDistanceTraveled2D + playerVelocity2D:length()
end
--- Returns the player's current x/y/z speed
--- @return number
local function getPlayerSpeed3D()
	return playerVelocity3D:length()
end
--- Returns the player's current x/z speed
--- @return number
local function getPlayerSpeed2D()
	return playerVelocity2D:length()
end
--- Returns the player's current vertical speed
--- @return number
local function getPlayerSpeedVertical()
	return playerVelocity3D.y
end
--- Creates a new Vector2 from an angle and magnitude
--- @param angle number
--- @param mag number
--- @return Vector2
local function fromAngle(angle, mag)
	return vec(math.cos(angle) * mag, math.sin(angle) * mag)
end
--- Returns a value of -1 to 1 describing the players movement back-to-forth relative to their look direction
--- @return number
local function getPlayerForthBackMovement()
	local a = playerVelocity2D:copy():normalized()
	local b = fromAngle(math.rad(player:getBodyYaw() + 90), 1)
	return a:dot(b)
end
--- Returns a value of -1 to 1 describing the players movement left-to-right relative to their look direction
--- @return number
local function getPlayerLeftRightMovement()
	local a = playerVelocity2D:copy():normalized()
	local b = fromAngle(math.rad(player:getBodyYaw()), 1)
	return a:dot(b)
end

events.TICK:register(
	function()
		util.ticks = util.ticks + 1
		util.seconds = util.ticks / 20
		updatePlayerVelocity()
	end
)

-- Exports
util.playerPos = playerPos
util.playerVelocity3D = playerVelocity3D
util.playerVelocity2D = playerVelocity2D
util.getPlayerSpeed3D = getPlayerSpeed3D
util.getPlayerSpeed2D = getPlayerSpeed2D
util.getPlayerForthBackMovement = getPlayerForthBackMovement
util.getPlayerLeftRightMovement = getPlayerLeftRightMovement
util.getPlayerSpeedVertical = getPlayerSpeedVertical
return util
