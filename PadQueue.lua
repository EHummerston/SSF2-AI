-----------------------------------------------------------------------------
-- A simple queue structure to facilitate delays in controller output.
-----------------------------------------------------------------------------

PadQueue = {}
local PadQueue_mt = {__index = PadQueue}

-----------------------------------------------------------------------------
-- Constructor.
--
-- @return               An instance of the created object.
-----------------------------------------------------------------------------
function PadQueue.new ()
   local self = {first = 0, last = -1}
   setmetatable(self, PadQueue_mt)
   
   return self
end

-----------------------------------------------------------------------------
-- Add an entry to the end of the queue.
--
-- @param playerSlot     The entry to be added at the back of the queue.
-----------------------------------------------------------------------------
function PadQueue:enqueue (value)
   local last = self.last + 1
   self.last = last
   self[last] = value
end

-----------------------------------------------------------------------------
-- Get the entry from the front of the queue. (Removes it from the queue.)
--
-- @return               The entry leaving the queue.
-----------------------------------------------------------------------------
function PadQueue:dequeue ()
   local first = self.first
   if first > self.last then
      error("List is empty")
   end
   local value = self[first]
   self[first] = nil -- to allow garbage collection
   self.first = first + 1
   return value
end