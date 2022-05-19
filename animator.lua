local util = require("libs/util")

local bones = {}

---Houses and ticks BoneAnimators
--- @class Animation
local Animation = {
	__ANIMATION_CLASS = true,
	--- Creates a new Animation class instance
	--- @param self Animation
	---@param options {animators: {any: BoneAnimator}}
	new = function(self, options)
		local obj = util.classInit(self)

		obj.animators = options.animators or {}

		return obj
	end,
	tick = function(self)
		for _, v in pairs(self.animators) do
			v:tick()
		end
	end
}

--- Animates a single bone
--- @class BoneAnimator
local BoneAnimator = {
	__BONEANIMATOR_CLASS = true,
	--- Creates a new BoneAnimator class instance
	--- @param self BoneAnimator
	---@param options {bone: Bone, blendWeight: number, posFunc?: function, rotFunc?: function, sclFunc?: function}
	new = function(self, options)
		local obj = util.classInit(self)

		obj.bone = options.bone
		obj.blendWeight = options.blendWeight or 0.5
		obj.posFunc = options.posFunc
		obj.rotFunc = options.rotFunc
		obj.sclFunc = options.sclFunc

		return obj
	end,
	tick = function(self)
		self.bone:update(self)
	end
}

--- Houses a single model group/part for use in a BoneAnimator
--- @class Bone
local Bone = {
	__BONE_CLASS = true,
	--- Creates a new Bone class instance
	--- @param self Bone
	--- @param options {part: CustomModelPart}
	new = function(self, options)
		local obj = util.classInit(self)

		obj.part = options.part
		obj.pos = {
			last = vec(0, 0, 0),
			next = vec(0, 0, 0),
			touched = false
		}
		obj.rot = {
			last = vec(0, 0, 0),
			next = vec(0, 0, 0),
			touched = false
		}
		obj.scl = {
			last = vec(1, 1, 1),
			next = vec(1, 1, 1),
			touched = false
		}

		bones[obj.part.name] = obj

		return obj
	end,
	update = function(self, animator)
		if (animator.posFunc) then
			if (self.pos.touched) then
				self.pos.next = math.lerp(self.pos.next, animator.posFunc(self), animator.blendWeight)
			else
				self.pos.next = animator.posFunc(self)
				self.pos.touched = true
			end
		end
		if (animator.rotFunc) then
			if (self.rot.touched) then
				self.rot.next = math.lerp(self.rot.next, animator.rotFunc(self), animator.blendWeight)
			else
				self.rot.next = animator.rotFunc(self)
				self.rot.touched = true
			end
		end
		if (animator.sclFunc) then
			if (self.scl.touched) then
				self.scl.next = math.lerp(self.scl.next, animator.sclFunc(self), animator.blendWeight)
			else
				self.scl.next = animator.sclFunc(self)
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
	end
}

events.TICK:register(
	function()
		for _, v in pairs(bones) do
			v:tick()
		end
	end
)

events.RENDER:register(
	function(delta)
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
