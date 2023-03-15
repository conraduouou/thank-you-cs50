--[[
    > A .lua file that contains utilities of my game
    > for now, this contains the function to chop up my spritesheet into quads
]]

function generateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local sheetcounter = 1
    local quads = {}

    for y = 0, sheetHeight - 1 do 
        for x = 0, sheetWidth - 1 do 
            quads[sheetcounter] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
            sheetcounter = sheetcounter + 1
        end
    end

    return quads
end