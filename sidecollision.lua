function sideCollision(bx1,by1,bw,bh, ax1,ay1,aw,ah)
  local abottom, bbottom, aright, bright = ay1 + ah, by1 + bh, ax1 + aw, bx1 + bw
  local bcollision, tcollision, lcollision, rcollision = bbottom - ay1, abottom - by1, aright - bx1, bright - ax1
  if tcollision < bcollision and tcollision < lcollision and tcollision < rcollision then
    return "top", tostring(tcollision)
  elseif bcollision < tcollision and bcollision < lcollision and bcollision < rcollision then
    return "bottom", tostring(bcollision)
  elseif lcollision < rcollision and lcollision < tcollision and lcollision < bcollision then
    return "left", tostring(lcollision)
    elseif rcollision < lcollision and rcollision < tcollision and rcollision < bcollision then
      return "right", tostring(rcollision)
    else
      return "invalid"
  end
end
