function treeCaptate()
	turtle.dig()
	turtle.forward()
	local altura = 0
	while turtle.detectUp() do 
		turtle.digUp()
		turtle.up()
		altura = altura + 1
	end
	for i=1, altura do
		turtle.down()
	end
	turtle.back()
end

while true do
	local hasBlock, block = turtle.inspect()
	if block.name == "minecraft:oak_log" then
		treeCaptate()
		turtle.place()
	end
	sleep(1)
end
