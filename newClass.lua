
--- Creates a metatable "class"
--- @param class table
--- @return table
local function newClass(class)
	class.__index = class
	class.new = function(self, args)
		local this = setmetatable({}, self)
		this:constructor(args)
		return this
	end
	return class
end
-- local Test = newClass {
-- 	constructor = function(self, args)
-- 		self.name = args.name
-- 	end
-- }
-- Test:new{name = 'MyName!'}

return newClass