require("Bert")
-- add 'require' bits here

bertOne = Bert:create(1)
bertTwo = Bert:create(2)

bertTwo.playerSlot = 2 -- playerSlot not initialising properly in constructor.

while true do

	bertOne:resetPad()
  bertTwo:resetPad()
	
  bertOne:advance()
  bertTwo:advance()

  pads = bertOne:getPad()
  bertTwoPad = bertTwo:getPad()
  for k,v in pairs(bertTwoPad) do
    pads[k] = v
  end

  --print("Pad 2[1]: ")
  --print(bertTwoPad[1])
  --print("Combined Pads:")
  --print(pads)
  joypad.set(pads)

	emu.frameadvance()
	
end

-- DO NOT REACH HERE
