require("Bert")
-- add 'require' bits here

<<<<<<< HEAD
function setButton(playerSlot,button,state)
	pad[string.format("P%i %s",playerSlot,button)] = state
end

-- returns true if player #(playerSlot) is facing right
--	use 'getDirectionButton (playerSlot) for inputs,
--	this function is not often relevant
function isFacingRight (playerSlot)
	if playerSlot % 2 == 1 then	--playerSlot is odd (1)
		return memory.read_u8(0x5F3) == 0x40
	else	--playerSlot is even (2)
		return memory.read_u8(0x833) == 0x40
	end
end
=======
bertOne = Bert:create(1)
bertTwo = Bert:create(2)
>>>>>>> readme

bertTwo.playerSlot = 2 -- playerSlot not initialising properly in constructor.

while true do

	bertOne:resetPad()
	bertTwo:resetPad()
	
	bertOne:advance()
	bertTwo:advance()

	pads = bertOne:getPad()
	bertTwoPad = bertTwo:getPad()
	for k,v in pairs(bertTwoPad) do
		pads[k] = v
	end
	joypad.set(pads)

<<<<<<< HEAD
-- script begins here

bertInit(1)
bertInit(2)

-- main loop

while true do

	pad = {}	-- input is set to nil every loop

	bertAdvance(1)
	bertAdvance(2)
	
	joypad.set(pad)
=======
>>>>>>> readme
	emu.frameadvance()
	
end

-- DO NOT REACH HERE
