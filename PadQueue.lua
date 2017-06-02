PadQueue = {}
local PadQueue_mt = {__index = PadQueue}

function PadQueue.new ()
   local self = {first = 0, last = -1}
   setmetatable(self, PadQueue_mt)
   
   return self
end

function PadQueue:enqueue (value)
   local last = self.last + 1
   self.last = last
   self[last] = value
end

function PadQueue:dequeue ()
      local first = self.first
      if first > self.last then
         error("List is empty")
         end
      local value = self[first]
      self[first] = nil        -- to allow garbage collection
      self.first = first + 1
      return value
    end