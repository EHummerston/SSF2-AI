
require("Bert")
require("draw")
-- add 'require' bits here

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

	draw.drawPads()
	draw.drawName(1, "Bert")
	draw.drawName(2, "Bert")
	
	emu.frameadvance()
	
end

-- DO NOT REACH HERE