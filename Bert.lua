-----------------------------------------------------------------------------
-- An implementation of the SSF2 AI which aims to be a simple algorithm which
-- mimics a human Ryu player.
-- 
-- 2017 Edward Hummerston
-----------------------------------------------------------------------------

require("Bot")

Bert = {}
setmetatable(Bert, {__index = Bot})
local Bert_mt = {__index = Bert}

-----------------------------------------------------------------------------
-- Override inherited constructor.
--
-- @param playerSlot     The controller port to represent that the algorithm
--                       will occupy.
-- @return               An instance of the created object.
-----------------------------------------------------------------------------
function Bert.new(playerSlot)
   local self = Bot.new(playerSlot, 10)
   setmetatable(self, Bert_mt)
   
   self.name = "Bert"
   self.i = 0
   self.walkTimer = 0
   self.newAttack = true
   return self
end

-----------------------------------------------------------------------------
-- Sets the controller state in order to repeatedly complete a Hadoken
-- command.
-----------------------------------------------------------------------------
function Bert:fireball()
   if self.i < 3 then   -- down
      self:setButton("Down",true)
   elseif self.i < 6 then  -- down forward
      self:setButton("Down",true)
      self:setButton(self:getDirectionButton(true),true)
   elseif self.i < 9 then  -- forward
      self:setButton(self:getDirectionButton(true),true)
   elseif self.i < 12 then -- forward + puinch
      self:setButton(self:getDirectionButton(true),true)
      self:setButton("X",true)      
   -- Long buffer to prevent accidental Shoryuken commands
   elseif self.i > 30 then
      self.i = -1
   end
end

-----------------------------------------------------------------------------
-- Sets the controller state in order to repeatedly complete a Shoryuken
-- command.
-----------------------------------------------------------------------------
function Bert:dragonPunch()
   if self.i < 3 then  -- forward
      self:setButton(self:getDirectionButton(true),true)
   elseif self.i < 6 then -- down
      self:setButton("Down",true)
   elseif self.i < 9 then -- down forward + punch
      self:setButton("Down",true)
      self:setButton(self:getDirectionButton(true),true)
      self:setButton("L",true)
   elseif self.i > 12 then
      self.i = -1
   end
end

-----------------------------------------------------------------------------
-- Interprets the current game state and determines which action is
-- appropriate and thus what inputs the controller should be set to.
-----------------------------------------------------------------------------
function Bert:advance()   
   self.i = self.i + 1
 
   if self:isAttacking() then
      return
   end
   
   if self:isOpponentAttacking() and not self:isOpponentAir() then
   -- if enemy is attacking and on the ground
   
      if self.newAttack and self:getDistance() < 0x24 then
      -- if enemy is close and they weren't attacking last frame
         self:dragonPunch()
         self.action = "ume shoryken"
      elseif self:hasOpponentFireball() then-- counter fireball with the same
         self:fireball()
         self.action = "counter fireball"
      else  -- they are far away or this isn't the first frame of the attack
         self.newAttack = false
         self:setButton(self:getDirectionButton(false),true)
         self.action = "block"
         self.i = -1
         if self:isOpponentCrouching() then  -- if enemy is crouching
            self:setButton("Down",true)
            self.action = "low block"
         end
      end
   else  -- the enemy is in the air or not attacking
      self.newAttack = true
      if self:getDistance() < 0x28 then   -- they are close
         if self:isOpponentAir() then  -- if enemy is in air
            self:dragonPunch()
            self.action = "anti-air"
         else  -- p2 is close on the ground
            self:setButton(self:getDirectionButton(false),true)
            self.action = "walk back"
            self.i = -1
         end
      else  -- they are far away
         if not self:hasFireball() and not self:isOpponentAir() then
         -- there isn't a fireball and p2 is on the ground
            if self.walkTimer <= 0 then   -- we weren't walking too recently
               self:fireball()
               self.action = "fireball"
            else  -- we were pressing forward recently
               self.walkTimer = self.walkTimer - 1
               self.action = "dp timeout"
            end
         else  -- we have a fireball out or the enemy is in the air
            self:setButton(self:getDirectionButton(true),true)
            self.action = "walk forward"
            self.walkTimer = 15
            self.i = -1
         end
      end
   end
end