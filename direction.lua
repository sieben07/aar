if hero.xvel > 0 then
   if hero.inAir then
      if not hero.shoot then
         hero.direction = "jumpRightMoving"
         elseif hero.shoot then
            hero.dircetion="jumpRightShooting"
      end

   elseif not hero.inAir then
         if not hero.shoot then
         hero.direction ="right"
         elseif hero.shoot then
            hero.direction="rightShooting"
         end
   end
      
elseif hero.xvel < 0 then
   if hero.inAir then
      hero.direction ="jumpLeftMoving"
      elseif not hero.inAir then
         hero.direction ="left"
   end
elseif hero.xvel == 0 and hero.inAir then
   if hero.direction == "jumpRightMoving" or hero.direction == "right" then
      hero.direction = "jumpRight"
      elseif hero.direction == "jumpLeftMoving" or hero.direction == "left" then
         hero.direction = "jumpLeft"
      end


end



if not hero.inAir then
   if hero.xvel > 0 then
      if not hero.shooting then
         hero.direction="right"
         else if hero.shooting then
            hero.direction="rightShooting"
      end

   elseif hero.xvel < 0 then
      if not hero.shooting then
         hero.direction="left"
         elseif hero.shooting then
            hero.direction="leftShooting"
      end
   elseif hero.xvel == 0 then
      if not hero.shooting then
         hero.direction="right"
   
   end
   elseif hero.inAir then

end


if hero.inAir then
   if hero.xvel == 0 then
      if hero.direction =="right" or hero.direction == "jumpRightMoving" or hero.direction =="jumpRight" then
         if hero.shoot then
            hero.direction = "jumpRightShooting"
            elseif not hero.shoot then
               hero.direction ="jumpRight"
            end
         elseif hero.direction =="left" or hero.direction == "jumpLeftMoving" then
            hero.direction ="jumpLeft"
      end
   end
end