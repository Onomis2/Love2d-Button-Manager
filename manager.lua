--local buttons = require 'buttonManager.buttons'

local manager = {}
local buttons = {}

local function withinBounds(x, y, bounds)
    return x >= bounds.x and x <= bounds.x + bounds.width and y >= bounds.y and y <= bounds.y + bounds.height
end

function manager.mousepressed(id, x, y, click)
    if click ~= 1 then return end

    local function handleButton(button)
        if withinBounds(x, y, button) then
            if button.click then
                button.click()
            end
        end
    end

    if not id then
        for _, button in pairs(buttons) do
            handleButton(button)
        end
    elseif type(id) == "table" then
        for _, singleId in ipairs(id) do
            if buttons[singleId] then
                handleButton(buttons[singleId])
            end
        end
    else
        if buttons[id] then
            handleButton(buttons[id])
        end
    end
end

function manager.draw(id)
    local function drawButton(button)
        if not button.img then
            love.graphics.setColor(button.color[1], button.color[2], button.color[3], button.color[4])
            love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        else
            love.graphics.setColor(button.color[1], button.color[2], button.color[3], button.color[4])
            love.graphics.draw(button.img.image, button.x, button.y, 0, button.width / button.img.image:getWidth(), button.height / button.img.image:getHeight())
        end
        if button.text then
            if button.text.font then love.graphics.setFont(button.text.font) end
            love.graphics.setColor(button.text.color[1], button.text.color[2], button.text.color[3], button.text.color[4])
            love.graphics.print(button.text.text, button.x + button.text.padX, button.y + button.text.padY)
        end
    end

    if not id then
        for _, button in pairs(buttons) do
            drawButton(button)
        end
    elseif type(id) == "table" then
        for _, singleId in ipairs(id) do
            if buttons[singleId] then
                drawButton(buttons[singleId])
            end
        end
    else
        if buttons[id] then
            drawButton(buttons[id])
        end
    end
end

function manager.create(id, data, click)
    local errors = {}

    -- Validate parameters
    if not id then
        table.insert(errors, "Button ID cannot be nil.")
    elseif buttons[id] then
        table.insert(errors, "Button ID already exists: " .. tostring(id))
    end

    if not data then
        table.insert(errors, "Button data cannot be nil.")
    else
        if not data.x then table.insert(errors, "Missing required field: x") end
        if not data.y then table.insert(errors, "Missing required field: y") end
        if not data.width then table.insert(errors, "Missing required field: width") end
        if not data.height then table.insert(errors, "Missing required field: height") end
        if data.image then
            if not data.image.img then table.insert(errors, "Missing required field: image.img") end
        end
    end

    -- Display errors and refuse to create button
    if #errors > 0 then
        print("[ButtonManager] ERROR in button: '" .. tostring(id) .. "':")
        for _, err in ipairs(errors) do
            print("  - " .. err)
        end
        return
    end

    -- Add button to buttons list
    buttons[id] = {
        x = data.x,
        y = data.y,
        width = data.width,
        height = data.height,
        color = data.color or {1,1,1,1},
        text = data.text,
        click = click
    }
    if data.text then
        buttons[id].text = {
            font = data.text.font or nil,
            text = data.text.text or "",
            padX = data.text.padX or 0,
            padY = data.text.padY or 0,
            color = data.text.color or {1,1,1,1}
        }
    end
    if data.image and data.image.img then
        buttons[id].img = {
            image = data.image.img
        }
    end
end

function manager.delete(id)
    local function deleteButton(id)
        buttons[id] = nil
    end

    if not id then
        for id, _ in pairs(buttons) do
            deleteButton(id)
        end
    elseif type(id) == "table" then
        for _, singleId in ipairs(id) do
            deleteButton(singleId)
        end
    else
        deleteButton(id)
    end
end

return manager