require("bert")
-- add 'require' bits here
pad = {}
botData = {}
botData[1] = {}
botData[2] = {}

function setButton(playerSlot,button,state)
	pad[string.format("P%i %s",playerSlot,button)] = state
end

-- returns true if player #(playerSlot) is facing right use 'getDirectionButton
--	(playerSlot) for inputs, this function is not often relevant
function isFacingRight (playerSlot)
	if playerSlot % 2 == 1 then	--playerSlot is odd (1)
		return memory.read_u8(0x5F3) == 0x40
	else	--playerSlot is even (2)
		return memory.read_u8(0x833) == 0x40
	end
end

-- I don't remember how this function works, but it will return "Right" or
--	"Left" where 'forward' is a boolean of whether you want what is forward
--	(true) or backward (false)
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

-- Returns true if given player is crouching
--	Includes crouching attacks and special moves (e.g. low tiger shot)
function isCrouching (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x544) == 0x1
	else
		return memory.read_u8(0x784) == 0x1
	end
end

-- returns true if given player is in the air
--	includes not only jumps, but special moves that make a character airborne
function isAir (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x548) == 0x1
	else
		return memory.read_u8(0x788) == 0x1
	end
end

-- returns the distance from opponent stored for given player
--	is this the same value for both players?? probably
function getDistance (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x5EB)
	else
		return memory.read_u8(0x82B)
	end
end

-- returns true if given player is performing an attack
--	includes the startup, active and recovery frames of all (afaik) attacks
--	does not include whether or not a fireball is active, only whether they are
--	in a fireball animation
function isAttacking (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x5E9) == 0x1
	else
		return memory.read_u8(0x829) == 0x1
	end
end

-- returns true if given player has a projectile active
--	(they can't make another)
function hasFireball (playerSlot)
	if playerSlot % 2 == 1 then
		return memory.read_u8(0x5F8) == 0x1
	else
		return memory.read_u8(0x838) == 0x1
	end
end

-- BEGIN
--	THE REAL SHIT

bertInit(1)
bertInit(2)

while true do

	pad = {}	-- input is set to nil every loop

	bertAdvance(1)
	bertAdvance(2)
	
	joypad.set(pad)
	emu.frameadvance()
	
end

-- DO NOT REACH HERE