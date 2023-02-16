local newClass = require 'libs.newClass'

local bones = {}

--- @class MathAnim
--- @field tick function
--- @field animators {[any]: BoneAnimator}
local MathAnim = newClass {
    --- @param self MathAnim
    --- @param args {animators: {[any]: BoneAnimator}}
    constructor = function(self, args) self.animators = args.animators or {} end,
    --- @param self MathAnim
    tick = function(self) for _, v in pairs(self.animators) do v:tick() end end
}

--- @class BoneAnimator
--- @field bone Bone
--- @field frameTime number
--- @field blendWeight number
--- @field posFunc? function
--- @field rotFunc? function
--- @field sclFunc? function
--- @field tick function
local BoneAnimator = newClass {
    --- @param self BoneAnimator
    --- @param args {bone: Bone, frameTime?: number, blendWeight?: number, posFunc?: function, rotFunc?: function, sclFunc?: function}
    constructor = function(self, args)
        self.bone = args.bone
        self.frameTime = args.frameTime or 1
        self.blendWeight = args.blendWeight or 0.5
        self.posFunc = args.posFunc
        self.rotFunc = args.rotFunc
        self.sclFunc = args.sclFunc
    end,
    --- @param self BoneAnimator
    tick = function(self) self.bone:update(self) end
}

--- @class Bone
--- @field part ModelPart
--- @field pos {last: Vector3, next: Vector3, touched: boolean}
--- @field rot {last: Vector3, next: Vector3, touched: boolean}
--- @field scl {last: Vector3, next: Vector3, touched: boolean}
--- @field update function
local Bone = newClass {
    --- @param self Bone
    --- @param args {part: ModelPart}
    constructor = function(self, args)
        self.part = args.part
        self.pos = {last = vec(0, 0, 0), next = vec(0, 0, 0), touched = false}
        self.rot = {last = vec(0, 0, 0), next = vec(0, 0, 0), touched = false}
        self.scl = {last = vec(0, 0, 0), next = vec(0, 0, 0), touched = false}
        bones[self.part:getName()] = self
    end,
    --- @param self Bone
    --- @param animator BoneAnimator
    update = function(self, animator)
        if animator.posFunc then
            if self.pos.touched then
                self.rot.next = math.lerp(self.rot.next, animator.rotFunc(self),
                                          animator.blendWeight)
            else

            end
        end
        if animator.rotFunc then end
        if animator.sclFunc then end
    end
}

