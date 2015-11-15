require("bert")
pad = {}
botData = {}
botData[1] = {}
botData[2] = {}

function setButton(playerSlot,button,state)
	pad[string.format("P%i %s",playerSlot,button)] = state
end

function isFacingRight (playerSlot)
	if playerSlot % 2 == 1 then	--playerSlot is odd (1)
		return memory.read_u8(0x5F3) == 0x40
	else	--playerSlot is even (2)
		return memory.read_u8(0x833) == 0x40
	end
end

-- I don't remember how this function works,
--	but give it will return "Right" or "Left"
--	where 'forward' is a boolean of whether you want
--	what is forward (true) or backward (false)
function getDirectionButton (playerSlot, forward)
	intendedRight = forward
	if not isFacingRight(playerSlot) then
		intendedRight = not intendedRight
	end
	
	if intendedRight then
		return "Right"
	else
		return "Left"
	end	
end

function isCrouching (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x544) == 0x1
	else
		return memory.read_u8(0x784) == 0x1
	end
end

function isAir (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x548) == 0x1
	else
		return memory.read_u8(0x788) == 0x1
	end
end

function getDistance (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x5EB)
	else
		return memory.read_u8(0x82B)
	end
end

function isAttacking (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x5E9) == 0x1
	else
		return memory.read_u8(0x829) == 0x1
	end
end

function hasFireball (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x5F8) == 0x1
	else
		return memory.read_u8(0x838) == 0x1
	end
end

bertInit(1)
bertInit(2)

while true do
	pad = {}

	bertAdvance(1)
	bertAdvance(2)
	
	joypad.set(pad)
	
	emu.frameadvance()
	
	
	

end