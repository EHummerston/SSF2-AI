-----------------------------------------------------------------------------
-- This is a collection of functions for use in modifying the Super Street
-- Fight II UI to accommodate third-party computer-controller characters.
-- 
-- 2017 Edward Hummerston
-----------------------------------------------------------------------------

sfdraw = {}

sfdraw.white = 0xffe6e6e6
sfdraw.black = 0xff193a7b
sfdraw.blue = 0xff319cb5
sfdraw.yellow = 0xfff7b552
sfdraw.red = 0xffd62100
sfdraw.orange = 0xfff75a3a
sfdraw.text = 0xfff78746

-----------------------------------------------------------------------------
-- Draws a controller's input state to the emulator screen in an arcade
-- layout.
--
-- @param  playerSlot    The controller port to represent. (Also determines
--                       drawn position.)
-----------------------------------------------------------------------------
function sfdraw.sfdraw.Pad(playerSlot)
   local bX = ((playerSlot==1) and 79 or 151)   -- left side of control display
   local bY = 47  -- top of control display
   gui.sfdraw.Ellipse(bX,bY,8,8, sfdraw.black) -- circle of joystick base
   gui.sfdraw.Ellipse(bX+3,bY + 3, 2, 2, sfdraw.black, sfdraw.black)  -- joystick shaft base
   
   local pY = 0   -- player Y-axis input
   if (joypad.get(playerSlot)["Up"]) then
      pY = -1
   elseif (joypad.get(playerSlot )["Down"]) then
      pY = 1
   end
   local pX = 0   -- player X-axis input
   if (joypad.get(playerSlot )["Left"]) then
      pX = -1
   elseif (joypad.get(playerSlot )["Right"]) then
      pX = 1
   end
   gui.sfdraw.Pixel(bX+4 + pX,bY + 4 + pY, sfdraw.black)   -- joystick shaft
   gui.sfdraw.Ellipse(bX+2+(pX*3),bY + 2 + (pY*3), 4, 4, sfdraw.orange, sfdraw.orange)  -- joystick head
   
   -- some pixels to add sphere effect
   gui.sfdraw.Pixel(bX+5+(pX*3),bY + 3 + (pY*3), sfdraw.white)
   gui.sfdraw.Pixel(bX+4+(pX*3),bY + 2 + (pY*3), sfdraw.yellow)
   
   bX = bX + 12
   -- Y/Light Punch
   if (joypad.get(playerSlot )["Y"]) then
      gui.sfdraw.Ellipse(bX, bY, 3, 3, sfdraw.blue, sfdraw.blue)
   else
      gui.sfdraw.Ellipse(bX, bY, 3, 3, sfdraw.black, sfdraw.black)
   end
   
   -- B/Light Kick
   if (joypad.get(playerSlot )["B"]) then
      gui.sfdraw.Ellipse(bX, bY+5, 3, 3, sfdraw.blue, sfdraw.blue)
   else
      gui.sfdraw.Ellipse(bX, bY+5, 3, 3, sfdraw.black, sfdraw.black)
   end
   
   bY = bY - 1 -- the first pair of buttons are lower on an arcade stick
   bX = bX + 5
   -- X/Medium Punch
   if (joypad.get(playerSlot )["X"]) then
      gui.sfdraw.Ellipse(bX, bY, 3, 3, sfdraw.yellow, sfdraw.yellow)
   else
      gui.sfdraw.Ellipse(bX, bY, 3, 3, sfdraw.black, sfdraw.black)
   end
   
   -- A/Medium Kick
   if (joypad.get(playerSlot )["A"]) then
      gui.sfdraw.Ellipse(bX, bY+5, 3, 3, sfdraw.yellow, sfdraw.yellow)
   else
      gui.sfdraw.Ellipse(bX, bY+5, 3, 3, sfdraw.black, sfdraw.black)
   end
   
   bX = bX + 5
   -- L/Heavy Punch
   if (joypad.get(playerSlot )["L"]) then
      gui.sfdraw.Ellipse(bX, bY, 3, 3, sfdraw.red, sfdraw.red)
   else
      gui.sfdraw.Ellipse(bX, bY, 3, 3, sfdraw.black, sfdraw.black)
   end
   
   -- R/Heavy Kick
   if (joypad.get(playerSlot )["R"]) then
      gui.sfdraw.Ellipse(bX, bY+5, 3, 3, sfdraw.red, sfdraw.red)
   else
      gui.sfdraw.Ellipse(bX, bY+5, 3, 3, sfdraw.black, sfdraw.black)
   end

end

-----------------------------------------------------------------------------
-- Draws a string to the emulator screen in the style of SSF2 in-game
-- character names.
--
-- @param  playerSlot    The player character being named. (Determines drawn
--                       position.)
-- @param  name          The string to be drawn.
-----------------------------------------------------------------------------
function sfdraw.sfdraw.Name(playerSlot, name)
   local nameX = ((playerSlot==1) and 30 or 227)
   local textAlign = ((playerSlot==1) and "left" or "right")
   
   -- text shadow sfdraw.n first
   gui.sfdraw.Text(nameX+1,57, name, sfdraw.black, 0x00000000, 14, null, "bold", textAlign, "bottom")
   gui.sfdraw.Text(nameX,56, name, sfdraw.yellow, 0x00000000, 14, null, "bold", textAlign, "bottom")
end