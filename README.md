# Love2d-Button-Manager
A library I built to create and manage buttons really easily. Allows for creation and management of buttons with custom sizes, colors, text and even images with just a few lines of code.

## Usage

Require the module in your main file:

```local button = require("manager")```

Creating a Button:

```button.create(id, type, data, callback)```

Drawing buttons:

```button.draw(id)```
* id (optional): Draw a specific button (string|int), multiple (table), or all (nil).

Activating buttons:

```
    function love.mouseclick(x, y, click)
        button.mouseclick(id, x, y, click)
    end
```
* id (optional): Draw a specific button (string|int), multiple (table), or all (nil).


# Parameters:

* id (string|integer): Unique identifier for the button.
* type (string): Button shape. Must be one of:
    * "rectangle"
    * "circle"
* data (table): Table of visual and positional parameters. Varies based on type.
* callback (function): Function called when the button is clicked.

# Data Parameter

The data table defines the properties of a button.

```
{
  x = <number>,           -- Required
  y = <number>,           -- Required
  width = <number>,       -- Required
  height = <number>,      -- Required
  color = {r, g, b, a},   -- Optional (default: white)
  text = {
    text = <string>,      -- Required
    font = <Font>,        -- Optional (Love2D font object)
    color = {r, g, b, a}, -- Optional (default: black)
    padX = <number>,      -- Optional (padding)
    padY = <number>       -- Optional (padding)
  },
  image = {
    img = <Image>         -- Love2D image object
  }
}

```

# example buttons:

```button.create()```
[image]
```button.create()```
[image]

## Integration with Love2D

Make sure to call the following functions inside your Love2D callbacks:

```
function love.load()
    button = require 'manager'  -- Load the manager into button variable
end

function love.draw()
    button.draw()               -- Draw buttons onto the screen
end

function love.mousepressed(x, y, buttonNum)
    button.mousepressed(x, y, buttonNum)
end
```
Example:

```
function love.load()
    local button = require("manager")
end

button.create("hello", "rectangle", {
    x = 50, y = 50,
    width = 150, height = 40,
    color = {0.1, 0.5, 0.1, 1},
    text = "Click Me",
    textColor = {1, 1, 1, 1}
}, function()
    print("Hello button clicked!")
end)

function love.draw()
    button.draw("hello")
end

function love.mousepressed(x, y, click)
    button.mousepressed("hello", x, y, click)
end
```