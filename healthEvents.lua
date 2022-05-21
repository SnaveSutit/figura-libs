local newClass = require("libs/newClass")

local healthTracker =
	newClass(
	{
		--- A simple health event listener
		--- @param args {entity: LivingEntity}
		constructor = function(self, args)
			self.entity = args.entity
			self.onDamage = args.onDamage
			self.onHeal = args.onHeal
			self.onChange = args.onChange

			self.lastHealth = self.entity:getHealth()
			events.TICK:register(
				function()
					self:tick()
				end
			)
		end,
		tick = function(self)
			local health = self.entity:getHealth()
			local delta = health - self.lastHealth

			if (self.lastHealth > health) then
				if (self.onChange) then
					self.onChange(delta)
				end
				if (self.onDamage) then
					self.onDamage(delta)
				end
			elseif (self.lastHealth < health) then
				if (self.onChange) then
					self.onChange(delta)
				end
				if (self.onHeal) then
					self.onHeal(delta)
				end
			end

			self.lastHealth = health
		end
	}
)

return healthTracker
