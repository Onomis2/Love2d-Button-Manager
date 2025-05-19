CreateButton(
    "hello!",
    "rectangle",
    {
        x = 10,
        y = 10,
        width = 100,
        height = 100,
        color = {1,0,0,1},
        text = {size = 20, text = "Hello", color = {0,1,1,1}, padX = 35, padY = 40}
    },
    function() print("Hello!") end
)

CreateButton(
    "quit",
    "circle",
    {
        x = 400,
        y = 100,
        radius = 20,
        detail = 5,
        color = {1,0,1,1}},
    function() love.event.quit() end
)