function update(hip, knee, foot, target)
	local safty = 0.01
	local len_femur = (knee - hip):length()
	local len_tibia = (knee - foot):length()
	local len_leg = math.clamp(
		(target - hip):length(), safty, len_femur + len_tibia - safty
	)

	local theta = math.atan(target.z / target.y)

	local knee_angle = (len_femur * len_femur) + (len_tibia * len_tibia)
		                   - (len_leg * len_leg)
	knee_angle = knee_angle / (2 * len_femur * len_tibia)
	knee_angle = math.acos(knee_angle)

	local alpha = (len_femur * len_femur) + (len_leg * len_leg)
		              - (len_tibia * len_tibia)
	alpha = alpha / (2 * len_femur * len_leg)
	alpha = math.acos(alpha)

	local beta = math.atan(target.x / target.y)

	local hip_angle = math.pi + alpha + beta

	return {
		theta = theta * 180 / math.pi,
		hip_angle = hip_angle * 180 / math.pi,
		knee_angle = knee_angle * 180 / math.pi,
	}
end

return update
