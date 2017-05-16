
require("Bert")
require("draw")
-- add 'require' bits here

debugUI = true

bertOne = Bert:create(1)
bertTwo = Bert:create(2)

bertTwo.playerSlot = 2 -- playerSlot not initialising properly in constructor.

while true do

	bertOne:resetPad()
	bertTwo:resetPad()
	
	if memory.read_u8(0x10083) == 0x0 then --if the game is in a fight state
		bertOne:advance()
		bertTwo:advance()
	end
	
	pads = bertOne:getPad()
	bertTwoPad = bertTwo:getPad()
	for k,v in pairs(bertTwoPad) do
		pads[k] = v
	end
	joypad.set(pads)

	draw.drawPad(1)
	draw.drawPad(2)
	draw.drawName(1, "Bert")
	draw.drawName(2, "Bert")
	
	if(debugUI) then
		gui.pixelText(0,0,"atk " .. tostring(memory.read_u8(0x5E9) == 0x1))
		gui.pixelText(132,0,"atk " .. tostring(memory.read_u8(0x829) == 0x1))
		
		gui.pixelText(0,8,"fb  " .. tostring(memory.read_u8(0x5F7) ~= 0))
		gui.pixelText(132,8,"fb  " .. tostring(memory.read_u8(0x837) ~= 0))
	end
	
	emu.frameadvance()
	
end

-- DO NOT REACH HERE