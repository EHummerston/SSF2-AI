local white = 0xffe6e6e6
local black = 0xff193a7b
local blue = 0xff319cb5
local yellow = 0xfff7b552
local red = 0xffd62100
local orange = 0xfff75a3a
local text = 0xfff78746

function drawPads()	
	for i = 1, 2, 1 do
		local bX = ((i==1) and 79 or 151)
		local bY = 47
		gui.drawEllipse(bX,bY,8,8, black)
		local pY = 0
		if (joypad.get(i)["Up"]) then
			pY = -1
		elseif (joypad.get(i)["Down"]) then
			pY = 1
		end
		local pX = 0
		if (joypad.get(i)["Left"]) then
			pX = -1
		elseif (joypad.get(i)["Right"]) then
			pX = 1
		end
		gui.drawEllipse(bX+3,bY + 3, 2, 2, black, black)
		gui.drawPixel(bX+4 + pX,bY + 4 + pY, black)
		gui.drawEllipse(bX+2+(pX*3),bY + 2 + (pY*3), 4, 4, orange, orange)
		gui.drawPixel(bX+5+(pX*3),bY + 3 + (pY*3), white)
		gui.drawPixel(bX+4+(pX*3),bY + 2 + (pY*3), yellow)
		
		bX = bX + 12
		if (joypad.get(i)["Y"]) then
			gui.drawEllipse(bX, bY, 3, 3, blue, blue)
		else
			gui.drawEllipse(bX, bY, 3, 3, black, black)
		end
		if (joypad.get(i)["B"]) then
			gui.drawEllipse(bX, bY+5, 3, 3, blue, blue)
		else
			gui.drawEllipse(bX, bY+5, 3, 3, black, black)
		end
		
		bY = bY - 1
		bX = bX + 5
		if (joypad.get(i)["X"]) then
			gui.drawEllipse(bX, bY, 3, 3, yellow, yellow)
		else
			gui.drawEllipse(bX, bY, 3, 3, black, black)
		end
		if (joypad.get(i)["A"]) then
			gui.drawEllipse(bX, bY+5, 3, 3, yellow, yellow)
		else
			gui.drawEllipse(bX, bY+5, 3, 3, black, black)
		end
		
		bX = bX + 5
		if (joypad.get(i)["L"]) then
			gui.drawEllipse(bX, bY, 3, 3, red, red)
		else
			gui.drawEllipse(bX, bY, 3, 3, black, black)
		end
		if (joypad.get(i)["R"]) then
			gui.drawEllipse(bX, bY+5, 3, 3, red, red)
		else
			gui.drawEllipse(bX, bY+5, 3, 3, black, black)
		end

	end
end

function drawName(playerSlot, name)
	local nameX = ((playerSlot==1) and 30 or 227)
	local textAlign = ((playerSlot==1) and "left" or "right")
	gui.drawText(nameX+1,57, name, black, 0x00000000, 14, null, "bold", textAlign, "bottom")
	gui.drawText(nameX,56, name, yellow, 0x00000000, 14, null, "bold", textAlign, "bottom")
end