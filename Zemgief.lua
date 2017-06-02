-----------------------------------------------------------------------------
-- An implementation of the SSF2 AI which uses Zangief with extremely basic
-- logic.
-- 
-- 2017 Edward Hummerston, Danny
-----------------------------------------------------------------------------

require("Bot")

Zemgief = {}
setmetatable(Zemgief, {__index = Bot})
local Zemgief_mt = {__index = Zemgief}

-----------------------------------------------------------------------------
-- Override inherited constructor.
--
-- @param  playerSlot    The controller port to represent that the algorithm
--                       will occupy
-- @return self          An instance of the created object
-----------------------------------------------------------------------------
function Zemgief.new(playerSlot)
   local self = Bot.new(playerSlot, 0)
   setmetatable(self, Zemgief_mt)
   
   self.name = "ZEMgief"
   
   self.frame = 0
   self.state = 0
   
   return self
end

-----------------------------------------------------------------------------
-- Sets the controller state in order to repeatedly complete a Spinning Pile
-- Driver command.
-----------------------------------------------------------------------------
function Zemgief:spd()
   self.action = "SPD"
   if self.frame == 1 then -- forward
      self:setButton(self:getDirectionButton(true),true)
      
   elseif self.frame == 2 then   -- down
      self:setButton("Down",true)
      
   elseif self.frame == 3 then   --back
      self:setButton(self:getDirectionButton(false),true)
      
   elseif self.frame <= 10 then  -- up + LP
      self:setButton("Up",true)
      self:setButton("Y",true)      
         
   elseif self.frame > 35 then
      self.frame = 0
      self.state = 0
      
   end
end

-----------------------------------------------------------------------------
-- Sets the controller state in order to complete a Jumping Headbutt command.
-----------------------------------------------------------------------------
function Zemgief:antiAir()
   self.action = "Anti Air"
   if self.frame == 1 then 
      self:setButton("Up",true)
   
   elseif self.frame == 2 then
      self:setButton("Up",true)
      self:setButton("L",true)
   
   else      
      self.frame = 0
      self.state = 0

   end
end

-----------------------------------------------------------------------------
-- Sets the controller stand-block, unless the opponent is crouching, in 
-- case it will crouch-block.
-----------------------------------------------------------------------------
function Zemgief:block()
   self.action = "Block"
   if self:isOpponentAttacking() then
      self:setButton(self:getDirectionButton(false),true)
      if(self:isOpponentCrouching()) then
         self:setButton("Down",true)
      end
   else
      self.frame = 0
      self.state = 0
   end
end

-----------------------------------------------------------------------------
-- Determines what action to take if the characters are close to one another.
-- Blocking if the enemy is attacking, or using a Spinning Pile Driver if
-- else.
-----------------------------------------------------------------------------
function Zemgief:near()
   
   if self:isOpponentAttacking() then
      
      self.frame = 1
      self.state = 2
      
      self:block()
      
      return

   end

   self:spd()
   
end

-----------------------------------------------------------------------------
-- Determines the action to take after an action has been completed.
-----------------------------------------------------------------------------
function Zemgief:idle()

   if self:isOpponentAttacking() then
      
      self.frame = 1
      self.state = 2
      
      self:block()
      
      return

   end

   if self:getDistance() > 50 then 
      self:setButton(self:getDirectionButton(true),true)
      self.action = "Walk Forward"

   else   
      if self:isOpponentAir() then
         self:antiAir()
      else
         self.frame = 0
         self.state = 1
      end
   end
   
end

-----------------------------------------------------------------------------
-- Called by the main loop. Feeds into class logic functions.
-----------------------------------------------------------------------------
function Zemgief:advance()
   self.frame = self.frame + 1
   
   if self.state == 0 then
      self:idle()
   elseif self.state == 1 then
      self:near()
   elseif self.state == 2 then
      self:block()
   end
end