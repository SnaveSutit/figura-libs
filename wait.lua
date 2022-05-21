-- local newClass = require('libs/newClass')

local schedule = {}
local clock = 0

local function wait(func, ticks)
	local time = clock + ticks
	if (schedule[time]) then
		table.insert(schedule[time], func)
	else
		schedule[time] = {func}
	end
end

events.TICK:register(
	function()
		clock = clock + 1
		local current = schedule[clock]
		if (current) then
			for _,v in pairs(current) do
				v()
			end
			schedule[clock] = nil
		end
	end
)

return wait
