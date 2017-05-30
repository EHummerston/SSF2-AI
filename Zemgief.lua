local frame = 0
local state = 0

local P1Pos = 0
local P2Pos = 0
local face = 0
local ES = 0
local CR = 0

local pad = {}

		
local function SPDLeft()

	if frame == 1 then 
	
		pad["P1 Down"] = false
		pad["P1 Up"] = false
		pad["P1 Right"] = false
		pad["P1 Left"] = true
		pad["P1 Y"] = false
	
	elseif frame == 2 then 
	
		pad["P1 Down"] = true
		pad["P1 Up"] = false
		pad["P1 Right"] = false
		pad["P1 Left"] = false
		pad["P1 Y"] = false

		
	elseif frame == 3 then 
	
		pad["P1 Down"] = false
		pad["P1 Up"] = false
		pad["P1 Right"] = true
		pad["P1 Left"] = false
		pad["P1 Y"] = false
		
	elseif frame == 4 then 
	
		pad["P1 Down"] = false
		pad["P1 Up"] = true
		pad["P1 Right"] = false
		pad["P1 Left"] = false
		pad["P1 Y"] = true
		
		
	elseif frame == 10 then 
	
		pad["P1 Down"] = false
		pad["P1 Up"] = false
		pad["P1 Right"] = false
		pad["P1 Left"] = false
		pad["P1 Y"] = false
		
	elseif frame > 35 then
		frame = 0
		state = 0
		return
	end
	
	joypad.set( pad )

end
local function SPDRight()

	if frame == 1 then 

		pad["P1 Down"] = false
		pad["P1 Up"] = false
		pad["P1 Right"] = true
		pad["P1 Left"] = false
		pad["P1 Y"] = false
	
	elseif frame == 2 then 
	
		pad["P1 Down"] = true
		pad["P1 Up"] = false
		pad["P1 Right"] = false
		pad["P1 Left"] = false
		pad["P1 Y"] = false

		
	elseif frame == 3 then 
	
		pad["P1 Down"] = false
		pad["P1 Up"] = false
		pad["P1 Right"] = false
		pad["P1 Left"] = true
		pad["P1 Y"] = false

		
	elseif frame == 4 then 
	
		pad["P1 Down"] = false
		pad["P1 Up"] = true
		pad["P1 Right"] = false
		pad["P1 Left"] = false
		pad["P1 Y"] = true
		
	elseif frame == 10 then 
	
		pad["P1 Down"] = false
		pad["P1 Up"] = false
		pad["P1 Right"] = false
		pad["P1 Left"] = false
		pad["P1 Y"] = false
		
	elseif frame > 35 then
		frame = 0
		state = 0
		return
	end
	
	joypad.set( pad )

end

local function AntiAir()

	if frame == 1 then 

		pad["P1 Left"] = false
		pad["P1 Right"] = false
		pad["P1 Up"] = true
	
	elseif frame == 2 then
		
		pad["P1 Up"] = true
		pad["P1 L"] = true
	
	else
	
		pad["P1 Up"] = false
		pad["P1 L"] = false
		
		frame = 0
		state = 0

	end
	
	joypad.set( pad )

end

local function BlockRight()

	ES = memory.read_u8(0x829)
	
	if ES ~= 1 then
		
		pad["P1 Left"] = false
		
		frame = 0
		state = 0
		
	else
	
		CR = memory.read_u8(0x784)
	
		if CR == 1 then
		
			pad["P1 Right"] = false
			pad["P1 Left"] = true
			pad["P1 Down"] = true
		
		else
		
			pad["P1 Right"] = false
			pad["P1 Left"] = true
		
		end

	end
	
	joypad.set( pad )

end
local function BlockLeft()

	ES = memory.read_u8(0x829)
	
	if ES ~= 1 then
		
		pad["P1 Right"] = false
		
		frame = 0
		state = 0

	else
	
		CR = memory.read_u8(0x784)

		if CR == 1 then
		
			pad["P1 Right"] = true
			pad["P1 Left"] = false
			pad["P1 Down"] = true
		
		else
		
			pad["P1 Right"] = true
			pad["P1 Left"] = false
		
		end
		
	end
	
	joypad.set( pad )

end

local function Block()

	face = memory.read_u8(0x5F3)

	if face == 0x40 then
	
		BlockRight()
	
	else
	
		BlockLeft()
	
	end
	
end
local function SPD()

	ES = memory.read_u8(0x829)

	if ES == 1 then
		
		frame = 1
		state = 2
		
		Block()
		
		return

	end

	face = memory.read_u8(0x5F3)

	if face == 0x40 then
	
		SPDRight()
	
	else
	
		SPDLeft()
	
	end
	
end
local function Idle()

	ES = memory.read_u8(0x829)

	if ES == 1 then
		
		frame = 1
		state = 2
		
		Block()
		
		return

	end

P1Pos = memory.read_u16_le(0x617)
P2Pos = memory.read_u16_le(0x857)

dist = memory.read_u8(0x5EB)

	if dist > 50 then 
	
		face = memory.read_u8(0x5F3)
	
		if face == 0x40 then
		
			pad["P1 Up"] = false
			pad["P1 Down"] = false	
			pad["P1 Right"] = true
			pad["P1 Left"] = false
			pad["P1 Y"] = false
		
		else
		
			pad["P1 Up"] = false
			pad["P1 Down"] = false
			pad["P1 Right"] = false
			pad["P1 Left"] = true
			pad["P1 Y"] = false
		
		end

		joypad.set( pad )
	
	else
	
		CR = memory.read_u8(0x788)
		
		if CR == 1 then
		AntiAir()
		else
		frame = 0
		state = 1
		end
	end
	
end


function giefAdvance()
	if state == 0 then
		Idle()
	elseif state == 1 then
		SPD()
	elseif state == 2 then
		Block()
	end

	if not emu.islagged() then
		frame = frame + 1
		
		else
		print("LAGG")
	end

end
