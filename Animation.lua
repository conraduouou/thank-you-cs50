--[[
    A class file that handles animation
]]
Animation = Class {}

-- a function that accepts parameters
function Animation:init(params)
    
    self.texture = params.texture       -- spritesheet to be used for animation
    self.frames = params.frames         -- quads generated from the spritesheet
    self.interval = params.interval or 0.05     -- interval between frames
    
    self.timer = 0      -- timer that tracks whether to skip or not
    self.currentFrame = 1       -- the index of self.frames

end

-- returns currentFrame data
function Animation:getcurrentFrame()
    return self.frames[self.currentFrame]
end

-- restarts animation when called
function Animation:restart()
    self.timer = 0
    self.currentFrame = 1
end

-- updates animation and loops it
function Animation:update(dt)
    self.timer = self.timer + dt

    -- if frames table does not contain any more than 1
    if #self.frames == 1 then
        return self.currentFrame
    else
        while self.timer > self.interval do

            self.timer = self.timer - self.interval     -- to take into account the time it takes in between frames

            self.currentFrame = (self.currentFrame + 1) % (#self.frames + 1)        -- the looping of animations in frames table

            if self.currentFrame == 0 then self.currentFrame = 1 end        -- if self.currentFrame equals 0 when modulus is used
        end
    end
end