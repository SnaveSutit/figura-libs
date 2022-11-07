local newClass = require("libs/newClass")

local bones = {}

---Houses and ticks BoneAnimators
--- @class Animation
local Animation =
	newClass {
	--- Creates a new Animation class instance
	--- @param self Animation
	---@param args {animators: {any: BoneAnimator}}
	constructor = function(self, args)
		self.animators = args.animators or {}
	end,
	tick = function(self)
		for _, v in pairs(self.animators) do
			v:tick()
		end
	end
}

--- Animates a single bone
--- @class BoneAnimator
local BoneAnimator =
	newClass {
	--- Creates a new BoneAnimator class instance
	--- @param self BoneAnimator
	---@param args {bone: Bone, blend_weight: number, pos_func?: function, rot_func?: function, scl_func?: function}
	constructor = function(self, args)
		self.bone = args.bone
		self.blend_weight = args.blend_weight or 0.5
		self.pos_func = args.pos_func
		self.rot_func = args.rot_func
		self.scl_func = args.scl_func
	end,
	tick = function(self)
		self.bone:update(self)
	end
}

--- Houses a single model group/part for use in a BoneAnimator
--- @class Bone
local Bone =
	newClass {
	--- Creates a new Bone class instance
	--- @param self Bone
	--- @param args {part: CustomModelPart}
	constructor = function(self, args)
		self.part = args.part
		self.pos = {
			last = vec(0, 0, 0),
			next = vec(0, 0, 0),
			touched = false
		}
		self.rot = {
			last = vec(0, 0, 0),
			next = vec(0, 0, 0),
			touched = false
		}
		self.scl = {
			last = vec(1, 1, 1),
			next = vec(1, 1, 1),
			touched = false
		}
		bones[self.part:getName()] = self
	end,
	update = function(self, animator)
		if (animator.pos_func) then
			if (self.pos.touched) then
				self.pos.next =
					math.lerp(self.pos.next, animator.pos_func(self), animator.blend_weight)
			else
				self.pos.next = animator.pos_func(self)
				self.pos.touched = true
			end
		end
		if (animator.rot_func) then
			if (self.rot.touched) then
				self.rot.next =
					math.lerp(self.rot.next, animator.rot_func(self), animator.blend_weight)
			else
				self.rot.next = animator.rot_func(self)
				self.rot.touched = true
			end
		end
		if (animator.scl_func) then
			if (self.scl.touched) then
				self.scl.next =
					math.lerp(self.scl.next, animator.scl_func(self), animator.blend_weight)
			else
				self.scl.next = animator.scl_func(self)
				self.scl.touched = true
			end
		end
	end,
	tick = function(self)
		self.pos.last = self.pos.next
		self.rot.last = self.rot.next
		self.scl.last = self.scl.next
		self.pos.touched = false
		self.rot.touched = false
		self.scl.touched = false
	end,
	render = function(self, delta)
		if (self.pos.touched) then
			self.part:setPos(math.lerp(self.pos.last, self.pos.next, delta))
		end
		if (self.rot.touched) then
			self.part:setRot(math.lerp(self.rot.last, self.rot.next, delta))
		end
		if (self.scl.touched) then
			self.part:setScl(math.lerp(self.scl.last, self.scl.next, delta))
		end
	end,
	getWorldPos = function(self)
		local pos4 = self.part:partToWorldMatrix():transpose():getRow(4)
		return vec(pos4.x, pos4.y, pos4.z)
	end
}

events.TICK:register(
	function()
		-- if not player:exists() then
		-- 	return
		-- end
		for _, v in pairs(bones) do
			v:tick()
		end
	end
)

events.RENDER:register(
	function(delta)
		-- if not player:exists() then
		-- 	return
		-- end
		for _, v in pairs(bones) do
			v:render(delta)
		end
	end
)

--- SnaveSutit's Animator lib
---
--- Handles all of the repetitive heavy lifting when creating math-based animations
--- @module "animator"
local animator = {
	Animation = Animation,
	BoneAnimator = BoneAnimator,
	Bone = Bone,
	bones = bones
}
return animator
