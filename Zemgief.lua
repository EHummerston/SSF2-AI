require("Bot")

Zemgief = {}
setmetatable(Zemgief, {__index = Bot})
local Zemgief_mt = {__index = Zemgief}

function Zemgief.new(playerSlot)
   local self = Bot.new(playerSlot)
   setmetatable(self, Zemgief_mt)
   
   self.name = "ZEMgief"
   
   self.frame = 0
   self.state = 0
   
   return self
end

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

function Zemgief:near()
   
	if self:isOpponentAttacking() then
		
		self.frame = 1
		self.state = 2
		
		self:block()
		
		return

	end

	self:spd()
	
end

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