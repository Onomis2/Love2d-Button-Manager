--local buttons = require 'buttonManager.buttons'

local manager = {}
local buttons = {}

local function withinBounds(x, y, bounds)
    if bounds.type == "rectangle" then
        if x >= bounds.x and x <= bounds.x + bounds.width and y >= bounds.y and y <= bounds.y + bounds.height then
            return true
        else
            return false
        end
    elseif bounds.type == "circle" then
        local dx = x - bounds.x
        local dy = y - bounds.y
        if (dx * dx + dy * dy) <= (bounds.radius * bounds.radius) then
            return true
        else
            return false
        end
    end
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
        if button.type == "rectangle" then
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
        elseif button.type == "circle" then
            love.graphics.setColor(button.color[1], button.color[2], button.color[3], button.color[4])
            love.graphics.circle("fill", button.x, button.y, button.radius, button.detail)
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

function manager.create(id, type, data, click)
    local errors, warnings = {}, {}

    ---- Validate parameters
    -- Check if an id is assigned
    if not id then
        print("[ButtonManager] ERROR: Button ID can not be nil")
        return
    end

    -- Check if id is not duplicate
    for _, button in pairs(buttons) do
        if button.id == id then
            print("[ButtonManager] ERROR: Button ID already exists: " .. tostring(id))
            return
        end
    end

    -- Check typing
    if not type then
        table.insert(errors, "Button type cannot be nil")
    elseif type ~= "rectangle" and type ~= "circle" then
        table.insert(errors, "Button type not recognized: '" .. tostring(type) .. "'")
    end

    -- Check data
    if not data then
        table.insert(errors, "Button data cannot be nil")
    else
        if not data.x or not data.y then
            table.insert(errors, "Button x and y coordinates cannot be nil")
        end
        if not data.color then
            table.insert(warnings, "Button color not assigned, defaulting to white")
            data.color = {1, 1, 1, 1}
        end
        if type == "rectangle" then
            if not data.width or not data.height then
                table.insert(errors, "Button width and height cannot be nil for rectangle type")
            end
        elseif type == "circle" then
            if not data.radius then
                table.insert(errors, "Button radius and detail cannot be nil for circle type")
            end
            if not data.detail then
                table.insert(warnings, "Button detail not assigned, defaulting to 7")
                data.detail = 7
            end
        end
        if data.text then
            if not data.text.font then
                table.insert(warnings, "Button text font not assigned")
            end
            if not data.text.text then
                table.insert(errors, "Button text cannot be nil")
            end
            if not data.text.color then
                table.insert(warnings, "Button text color not assigned, defaulting to white")
                data.color = {1, 1, 1, 1}
            end
            if not data.text.padX or not data.text.padY then
                table.insert(warnings, "Button text padding not assigned, defaulting to 0")
                data.text.padX, data.text.y = 0,0
            end
        end
        if data.image then
            table.insert(warnings, "This feature is not implemented yet, please use text instead")
        end
    end

    -- Check function
    if not click then
        table.insert(warnings, "Button click function is nil, button will do nothing when clicked.")
    end

    -- Display warnings
    if #warnings > 0 then
        print("[ButtonManager] WARNING in button: '" .. tostring(id) .. "':")
        for _, warn in ipairs(warnings) do
            print("  - " .. warn)
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
    if type == "rectangle" then
        buttons[id] = {
            type = type,
            x = data.x,
            y = data.y,
            width = data.width,
            height = data.height,
            color = data.color,
            text = data.text,
            click = click
        }
    elseif type == "circle" then
        buttons[id] = {
            type = type,
            x = data.x,
            y = data.y,
            radius = data.radius,
            detail = data.detail,
            color = data.color,
            click = click
        }
    end
    if data.image then
        buttons[id].img = {}
        buttons[id].img.image = love.graphics.newImage(data.image.path)
    end
end

function manager.delete(id)
    if buttons[id] then
        buttons[id] = nil
    else
        print("[ButtonManager] WARNING: Tried deleting button with id: " .. tostring(id) .. ", but it does not exist.")
    end
end

return manager