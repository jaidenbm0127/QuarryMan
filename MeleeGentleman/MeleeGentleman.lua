local checkInventory = 0

while true do

    turtle.attack()
    checkInventory = checkInventory + 1
    local fullCounter = 0
    if checkInventory > 10 then
        for i = 1, 16 do
            turtle.select(i)
            if turtle.getItemCount() > 0 then
                fullCounter = fullCounter + 1
            end
        end
        if fullCounter == 16 then
            turtle.turnLeft()
            turtle.turnLeft()
            for i = 1, 16 do
                turtle.select(i)
                turtle.drop()
            end
            turtle.turnLeft()
            turtle.turnLeft()
        end

        checkInventory = 0
    end
end