-- MIT License

-- Copyright (c) 2025 Pixeltica

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.



function init(plugin)

    plugin:newCommand{
        id = "TileIndexOverlay",
        title = "New Tile Index Overlay Layer",
        group="layer_new",
		onenabled = function()
            return app.activeSprite ~= nil and #app.sprites > 0
        end,
		onclick=function() 
			createIndexOverlay() 
		end
    }
end

function exit(plugin)
end

function createIndexOverlay()
    local spr = app.activeSprite
    if not spr then
        app.alert("Please open a sprite first.")
        return
    end

    -- Load digit definition maps
    local digit_definitions = {
        [0] = {Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3), Point(0, 4), Point(1, 0), Point(1, 4), Point(2, 0),
               Point(2, 1), Point(2, 2), Point(2, 3), Point(2, 4)},
        [1] = {Point(0, 1), Point(1, 0), Point(1, 1), Point(1, 2), Point(1, 3), Point(1, 4)},
        [2] = {Point(0, 0), Point(0, 2), Point(0, 3), Point(0, 4), Point(1, 0), Point(1, 2), Point(1, 4), Point(2, 0),
               Point(2, 1), Point(2, 4)},
        [3] = {Point(0, 0), Point(0, 4), Point(1, 0), Point(1, 2), Point(1, 4), Point(2, 0), Point(2, 1), Point(2, 2),
               Point(2, 3), Point(2, 4)},
        [4] = {Point(0, 0), Point(0, 1), Point(0, 2), Point(1, 2), Point(2, 0), Point(2, 1), Point(2, 2), Point(2, 3),
               Point(2, 4), Point(2, 4)},
        [5] = {Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 4), Point(1, 0), Point(1, 2), Point(1, 4), Point(2, 0),
               Point(2, 3)},
        [6] = {Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3), Point(0, 4), Point(1, 0), Point(1, 2), Point(1, 4),
               Point(2, 0), Point(2, 2), Point(2, 3), Point(2, 4)},
        [7] = {Point(0, 0), Point(1, 0), Point(2, 0), Point(2, 1), Point(2, 2), Point(2, 3), Point(2, 4)},
        [8] = {Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3), Point(0, 4), Point(1, 0), Point(1, 2), Point(1, 4),
               Point(2, 0), Point(2, 1), Point(2, 2), Point(2, 3), Point(2, 4)},
        [9] = {Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 4), Point(1, 0), Point(1, 2), Point(1, 4), Point(2, 0),
               Point(2, 1), Point(2, 2), Point(2, 3), Point(2, 4)}
    }

    -- Get tile dimensions and colour
    local dlg = Dialog("Index Overlay Options")
    dlg:number{
        id = "tilewidth",
        label = "Tile Width (pixels):",
        text = "16"
    }
    dlg:number{
        id = "tileheight",
        label = "Tile Height (pixels):",
        text = "16"
    }

    -- Default colour to white
    dlg:color{
        id = "indexColor",
        label = "Index Color:",
        color = Color {
            r = 255,
            g = 255,
            b = 255,
            a = 255
        }
    }

    dlg:check{
        id = "includeContrastLayer",
        label = "Include a Contrast Background layer",
        selected = true
    }

    dlg:color{
        id = "tileContrastColor", 
        label = "Contrast Color:",
        color = Color {
            r = 0,
            g = 0,
            b = 0,
            a = 150
        }
    }

    dlg:button{
        id = "ok",
        text = "OK"
    }
    dlg:button{
        id = "cancel",
        text = "Cancel"
    }
    dlg:show()

    local data = dlg.data
    if not data.ok then
        return
    end

    local tileWidth = tonumber(data.tilewidth)
    local tileHeight = tonumber(data.tileheight)
    local indexColor = data.indexColor
	local tileContrastColor = data.tileContrastColor
    local includeContrastLayer = data.includeContrastLayer

    if not tileWidth or tileWidth <= 0 then
        app.alert("Invalid tile width.")
        return
    end
    if not tileHeight or tileHeight <= 0 then
        app.alert("Invalid tile height.")
        return
    end

    -- Check if the sprite is fully divisible
    if spr.width % tileWidth ~= 0 then
        app.alert("Cannot divide sprite width (" .. spr.width .. "px) by tile width (" .. tileWidth ..
                      "px) evenly.\nPlease crop or expand the sprite and try again.")
        return
    end
    if spr.height % tileHeight ~= 0 then
        app.alert("Cannot divide sprite height (" .. spr.height .. "px) by tile height (" .. tileHeight ..
                      "px) evenly.\nPlease crop or expand the sprite and try again.")
        return
    end

    -- Create a new temporary sprite of the same size
    local tempSpr = Sprite(spr.width, spr.height, ColorMode.RGBA)
    local tempCel = tempSpr:newCel(tempSpr.layers[1], 1, Image(spr.width, spr.height, ColorMode.RGBA), Point(0, 0))
    local tempImage = tempCel.image
    tempImage:clear()

	-- If contrast layer selected
	if includeContrastLayer then
        for y = 0, spr.height - 1, tileHeight do
            for x = 0, spr.width - 1, tileWidth do
                for rectY = 0, 12 do
                    for rectX = 0, 8 do
                        local pixelDrawX = x + rectX
                        local pixelDrawY = y + rectY
						if pixelDrawX >= 0 and pixelDrawX < spr.width and pixelDrawY >= 0 and pixelDrawY < spr.height then
                            tempImage:putPixel(pixelDrawX, pixelDrawY, tileContrastColor)
                        end
                    end
                end
            end
        end
		-- Copy contrast layer into the original sprite
        local contrastLayer = spr:newLayer()
        contrastLayer.name = "Contrast Background"
        local newCelForContrast = spr:newCel(contrastLayer, spr.frames[1], tempImage:clone(), Point(0,0))
        tempImage:clear()
    end


    -- Load index positioning offsets = 2 up 2 below
    local digit_positions_offsets = {
		{1, 1}, -- 1st
		{5, 1}, -- 2nd
		{1, 7}, -- 3rd
		{5, 7} -- 4th
    }

    -- Draw out the tile indexes on the temporary sprite
    local tileNumber = 0
    for y = 0, spr.height - 1, tileHeight do
        for x = 0, spr.width - 1, tileWidth do
            local tileNumberStr = string.format("%04d", tileNumber)

            for char_idx = 1, #tileNumberStr do
                if char_idx > #digit_positions_offsets then
                    break
                end

                local digitChar = string.sub(tileNumberStr, char_idx, char_idx)
                local digitValue = tonumber(digitChar)

                local points_for_digit = digit_definitions[digitValue]
                local base_offset = digit_positions_offsets[char_idx]

                if points_for_digit then
                    for _, p in ipairs(points_for_digit) do
                        local pixelX = x + base_offset[1] + p.x
                        local pixelY = y + base_offset[2] + p.y

                        -- Check bounds before drawing
                        if pixelX >= 0 and pixelX < spr.width and pixelY >= 0 and pixelY < spr.height then
                            tempImage:putPixel(pixelX, pixelY, indexColor)
                        end
                    end
                end
            end
            tileNumber = tileNumber + 1
        end
    end

	-- Copy overlay from temporary sprite to new layer on original sprite
    local overlayLayer = spr:newLayer()
	overlayLayer.name = "Tile Index Overlay"
    local originalCel = spr:newCel(overlayLayer, spr.frames[1], tempImage:clone(), Point(0, 0))

    -- Discard the temporary sprite
    tempSpr:close()

    app.refresh()
    app.alert("Tile Index Overlay layer(s) created successfully.")
end

function exit(plugin)
end
