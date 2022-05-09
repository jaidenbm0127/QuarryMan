Miner ={
        -- Which way the turtle is facing.
        North = true,
        West = false,
        South = false,
        East = false,

        -- Which direction the turtle is mining in.
        MiningDirectionWest = true,
        MiningDirectionEast = false,

        -- Internal coordinate system to help navigate back to chest.
        currentX = 0,
        currentY = 0,
        currentZ = 0
       }

-- Checks to see if the Miner has a full inventory.
function Miner:checkInventory()
    local fullCount = 0
    -- Cycles through each inventory slot and checks if it has an item in it by comparing its value to 0.
    for i = 1, 16 do
        if turtle.getItemCount(i) > 0 then
            fullCount = fullCount + 1
        else
            return false
        end
    end
    if fullCount == 16 then
        print("The turtle is full... returning to base.")
        return true
    end
end

-- Using the point (0, 0, 0) as its starting point, navigates from its current (X, Y, Z) to (0, 0, 0)
function Miner:returnToBase()
    for z = Miner.currentZ, -1 do
        turtle.up()
    end

    if Miner.North == true then
        turtle.turnRight()
    elseif Miner.West == true then
        turtle.turnRight()
        turtle.turnRight()
    elseif Miner.South == true then
        turtle.turnLeft()
    end

    for y = Miner.currentY, 1, -1 do
        turtle.forward()
    end

    turtle.turnRight()

    for x = Miner.currentX, 1, -1 do
        turtle.forward()
        print(turtle.getFuelLevel())
    end
end

-- Quite literally the opposite of returnToBase
function Miner:returnToMining()
    turtle.turnRight()
    turtle.turnRight()
    
    for i = 1, Miner.currentX do
        turtle.forward()
    end

    turtle.turnLeft()

    for i = 1, Miner.currentY do
        turtle.forward()
    end

    if Miner.North == true then
        turtle.turnRight()
    elseif Miner.East == true then
        turtle.turnRight()
        turtle.turnRight()
    elseif Miner.South == true then
        turtle.turnLeft()
    end

    for i = 1, Miner.currentZ, -1 do
        turtle.down()
    end

end

-- Function run once at the start of the quarry
function Miner:start()
    turtle.digDown()
    turtle.down()
    Miner.currentZ = Miner.currentZ - 1
end

-- Goes north (on internal coordinate system) [specified width] blocks.
function Miner:north()
    while Miner.currentX < Miner.Width do
        if Miner:checkFuel() then
            turtle.refuel()
        end
        turtle.dig()
        turtle.forward()
        Miner.currentX = Miner.currentX + 1
    end
end

-- Goes south (on internal coordinate system) [specified width] blocks.
function Miner:south()
end

-- Checks to see if the miner is under a certain amount of fuel
function Miner:checkFuel()
    return turtle.getFuelLevel() < 250
end

-- Tells the turtle to keep mining until it hits the depth that is wanted. 
function Miner:doQuarry()
    Miner:start()
    while Miner.currentZ > Miner.Depth do
        Miner:north()
    end

end

print("What depth do you want (Bottom of the map is -64)? ")
local depth = io.read()
local depthNum = tonumber(depth)
Miner["Depth"] = depthNum * -1

print("What dimensions (square)? ")
local width = io.read()
local widthNum = tonumber(width)
Miner["Width"] = widthNum

Miner:doQuarry()

