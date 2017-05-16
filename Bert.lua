require("Bot")
require("inherits")

Bert = inheritsFrom(Bot)
-- Derived class methods

function Bert:init()
	self.name = "Bert"
end
	
function Bert:fireball()
	if self.i == 0 then
		self:setButton(self:getDirectionButton(false),true)
	elseif self.i == 1 then
		self:setButton("Down",true)
	elseif self.i == 2 then
		self:setButton("Down",true)
		self:setButton(self:getDirectionButton(true),true)
	elseif self.i == 3 then	
		self:setButton(self:getDirectionButton(true),true)
		self:setButton("X",true)
	elseif self.i > 45 then
		self.i = -1
	end
end

function Bert:dragonPunch()
	if self.i == 0 then
		self:setButton(self:getDirectionButton(true),true)
	elseif self.i == 1 then
		self:setButton("Down",true)
	elseif self.i == 2 then	
		self:setButton("Down",true)
		self:setButton(self:getDirectionButton(true),true)
		self:setButton("L",true)
	elseif self.i > 2 then
		self.i = -1
	end
end

function Bert:advance()
	self.i = self.i + 1
	if self:isOpponentAttacking() and not self:isOpponentAir() then	--if enemy is attacking and on the ground
		if self.newAttack and self:getDistance() < 0x24 then --if enemy is close and they weren't attacking last frame
			self:dragonPunch()
			self.action = "ume shoryken"
		elseif self:hasOpponentFireball() then --counter fireball with the same
			self:fireball()
			self.action = "counter fireball"
		else	--they are far away or this isn't the first frame of the attack
			self.newAttack = false
			self:setButton(self:getDirectionButton(false),true)
			self.action = "block"
			if self:isOpponentCrouching() then	--if enemy is crouching
				self:setButton("Down",true)
				self.action = "low block"
			end
		end
	else	--the enemy is in the air or not attacking
		self.newAttack = true
		if self:getDistance() < 0x28 then --they are close
			if self:isOpponentAir() then --if enemy is in air
				self:dragonPunch()
				self.action = "anti-air"
			else	--p2 is close on the ground
				self:setButton(self:getDirectionButton(false),true)
				self.action = "walk back"
			end
		else	--they are far away
			if not self:hasFireball() and not self:isOpponentAir() then --there isn't a fireball and p2 is on the ground
				if self.walkTimer <= 0 then	--we weren't walking too recently
					self:fireball()
					self.action = "fireball"
				else	--we were pressing forward recently
					self.walkTimer = self.walkTimer - 1
					self.action = "dp timeout"
				end
			else	--we have a fireball out or the enemy is in the air
				self:setButton(self:getDirectionButton(true),true)
				self.action = "walk forward"
				self.walkTimer = 10
			end
		end
	end
end

