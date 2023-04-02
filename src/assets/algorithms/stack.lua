local function stack()
  local out = {}

  out.push = function(item)
    out[# + 1] = item
  end

  out.pop = function()
    if #out > 0 then
      return table.remove(out, #out)
    end
  end

  out.iterator = function()
    return function()
      return out.pop()
    end
  end
  return out
end
