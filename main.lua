---------   --------------------------------------------------------------------
-- The runtime file for the SSF2 AI framework. Loads the algorithms that will
-- control the 2 player characters, and then repeatedly polls them for input,
-- applying that input to the emulator.
-- 
-- 2017 Edward Hummerston
-----------------------------------------------------------------------------

require("Bert")
require("Zemgief")
require("SFDraw")

debugUI = true -- console outputs and extra text within emulator space

botOne = null
botTwo = null

botOne = Bert.new(1)
botTwo = Bert.new(2)

while true do  -- loop once per frame

   -- erase input values from previous frame
   if(botOne ~= null) then
      botOne:resetPad()
   end
   if(botTwo ~= null) then
      botTwo:resetPad()
   end
   
   -- this memory value is currently incorrect.
   if memory.read_u8(0x10083) == 0x0 then -- if the game is in a fight state
      -- algorithms resolve their controller states
      if(botOne ~= null) then
         botOne:advance()
      end
      if(botTwo ~= null) then
         botTwo:advance()
      end
   end
   
   -- convert separate player input tables to Bizhawk table
   pads = {}
   if(botOne ~= null) then
      pads = botOne:getPad()
      if(botTwo ~= null) then
         botTwoPad = botTwo:getPad()

         -- append first table with the second, formatting is already correct
         for k,v in pairs(botTwoPad) do
            pads[k] = v
         end
      end
   elseif(botTwo ~= null) then
      pads = botTwo:getPad()
   end
   
   -- send to emulator
   joypad.set(pads)

   -- p1 info
   if(botOne ~= null) then
      SFDraw.drawName(1, botOne:getName())
      SFDraw.drawPad(1)
   end
   
   -- p2 info
   if(botTwo ~= null) then
      SFDraw.drawName(2, botTwo:getName())
      SFDraw.drawPad(2)
   end
   
   if(debugUI) then
      -- proximity block boolean
      gui.pixelText(4,0,"atk " .. tostring(memory.read_u8(0x5E9) == 0x1))
      gui.pixelText(148,0,"atk " .. tostring(memory.read_u8(0x829) == 0x1))
      
      
      -- action print
      if(botOne ~= null) then
         gui.pixelText(4,8,botOne:getAction())
      end
      if(botTwo ~= null) then
         gui.pixelText(148,8,botTwo:getAction())
      end
      
      gui.pixelText(122,23,tostring(memory.read_u8(0x5EB))) -- distance
      
      gui.pixelText(16,35,tostring(memory.read_u8(0x530)))  -- p1 health
      gui.pixelText(227,35,tostring(memory.read_u8(0x770))) -- p2 health
   
   end
   
   -- emulator resolves cycle
   emu.frameadvance()
   
end

-- DO NOT REACH HERE
error("Infinite loop broken")