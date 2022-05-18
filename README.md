
# Libraries (For figura rewrite 0.1.x)

## util.lua
Adds a bunch of useful utility functions, like player velocity, speed, and local direction

---
## boneMap.lua
### Requires
- animator.lua
- util.lua

Maps all groups in the avatar's models to a flat table to be accessed by name without having to change the accessor every time you update your bone structure:

`boneMap.bone_name` instead of `models.my_model.bone_1.bone_2.bone_name`

---
## animator.lua
### Requires
- util.lua

Provides animation, BoneAnimator, and Bone classes. Automatically does animation rendering, interpolation, and blending for math-based animations.

```lua
local animator = require('libs/animator')
local boneMap = require('libs/boneMap')
local util = require('libs/boneMap')

local animSpeed = 256
local myAnimation = animator.Animation:new{
	animators = {
		animator.BoneAnimator:new{
			bone = boneMap.my_bone,
			-- blendWeight is a value from 0 to 1. The larger it is the more priority this animation will have when blending on top of others
			blendWeight = 0.5,
			-- Pos, Rot, and Scl functions should return a vector.
			-- If any of these functions are not defined in the BoneAnimator's options, they will be ignored
			posFunc = function ()
				return vec(0,math.sin(util.seconds * animSpeed) * 5,0)
			end,
			rotFunc = function ()
				return vec(0,math.cos(util.seconds * animSpeed) * 45,0)
			end,
			sclFunc = function ()
				return vec(1,1,1)
			end
		}
	}
}

events.TICK:register(function ()
	-- Run the animation
	myAnimation:tick()
end)
```

---
#### Simlink (Win10+ Powershell)
Ignore this if you don't know what it is.

`New-Item -Type SymbolicLink -Name "libs" -Target "D:\github-repos\figura-libs\"`

