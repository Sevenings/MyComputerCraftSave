print("Refuel me!")

local function wait_for_q()
    print("Aperte Q para sair.")
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
end

local function refuel()
  turtle.select(1)
  print(string.format("Nhame nhame! Combustivel: %d/%d", turtle.getFuelLevel(), turtle.getFuelLimit()))
  while turtle.getFuelLevel() < turtle.getFuelLimit() do
    if turtle.refuel() then
      print(string.format("Nhame nhame! Combustivel: %d/%d", turtle.getFuelLevel(), turtle.getFuelLimit()))
    end
    sleep(0.2)
  end
end

parallel.waitForAny(refuel, wait_for_q)
