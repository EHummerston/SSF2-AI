-----------------------------------------------------------------------------
-- An abstract class for Computer-Player algorithms to inherit from.
-- Implements functions to be used by the main program and also within
-- child classes.
-- 
-- 2017 Edward Hummerston, Michael Siers
-----------------------------------------------------------------------------

require("SSF2-AI.PadQueue")

Bot = {}
local Bot_mt = {__index = Bot}

-----------------------------------------------------------------------------
-- Constructor, initialises class variables.
--
-- @param playerSlot     The controller port to represent that the algorithm
--                       will occupy.
-- @param inputDelay     The intended length of the controller list - the
--                       number of frames between an input being commited by
--                       an algorithm and that input occurring in-game.
-- @return               An instance of the created object.
-----------------------------------------------------------------------------
function Bot.new(playerSlot, inputDelay)
   local self = {}
   setmetatable(self, Bot_mt)
   
   assert(playerSlot==1 or playerSlot==2,
      "Player slot " .. playerSlot .. " is not valid.")
   
   self.playerSlot = playerSlot
   self.pad = {}
   self.name = ""
   self.action = ""
   
   self.padq = PadQueue.new()
   for i=1,inputDelay do
      self.padq:enqueue({})
   end
   
   return self
end

-----------------------------------------------------------------------------
-- Returns the player slot given at initialisation.
--
-- @return               The player slot integer (1 or 2)
-----------------------------------------------------------------------------
function Bot:getPlayerSlot()
   return self.playerSlot
end

-----------------------------------------------------------------------------
-- Resets the controller state, called at the start of each frame.
-----------------------------------------------------------------------------
function Bot:resetPad()
   self.pad = {}
end

-----------------------------------------------------------------------------
-- Returns the first controller state in the input delay queue.
--
-- @return               The controller table, formatted to be input to the
--                       Bizhawk emulator.
-----------------------------------------------------------------------------
function Bot:getPad()
   self.padq:enqueue(self.pad)
   return self.padq:dequeue()
end

-----------------------------------------------------------------------------
-- Returns the bot name.
--
-- @return               The code-given name of this player.
-----------------------------------------------------------------------------
function Bot:getName()
   return self.name
end

-----------------------------------------------------------------------------
-- Returns the bot action. This is a string used for indicating what action
-- the algorithm is currently attempting. Useful for debugging.
--
-- @return               A string indicating what action the algorithm is
--                       attempting.
-----------------------------------------------------------------------------
function Bot:getAction()
   return self.action
end

-----------------------------------------------------------------------------
-- Abstract function to be overridden by a child class.
-----------------------------------------------------------------------------
function Bot:advance()
   return
end

-----------------------------------------------------------------------------
-- Sets a given button on the class' controller to a given state. Accepts
-- SNES button names (Y, X, L, B, A, L) or Street Fighter button names (LP,
-- MP, HP, LK, MK, HK). Also accepts "BACK", "BACKWARD" and "TOWARD".
--
-- @param button         The joypad button to be manipulated.
-- @param state          Boolean state for the button to be set to.
-----------------------------------------------------------------------------
function Bot:setButton(button,state)
   
   if button == "Back" or button == "Backward" then
      button = self:getDirectionButton(false)
   elseif button == "Toward" then
      button = self:getDirectionButton(true)
      
   elseif button == "LP" then
      button = "Y"
   elseif button == "MP" then
      button = "X"
   elseif button == "HP" then
      button = "L"
      
   elseif button == "LK" then
      button = "B"
   elseif button == "MK" then
      button = "A"
   elseif button == "HK" then
      button = "L"
   end
   self.pad[string.format("P%i %s", self.playerSlot, button)] = state
end

-----------------------------------------------------------------------------
-- Returns true if the player's facing direction is to the right. Used by
-- Bot:getDirectionButton().
--
-- @param button         The joypad button to be manipulated.
-- @param state          Boolean state for the button to be set to.
-----------------------------------------------------------------------------
function Bot:isFacingRight()
   if self.playerSlot % 2 == 1 then   --playerSlot is odd (1)
      return memory.read_u8(0x5F3) == 0x40
   else   --playerSlot is even (2)
      return memory.read_u8(0x833) == 0x40
   end
end

-----------------------------------------------------------------------------
-- Returns a string of "Right" or "Left" based on the boolean that it is 
-- passed.
--
-- @param forward        A boolean indicating whether the requested
--                       left/right direction is in front of the character.
-----------------------------------------------------------------------------
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

