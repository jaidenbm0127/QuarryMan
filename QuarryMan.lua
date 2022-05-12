Miner = {
    -- Which way the turtle is facing.
    North = true,
    South = false,

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

if Miner.North  then
    turtle.turnRight()
elseif Miner.South then
    turtle.turnLeft()
end

for y = Miner.currentY, 1, -1 do
    turtle.forward()
end

turtle.turnRight()

for x = Miner.currentX, 1, -1 do
    turtle.forward()
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

if Miner.North then
    turtle.turnRight()
elseif Miner.South then
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

-- Goes forward [specified width] blocks.
function Miner:forward()
if Miner.North then
    while Miner.currentX < Miner.Width do
        if Miner:checkFuel() or Miner:checkInventory() then
            Miner:returnToBase()
            Miner:returnToMining()
            Miner:forward()
        else
            turtle.dig()
            turtle.forward()
            Miner.currentX = Miner.currentX + 1
        end
    end
else
    while Miner.currentX > 0 do
        if Miner:checkFuel() or Miner:checkInventory() then
            Miner:returnToBase()
            Miner:returnToMining()
            Miner:forward()
        else
            turtle.dig()
            turtle.forward()
            Miner.currentX = Miner.currentX - 1
        end
    end
end

end

-- Overly intricate method to turn based on which way the Turtle is facing and which way its mining.
function Miner:turn()
if Miner.North and Miner.MiningDirectionWest then
    if Miner:checkFuel() or Miner:checkInventory() then
        Miner:returnToBase()
        Miner:returnToMining()
        Miner:turn()
    else
        turtle.turnLeft()
        turtle.dig()
        turtle.forward()
        turtle.turnLeft()
        Miner.North = false
        Miner.South = true
        Miner.currentY = Miner.currentY + 1
    end
elseif Miner.North and Miner.MiningDirectionEast then
    if Miner:checkFuel() or Miner:checkInventory() then
        Miner:returnToBase()
        Miner:returnToMining()
        Miner:turn()
    else
        turtle.turnRight()
        turtle.dig()
        turtle.forward()
        turtle.turnRight()
        Miner.North = false
        Miner.South = true
        Miner.currentY = Miner.currentY - 1
    end
elseif Miner.South and Miner.MiningDirectionWest then
    if Miner:checkFuel() or Miner:checkInventory() then
        Miner:returnToBase()
        Miner:returnToMining()
        Miner:turn()
    else
        turtle.turnRight()
        turtle.dig()
        turtle.forward()
        turtle.turnRight()
        Miner.North = true
        Miner.South = false
        Miner.currentY = Miner.currentY + 1
    end
elseif Miner.South and Miner.MiningDirectionEast then
    if Miner:checkFuel() or Miner:checkInventory() then
        Miner:returnToBase()
        Miner:returnToMining()
        Miner:turn()
    else
        turtle.turnLeft()
        turtle.dig()
        turtle.forward()
        turtle.turnLeft()
        Miner.North = true
        Miner.South = false
        Miner.currentY = Miner.currentY - 1
    end
end
end

function Miner:down()
if Miner:checkFuel() or Miner:checkInventory() then
    if Miner:checkFuel() then
        if not Miner:checkInventoryForFuel() then
            Miner:returnToBase()
            print("No more fuel")
            -- Maybe add function to wait for fuel then continue? 
        end
    else
        Miner:returnToBase()
        Miner:putAway()
        Miner:returnToMining()
        Miner:down()
    end
else
    turtle.digDown()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.down()
    if Miner.North then
        Miner.North = false
        Miner.South = true
    else
        Miner.North = true
        Miner.South = false
    end
end
Miner.currentZ = Miner.currentZ - 1
end

-- Checks to see if the miner is under a certain amount of fuel
function Miner:checkFuel()
return turtle.getFuelLevel() < 250
end


-- Put all of the turtles contents into a chest
function Miner:putAway()
for i = 1, 16 do
    turtle.select(i)
    turtle.drop()
end
turtle.select(1)
end

-- Check turtles inventory for fuel
function Miner:checkInventoryForFuel()
for i = 1, 16 do
    turtle.select(i)
    if turtle.getItemCount(i) > 0 then
        local isFuel, reason = turtle.refuel(0)
        if isFuel then
            turtle.refuel()
            turtle.select(1)
            return true
        end
    end
end
turtle.select(1)
return false
end

-- Tells the turtle to keep mining until it hits the depth that is wanted. 
function Miner:doQuarry()
Miner:start()
local rowsDone = 0
while Miner.currentZ >= Miner.Depth do
    Miner:forward()
    rowsDone = rowsDone + 1
    if rowsDone > Miner.Width then
        if Miner.currentZ == Miner.Depth then
            break
        end
        Miner:down()
        rowsDone = 0
        if Miner.MiningDirectionWest then
            Miner.MiningDirectionWest = false
            Miner.MiningDirectionEast = true
        else
            Miner.MiningDirectionWest = true
            Miner.MiningDirectionEast = false
        end
    else
        Miner:turn()
    end
end

Miner:returnToBase()
end

print("What depth do you want (Bottom of the map is -64)? ")
local depth = io.read()
local depthNum = tonumber(depth)
Miner["Depth"] = depthNum * -1

print("What dimensions (square)? ")
local width = io.read()
local widthNum = tonumber(width)
Miner["Width"] = widthNum - 1

Miner:doQuarry()