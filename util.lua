--- A utility library
--- @module "util"
local util = {
	-- Ticks passed since the script started
	ticks = 0,
	--- Seconds passed since the script started
	seconds = 0,
	--- Blocks traveled since script started
	distance2D = 0, -- XYZ
	distance3D = 0, -- XZ
	--- Player's velocity
	velocity2D = vec(0, 0, 0),
	velocity3D = vec(0, 0, 0)
}

local function update()
	util.velocity3D = player:getVelocity()
	util.velocity2D = vec(util.velocity3D.x, util.velocity3D.z)
	util.distance3D = util.distance3D + util.velocity3D:length()
	util.distance2D = util.distance2D + util.velocity2D:length()
end
--- Returns the player's current x/y/z speed
--- @return number
local function getSpeed3D()
	return util.velocity3D:length()
end
--- Returns the player's current x/z speed
--- @return number
local function getSpeed2D()
	return util.velocity2D:length()
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
local function getFBDot()
	local a = util.velocity2D:copy():normalized()
	local b = fromAngle(math.rad(player:getBodyYaw() + 90), 1)
	return a:dot(b)
end
--- Returns a value of -1 to 1 describing the players movement left-to-right relative to their look direction
--- @return number
local function getLRDot()
	local a = util.velocity2D:copy():normalized()
	local b = fromAngle(math.rad(player:getBodyYaw()), 1)
	return a:dot(b)
end

local function clampVector(v, min, max)
	return vec(
		math.clamp(v.x, min.x, max.x),
		math.clamp(v.y, min.y, max.y),
		math.clamp(v.z, min.z, max.z)
	)
end

events.TICK:register(
	function()
		util.ticks = util.ticks + 1
		util.seconds = util.ticks / 20
		if (player:isLoaded()) then
			update()
		end
	end
)

-- Exports
util.getSpeed3D = getSpeed3D
util.getSpeed2D = getSpeed2D
util.getFBDot = getFBDot
util.getLRDot = getLRDot
util.clampVector = clampVector
return util