-----------------------------------------------------------------------------
-- Returns true if the player is crouching. Includes crouching attacks and
-- special moves (e.g. low tiger shot).
--
-- @return               A boolean of whether the player is crouching.
-----------------------------------------------------------------------------
function Bot:isCrouching()
   if self.playerSlot % 2 == 1 then
      return memory.read_u8(0x544) == 0x1
   else
      return memory.read_u8(0x784) == 0x1
   end
end

-----------------------------------------------------------------------------
-- Returns true if the opponent is crouching. Includes crouching attacks and
-- special moves (e.g. low tiger shot).
--
-- @return               A boolean of whether the opponent is crouching.
-----------------------------------------------------------------------------
function Bot:isOpponentCrouching()
   enemyPlayerSlot = self.playerSlot + 1
   if enemyPlayerSlot % 2 == 1 then
      return memory.read_u8(0x544) == 0x1
   else
      return memory.read_u8(0x784) == 0x1
   end
end

-----------------------------------------------------------------------------
-- Returns true if the player is in the air. Includes not only jumps, but
-- special moves that make a character airborne
--
-- @return               A boolean of whether the player is airborne.
-----------------------------------------------------------------------------
function Bot:isAir()
   if self.playerSlot % 2 == 1 then
      return memory.read_u8(0x548) == 0x1
   else
      return memory.read_u8(0x788) == 0x1
   end
end

-----------------------------------------------------------------------------
-- Returns true if the opponent is in the air. Includes not only jumps, but
-- special moves that make a character airborne
--
-- @return               A boolean of whether the opponent is airborne.
-----------------------------------------------------------------------------
function Bot:isOpponentAir()
  enemyPlayerSlot = self.playerSlot + 1
   if enemyPlayerSlot % 2 == 1 then
      return memory.read_u8(0x548) == 0x1
   else
      return memory.read_u8(0x788) == 0x1
   end
end

-----------------------------------------------------------------------------
-- Returns the distance from opponent stored for this player. Testing
-- indicates that this is the same value for both players, but is not
-- definitive.
--
-- @return               An integer of distance between the players.
-----------------------------------------------------------------------------
function Bot:getDistance()
   if self.playerSlot % 2 == 1 then
      return memory.read_u8(0x5EB)
   else
      return memory.read_u8(0x82B)
   end
end

-----------------------------------------------------------------------------
-- Returns true if this player is performing an attack. Includes the startup,
-- active and recovery frames of attacks. Does not include whether or not a
-- fireball is active, only whether they are in a fireball animation.
--
-- @return               A boolean indicating whether this player is
--                       attacking.
-----------------------------------------------------------------------------
function Bot:isAttacking ()
   if self.playerSlot % 2 == 1 then
      return memory.read_u8(0x5E9) == 0x1
   else
      return memory.read_u8(0x829) == 0x1
   end
end

-----------------------------------------------------------------------------
-- Returns true if the opponent is performing an attack. Includes the
-- startup, active and recovery frames of attacks. Does not include whether
-- or not a fireball is active, only whether they are in a fireball
-- animation.
--
-- @return               A boolean indicating whether the opponent is
--                       attacking.
-----------------------------------------------------------------------------
function Bot:isOpponentAttacking()
   enemyPlayerSlot = self.playerSlot + 1
   if enemyPlayerSlot % 2 == 1 then
      return memory.read_u8(0x5E9) == 0x1
   else
      return memory.read_u8(0x829) == 0x1
     end
end

-----------------------------------------------------------------------------
-- Returns true if this player has a projectile active, meaning they cannot
-- make another.
--
-- @return               A boolean indicating whether this player has a
--                       fireball active.
-----------------------------------------------------------------------------
function Bot:hasFireball()
   if self.playerSlot % 2 == 1 then
      return memory.read_u8(0x5F7) ~= 0
   else
      return memory.read_u8(0x837) ~= 0
   end
end

-----------------------------------------------------------------------------
-- Returns true if the opponent has a projectile active, meaning they cannot
-- make another.
--
-- @return               A boolean indicating whether the opponent has a
--                       fireball active.
-----------------------------------------------------------------------------
function Bot:hasOpponentFireball()
   enemyPlayerSlot = self.playerSlot + 1
   if enemyPlayerSlot % 2 == 1 then
      return memory.read_u8(0x5F7) ~= 0
   else
      return memory.read_u8(0x837) ~= 0
   end
end