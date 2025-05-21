function love.load()
    button = require 'manager'

    button.create("quit", {x = 350, y = 250, width = 100, height = 100, color = {1,0.2,0.2,1}, text = {text = "EXIT", font = font, padX = 35, padY = 35, color = {0.8,0,0,1}}}, function() love.event.quit() end)
    button.create(1, {x = 200, y = 200, width = 50, height = 50}, function() button.delete(1) end)
end

function love.draw()
    button.draw()
end

function love.mousepressed(x, y, click)
    button.mousepressed(nil, x, y, click)
end