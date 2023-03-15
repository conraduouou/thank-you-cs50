--[[
    Stage1 class
    Also the determiner of gravity, ground, overall layout, and other positions.
]]

require 'Util'
require 'Player'

Stage1 = Class{}

-- map.png quad names
EMPTY = 4
BRICK = 1

UNDER1 = 2
UNDER2 = 3

GROUND1 = 5
GROUND2 = 6
GROUND3 = 7
GROUND4 = 8

local SCROLL_SPEED = 120

function Stage1:init()

    self.spritesheet = love.graphics.newImage('graphics/map.png') -- texture to be used for map

    self.player = Player(self)

    self.tileWidth = 16     -- tile width
    self.tileHeight = 16    -- tile height

    self.mapWidth = 40      -- map width in tiles
    self.mapHeight = 28     -- map height in tiles

    self.mapWidthPixels = self.mapWidth * self.tileWidth        -- map width in pixels
    self.mapHeightPixels = self.mapHeight * self.tileHeight     -- map height in pixels
    
    self.tiles = {}     -- table of tiles that contains TILE DATA in map
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)     -- table of generated quads from spritesheet

    self.camX = 0       -- camera x position
    self.camY = 0       -- camera y position

    self.player.x = self.tileWidth * 2
    self.player.y = self.tileHeight * (self.mapHeight / 2 - 1) - self.player.height

    -- fill the map with EMPTY tiles first
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            self:setTile(x, y, EMPTY)
        end
    end

    -- fill lower half of map with BRICK tiles
    for y = self.mapHeight / 2, self.mapHeight do
        for x = 1, self.mapWidth do
            self:setTile(x, y, BRICK)
        end
    end

    local x = 1
    while x < self.mapWidth do

        if x == 5 then
            for j = x, x + 5 do
                self:setTile(j, self.mapHeight / 2 - 5, math.random(GROUND1, GROUND4))
                self:setTile(j, self.mapHeight / 2 - 4, math.random(UNDER1, UNDER2))
            end
            x = x + 5
        end
            
        x = x + 1
    end

end

-- gets tile information from PIXELS
function Stage1:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end

-- function that stores tile information in a 1-dimensional way in an array, only to be
-- acquired after to render the map
function Stage1:setTile(x, y, tile)
    self.tiles[(y - 1) * self.mapWidth + x] = tile
end

-- gets tile information from TILES array
function Stage1:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- determines if tile get is collidable or not
function Stage1:collides(tile)

    -- collidables table
    local collidables = {
        BRICK, GROUND1, GROUND2, GROUND3, GROUND4
    }

    -- for every key value pair in iterated pairs (or table) do..
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

-- called each frame
function Stage1:update(dt)

    -- shift cam x position accordingly to player x position
    self.camX = math.max(0,
        math.min(self.player.x - VIRTUAL_WIDTH / 4,
            math.min(self.player.x, self.mapWidthPixels - VIRTUAL_WIDTH)))

    if self.player.x <= 0 then
        self.player.x = 0
    end
    
    if self.player.x + self.player.width >= self.mapWidthPixels then
        self.player.x = self.mapWidthPixels - self.player.width
    end

    self.player:update(dt)
    
end

-- renders the stage
function Stage1:render()

    -- draw whole stage from TILES array using love.graphics.draw
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)], 
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
        end
    end

    self.player:render()
    
end