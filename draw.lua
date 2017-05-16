draw = {}

draw.white = 0xffe6e6e6
draw.black = 0xff193a7b
draw.blue = 0xff319cb5
draw.yellow = 0xfff7b552
draw.red = 0xffd62100
draw.orange = 0xfff75a3a
draw.text = 0xfff78746

function draw.drawPad(playerSlot)	
	for playerSlot = 1, 2, 1 do
		local bX = ((playerSlot==1) and 79 or 151)
		local bY = 47
		gui.drawEllipse(bX,bY,8,8, draw.black)
		local pY = 0
		if (joypad.get(playerSlot)["Up"]) then
			pY = -1
		elseif (joypad.get(playerSlot )["Down"]) then
			pY = 1
		end
		local pX = 0
		if (joypad.get(playerSlot )["Left"]) then
			pX = -1
		elseif (joypad.get(playerSlot )["Right"]) then
			pX = 1
		end
		gui.drawEllipse(bX+3,bY + 3, 2, 2, draw.black, draw.black)
		gui.drawPixel(bX+4 + pX,bY + 4 + pY, draw.black)
		gui.drawEllipse(bX+2+(pX*3),bY + 2 + (pY*3), 4, 4, draw.orange, draw.orange)
		gui.drawPixel(bX+5+(pX*3),bY + 3 + (pY*3), draw.white)
		gui.drawPixel(bX+4+(pX*3),bY + 2 + (pY*3), draw.yellow)
		
		bX = bX + 12
		if (joypad.get(playerSlot )["Y"]) then
			gui.drawEllipse(bX, bY, 3, 3, draw.blue, draw.blue)
		else
			gui.drawEllipse(bX, bY, 3, 3, draw.black, draw.black)
		end
		if (joypad.get(playerSlot )["B"]) then
			gui.drawEllipse(bX, bY+5, 3, 3, draw.blue, draw.blue)
		else
			gui.drawEllipse(bX, bY+5, 3, 3, draw.black, draw.black)
		end
		
		bY = bY - 1
		bX = bX + 5
		if (joypad.get(playerSlot )["X"]) then
			gui.drawEllipse(bX, bY, 3, 3, draw.yellow, draw.yellow)
		else
			gui.drawEllipse(bX, bY, 3, 3, draw.black, draw.black)
		end
		if (joypad.get(playerSlot )["A"]) then
			gui.drawEllipse(bX, bY+5, 3, 3, draw.yellow, draw.yellow)
		else
			gui.drawEllipse(bX, bY+5, 3, 3, draw.black, draw.black)
		end
		
		bX = bX + 5
		if (joypad.get(playerSlot )["L"]) then
			gui.drawEllipse(bX, bY, 3, 3, draw.red, draw.red)
		else
			gui.drawEllipse(bX, bY, 3, 3, draw.black, draw.black)
		end
		if (joypad.get(playerSlot )["R"]) then
			gui.drawEllipse(bX, bY+5, 3, 3, draw.red, draw.red)
		else
			gui.drawEllipse(bX, bY+5, 3, 3, draw.black, draw.black)
		end

	end
end

function draw.drawName(playerSlot, name)
	local nameX = ((playerSlot==1) and 30 or 227)
	local textAlign = ((playerSlot==1) and "left" or "right")
	gui.drawText(nameX+1,57, name, draw.black, 0x00000000, 14, null, "bold", textAlign, "bottom")
	gui.drawText(nameX,56, name, draw.yellow, 0x00000000, 14, null, "bold", textAlign, "bottom")
end