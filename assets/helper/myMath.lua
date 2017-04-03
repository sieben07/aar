myMath = {}

function myMath.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end