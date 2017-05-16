-- Meta class
Bot = {i = 0, newAttack = true, walkTimer = 0, playerSlot = 1, pad = {}}
Bot_mt = {__index = Bot}

-- Base class method new
function Bot:create(playerSlot)
	local newInst = {}
	newInst.playerSlot = playerSlot
	newInst.i = 0
	newInst.newAttack = true
	newInst.walkTimer = 0
	newInst.pad = {}
	setmetatable(newInst, Bot_mt)
	return newInst
end

-- Derived class methods

function Bot:getPlayerSlot()
	return self.playerSlot
end

-- This function will get overwritten by a subclass.
function Bot:advance()
	return
end


function Bot:setButton(button,state)
	self.pad[string.format("P%i %s", self.playerSlot, button)] = state
end

-- returns true if player #(playerSlot) is facing right use
-- getDirectionButton() for inputs, this function is not often relevant
function Bot:isFacingRight()
	if self.playerSlot % 2 == 1 then	--playerSlot is odd (1)
		return memory.read_u8(0x5F3) == 0x40
	else	--playerSlot is even (2)
		return memory.read_u8(0x833) == 0x40
	end
end

-- I don't remember how this function works, but it will return "Right" or
--	"Left" where 'forward' is a boolean of whether you want what is forward
--	(true) or backward (false)
function Bot:getDirectionButton(forward)
	intendedRight = forward
	if not self:isFacingRight() then
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
function Bot:isCrouching()
	if self.playerSlot % 2 == 1 then
		return memory.read_u8(0x544) == 0x1
	else
		return memory.read_u8(0x784) == 0x1
	end
end

-- Returns true if the opponent is crouching.
function Bot:isOpponentCrouching()
	enemyPlayerSlot = self.playerSlot + 1
	if enemyPlayerSlot % 2 == 1 then
		return memory.read_u8(0x544) == 0x1
	else
		return memory.read_u8(0x784) == 0x1
	end
end

-- returns true if given player is in the air
--	includes not only jumps, but special moves that make a character airborne
function Bot:isAir()
	if self.playerSlot % 2 == 1 then
		return memory.read_u8(0x548) == 0x1
	else
		return memory.read_u8(0x788) == 0x1
	end
end

-- Returns true if the opponent is in the air.
function Bot:isOpponentAir()
  enemyPlayerSlot = self.playerSlot + 1
	if enemyPlayerSlot % 2 == 1 then
		return memory.read_u8(0x548) == 0x1
	else
		return memory.read_u8(0x788) == 0x1
	end
end

-- returns the distance from opponent stored for given player
--	is this the same value for both players?? probably
function Bot:getDistance()
	if self.playerSlot % 2 == 1 then
		return memory.read_u8(0x5EB)
	else
		return memory.read_u8(0x82B)
	end
end

-- returns true if this bot is performing an attack
--	includes the startup, active and recovery frames of all (afaik) attacks
--	does not include whether or not a fireball is active, only whether they are
--	in a fireball animation
-- this value actually represents Proximity Blocking:
--	if the enemy presses backward, they will block instead of walking backward
function Bot:isAttacking ()
	if self.playerSlot % 2 == 1 then
		return memory.read_u8(0x5E9) == 0x1
	else
		return memory.read_u8(0x829) == 0x1
	end
end

-- Returns true if the bot's opponent is performing an attack.
function Bot:isOpponentAttacking()
	enemyPlayerSlot = self.playerSlot + 1
	if enemyPlayerSlot % 2 == 1 then
		return memory.read_u8(0x5E9) == 0x1
	else
		return memory.read_u8(0x829) == 0x1
  	end
end

-- returns true if given player has a projectile active
--	(they can't make another)
function Bot:hasFireball()
	if self.playerSlot % 2 == 1 then
		return memory.read_u8(0x5F8) == 0x1
	else
		return memory.read_u8(0x838) == 0x1
	end
end

function Bot:resetPad()
	self.pad = {}
end

function Bot:getPad()
	return self.pad
end
