--[[
    cookie clicker
    author: abhinav
    akshu3398@gmail.com
]]

local cookieTexture = love.graphics.newImage('graphics/cookie.png')
local cursorTexture = love.graphics.newImage('graphics/cursor.png')
local grandmaTexture = love.graphics.newImage('graphics/grandma.png')

local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

local cookies = 0
local cps = 0

local cookiesLastSecond = 0
local cookiesThisSecond = 0
local passiveCookies = 0

local secondTimer = 0

local largefonts = love.graphics.newFont(32)
local smallfonts = love.graphics.newFont(16)

local left = WINDOW_WIDTH / 2 - cookieTexture:getWidth() / 2
local right = left + cookieTexture:getWidth()
local top = WINDOW_HEIGHT / 2 - cookieTexture:getHeight() / 2 - 64
local bottom = top + cookieTexture:getHeight()

local makeCookieBigger = false

-- cursors generate 1 cookie every 10 seconds
local cursors = 0

-- grandmas generate 1 cookie every 1 seconds
local grandmas = 0

function love.load()
    love.window.setTitle('cookie clicker')

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    love.graphics.setFont(largefonts)
end

function love.update(dt)
    local x, y = love.mouse.getPosition()

    makeCookieBigger = x >= left and x <= right and y >= top and y <= bottom        

    updatePassiveCookies(dt)

    secondTimer = secondTimer + dt
    if secondTimer >= 1 then
        secondTimer = secondTimer - 1

        cps = (cookiesLastSecond + cookiesThisSecond) / 2
        cookiesLastSecond = cookiesThisSecond
        cookiesThisSecond = 0
    end
end

function love.keypressed(key)
    if key == 'escape'then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and makeCookieBigger then
        cookies = cookies + 1
        cookiesThisSecond = cookiesThisSecond + 1
    end

    if button == 1 and hoveringOverCursor() then
        if cookies >= 10 then
            passiveCookies = passiveCookies + 0.1
            cookies = cookies - 10
            cursors = cursors + 1            
        end
    end

    if button == 1 and hoveringOverGrandma() then
        if cookies >= 100 then
        passiveCookies = passiveCookies + 1
            cookies = cookies - 100
            grandmas = grandmas + 1            
        end
    end
end

function love.draw()
    love.graphics.printf('Cookies: ' .. tostring(math.floor(cookies)), 
        0, 16, WINDOW_WIDTH, 'center')

    love.graphics.printf('CPS: ' .. tostring(cps), 
        0, 48, WINDOW_WIDTH, 'center')

    love.graphics.draw(cookieTexture, 
        left + (makeCookieBigger and cookieTexture:getWidth() / 2 or 0), 
        top + (makeCookieBigger and cookieTexture:getHeight() / 2 or 0), 
        0, 
        makeCookieBigger and 1.2 or 1, makeCookieBigger and 1.2 or 1,
        makeCookieBigger and cookieTexture:getWidth() / 2 or 0, 
        makeCookieBigger and cookieTexture:getHeight() / 2 or 0)

    love.graphics.draw(cursorTexture, 64, WINDOW_HEIGHT - 120)

    love.graphics.setFont(smallfonts)
    love.graphics.print('Cursor', 50, WINDOW_HEIGHT - 90)
    love.graphics.print('Cost: 10', 44, WINDOW_HEIGHT - 75)
    love.graphics.setFont(largefonts)

    love.graphics.print('Cursors: ' .. tostring(cursors))

    love.graphics.draw(grandmaTexture, 148, WINDOW_HEIGHT - 132)

    love.graphics.setFont(smallfonts)
    love.graphics.print('Grandma', 132, WINDOW_HEIGHT - 90)
    love.graphics.print('Cost: 100', 132, WINDOW_HEIGHT - 75)
    love.graphics.setFont(largefonts)

    love.graphics.print('Grandmas: ' .. tostring(grandmas), 0, 33)
end

function hoveringOverCursor()
    local x, y = love.mouse.getPosition()

    return x <= 64 + cursorTexture:getWidth() and x >= 64 and
            y <= WINDOW_HEIGHT - 120 + cursorTexture:getHeight() and 
            y >= WINDOW_HEIGHT - 120
end

function hoveringOverGrandma()
    local x, y = love.mouse.getPosition()

    return x <= 148 + grandmaTexture:getWidth() and x >= 148 and
            y <= WINDOW_HEIGHT - 132 + grandmaTexture:getHeight() and 
            y >= WINDOW_HEIGHT - 132
end

function updatePassiveCookies(dt)
    local cookiesLastFrame = cookies    
    cookies = cookies + passiveCookies * dt
    local cookiesAfterFrame = cookies

    local newCookies = math.floor(cookiesAfterFrame) - 
            math.floor(cookiesLastFrame)

    cookiesThisSecond = cookiesThisSecond + newCookies
end