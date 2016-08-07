function bertInit(playerSlot)

	botData[playerSlot]["i"] = 0
	botData[playerSlot]["newAttack"] = true
	botData[playerSlot]["walkTimer"] = 0
end

local function fireball(playerSlot)
	if botData[playerSlot]["i"] == 0 then
		setButton(playerSlot,getDirectionButton(playerSlot,false),true)
	elseif botData[playerSlot]["i"] == 1 then
		setButton(playerSlot,"Down",true)
	elseif botData[playerSlot]["i"] == 2 then
		setButton(playerSlot,"Down",true)
		setButton(playerSlot,getDirectionButton(playerSlot,true),true)
	elseif botData[playerSlot]["i"] == 3 then	
		setButton(playerSlot,getDirectionButton(playerSlot,true),true)
		setButton(playerSlot,"X",true)
	elseif botData[playerSlot]["i"] > 45 then
		botData[playerSlot]["i"] = -1
	end
end

local function dragonPunch(playerSlot)
	if botData[playerSlot]["i"] == 0 then
		setButton(playerSlot,getDirectionButton(playerSlot,true),true)
	elseif botData[playerSlot]["i"] == 1 then
		setButton(playerSlot,"Down",true)
	elseif botData[playerSlot]["i"] == 2 then	
		setButton(playerSlot,"Down",true)
		setButton(playerSlot,getDirectionButton(playerSlot,true),true)
		setButton(playerSlot,"L",true)
	elseif botData[playerSlot]["i"] > 2 then
		botData[playerSlot]["i"] = -1
	end
end

function bertAdvance(playerSlot)
	botData[playerSlot]["i"] = botData[playerSlot]["i"] + 1
	if isAttacking(playerSlot + 1) and not isAir(playerSlot + 1) then	--if enemy is attacking and on the ground
		if botData[playerSlot]["newAttack"] and getDistance(playerSlot) < 0x24 then --if enemy is close and they weren't attacking last frame
			dragonPunch(playerSlot)
		else	--they are far away or this isn't the first frame of the attack
			botData[playerSlot]["newAttack"] = false
			setButton(playerSlot,getDirectionButton(playerSlot,false),true)
			if isCrouching(playerSlot + 1) then	--if enemy is crouching
				setButton(playerSlot,"Down",true)
			end
		end
	else	--the enemy is in the air or not attacking
		botData[playerSlot]["newAttack"] = true
		if getDistance(playerSlot) < 0x28 then --they are close
			if isAir(playerSlot + 1) then --if enemy is in air
				dragonPunch(playerSlot)
			else	--p2 is close on the ground
				setButton(playerSlot,getDirectionButton(playerSlot,false),true)
			end
		else	--they are far away
			if not hasFireball(playerSlot) and not isAir(playerSlot + 1) then --there isn't a fireball and p2 is on the ground
				if botData[playerSlot]["walkTimer"] <= 0 then	--we weren't walking too recently
					fireball(playerSlot)
				else	--we were pressing forward recently
					botData[playerSlot]["walkTimer"] = botData[playerSlot]["walkTimer"] - 1
				end
			else	--we have a fireball out or the enemy is in the air
				setButton(playerSlot,getDirectionButton(playerSlot,true),true)
				botData[playerSlot]["walkTimer"] = 10
			end
		end
	end
end