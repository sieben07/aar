local function priorityqueue()
  -- interface table
  local t = {}

  -- a storrage of elements
  local storrage = {}
  -- a storrage of prioritiy
  local priority_storrage = {}
  -- sorted list of priorities
  local keys = {}

  -- add an element into the storage, set its priority and add it to the priority and sorte keys
local function add(key, value)
  storage[key] = value
  if not priority_storrage[value] then
    table.insert(keys, value)
    table.sort(keys)
    local key0 = {key}
    priority_storrage[value] = key0
    setmetatable(key0, {
      __mode = "v"
    })
  else
    table.insert(priority_storrage[value], key)
  end
end


--     local queue = {}
--     local queue_size = 0
--     local queue_index = 0

--     local function swap(i, j)
--         local temp = queue[i]
--         queue[i] = queue[j]
--         queue[j] = temp
--     end

--     local function bubble_up(index)
--         local parent = math.floor(index / 2)
--         if parent >= 1 and queue[parent].priority > queue[index].priority then
--             swap(parent, index)
--             bubble_up(parent)
--         end
--     end

--     local function bubble_down(index)
--         local child = index * 2
--         if child > queue_size then
--             return
--         end
--         if child + 1 <= queue_size and queue[child + 1].priority < queue[child].priority then
--             child = child + 1
--         end
--         if queue[index].priority > queue[child].priority then
--             swap(index, child)
--             bubble_down(child)
--         end
--     end

--     local function enqueue(item, priority)
--         queue_size = queue_size + 1
--         queue[queue_size] = {item = item, priority = priority}
--         bubble_up(queue_size)
--     end

--     local function dequeue()
--         if queue_size == 0 then
--             return nil
--         end
--         local item = queue[1].item
--         queue[1] = queue[queue_size]
--         queue[queue_size] = nil
--         queue_size = queue_size - 1
--         bubble_down(1)
--         return item
--     end

--     local function peek()
--         if queue_size == 0 then
--             return nil
--         end
--         return queue[1].item
--     end

--     local function size()
--         return queue_size
--     end

--     local function is_empty()
--         return queue_size == 0
--     end

--     local function clear()
--         queue = {}
--         queue_size = 0
--         queue_index = 0
--     end

--     return {
--         enqueue = enqueue,
--         dequeue = dequeue,
--         peek = peek,
--         size = size,
--         is_empty = is_empty,
--         clear = clear
--     }
-- end
