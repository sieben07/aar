---
title: "Activate All Robots"
author: [Orhan Kücükyilmaz]
date: "2014-04-17"
keywords: [One Point Left]
titlepage: true
titlepage-color: "9BBBCC"
titlepage-text-color: "000000"
titlepage-rule-height: 32
titlepage-rule-color: "FFFFFF"
toc-own-page: true
header-left: "\\leftmark"
book: true
...

# Change History

| Version | Who                    | What                            | When       |
| ------- | ---------------------- | ------------------------------- | ---------- |
| 0.0.1   | Orhan Küçükyılmaz (OK) | Initial Document                | 17.04.2014 |
| 0.0.2   | Orhan Küçükyılmaz (OK) | Updated Image                   | 08.07.2015 |
| 0.0.3   | Orhan Küçükyılmaz (OK) | Added Project Goals             | 02.07.2017 |
| 0.0.4   | Orhan Küçükyılmaz (OK) | Change Game Over                | 21.06.2018 |
| 0.0.5   | Orhan Küçükyılmaz (OK) | First Jump Robot                | 08.07.2018 |
| 0.0.6   | Orhan Küçükyılmaz (OK) | Active Robots                   | 18.07.2018 |
| 0.0.7   | Orhan Küçükyılmaz (OK) | Shoot Colide                    | 06.08.2018 |
| 0.0.8   | Orhan Küçükyılmaz (OK) | State updates hero variables    | 21.03.2021 |
| 0.0.9   | Orhan Küçükyılmaz (OK) | High Jump Robot                 | 21.03.2021 |
| 0.0.10  | Orhan Küçükyılmaz (OK) | Shoots optimized                | 21.03.2021 |
| 0.0.11  | Orhan Küçükyılmaz (OK) | Simple Robot class added        | 24.05.2021 |
| 0.0.12  | Orhan Küçükyılmaz (OK) | Simple Projectile class added   | 24.05.2021 |
| 0.0.13  | Orhan Küçükyılmaz (OK) | More Robot ideas added          | 18.04.2022 |
| 0.0.14  | Orhan Küçükyılmaz (OK) | More Robot ideas added          | 14.06.2022 |
| 0.0.15  | Orhan Küçükyılmaz (OK) | Projectile Directions and speed | 17.06.2022 |

# Introduction

*a jump'n'shoot riddle game*‚

After the Hero's attack, it's your duty to...

> *activate all robots!*

Every `'activation-shoot'` reduces `points`. Every activated robot,
machine or trap adds `points`. Getting hit removes `points`. If the
player has only *`one point left`* he gets `warned` that only `one`
*ONE* shoot is left ...

~~\> ... *GAME OVER!*~~

> ... *AND ATFTER THAT, HE HAS NEGATIVE SCORE*

![His name is mini](./src/assets/img/mini.png "His name is mini")

# Levels, Robots, and more

In this Section it's all about the levels the robots and more.

## Level 0 - The Start/Menu level

Most games don't have a playable menu screen level. What is a playable
menu screen level, you ask? Good question, very good question indeed.

What is a menu screen?

Before a person can start a game he usually can selects on the menu
screen what he wants to do. The menu screen usually cointains a list of
selectable items:

- Start
- Options
- *(something something)*

On this menue screen the controls are usually different than the
controls in the game.

Up and down on a joy-pad, joystick or on a keyboard (sometimes "w" for
up and "s" for down) toggle between the menu items. With one button on
the joy-pad, joystick or keyboard (sometime space or enter) the user
select what he wants to do.

In this game the menu is a playable level. Why? So the user uses the
actual controls of the game and not some extra controls for the menu. So
he can learn the controls for the game early.

Level 0 teaches the player how to play the game, and presents him the
first robot to activate.

But first let us take a look at the elements of the first level:

![The Title](./src/assets/img/title.png "The Title")

## Project goals

No project is ever done if there are no goals set. To know when the
Version 1.0.0 is done of this game, some goals are set.

Some of this gaols will be hard set goals, like the number of different
levels, robots, boss robots and such. Some goals will be soft, like
graphics, sound, all the look and feel.

### Levels

A Minimum of 5 levels. Every Level has 5 Stages.

Level Zero is the playable menu level.

#### Level Structure

Each level exist of 5 stages. Each level has one theme and one kind of
robot. 4 stages of one level introduce one new robot, the 5th stage is
the Endgengner stage. Each level introduces a new kind of robot, each
stage introduces a new version of the robot.

## Robots

## Start Level

### Start Level (00)

- Start Robot

> - the Start Robot has to be activated
> - if activated it falls down

- Exit Robot

> - the exit robot appears if (all) the robots are activated
> - has to be activated also to leave the room

- Reset Robot

> - can be activated if to many activation shoots where used to leave
>     level 0-0
> - resets the points to seven
> - resets the start robot and the exit robot also.

- Continue Robot

> - appears if the level 1-0 to 1-4 are mastered
> - can be activated to continue the last played level

- Start Boss Robot

> - a hidden level? and a hidden boss?
> - sleeping tiger hidden dragon

## Jump Level

### Jump Level (01)

- Jump Robot

> - [x] starts jumping when activated
> - [x] helps get higher grounds
> - [x] blocks passages sometimes
> - [x] open passages by jumping away

### Jump Level (02)

- High Jump Robot

> - like the jump robot
> - [x] just jumps higher

### Jump Level (03)

- Jump Shoot Robot

> - [x] jumps and shoots

What about directions?

> - [ ] shoots to the left
> - [ ] shoots to the right
> - [ ] shoots to up
> - [ ] shoots to down
> - [ ] shoots diagonally left up
> - [ ] shoots diagonally right up
> - [ ] shoots diagonally left down
> - [ ] shoots diagonally right down

That's eight directions.

Maybe an easier way to understand this is to use the following diagram:


```
             x->
   +-(-1)----0------1-->
   |
   (-1)  7   0   1
   |      \  |  /
   |       +---+
 y 0  6 -- |   | -- 2
 | |       +---+
 v |      /  |  \
   1     5   4   3
   |
   v
```

| Number | direction  |      values      |
|--------|------------|------------------|
|      0 | up         | (x =  0, y = -1) |
|      1 | up-right   | (x =  1, y = -1) |
|      2 | righ       | (x =  1, y =  0) |
|      3 | down-right | (x =  1, y =  1) |
|      4 | down       | (x =  0, y =  1) |
|      5 | down-left  | (x = -1, y =  1) |
|      6 | left       | (x = -1, y =  0) |
|      7 | up-left    | (x = -1, y = -1) |


An enum could be used to represent the directions.

but what if we wanted to add more directions?

Then math comes to the rescue:


$$ x = r * cos(rad) $$
$$ y = r * sin(rad) $$

where `r` is the radius and `rad` is the angle in radians.

If `deg` is the angle in degrees, then we can use the following formula:

$$ x = r * cos(deg * \pi / 180) $$
$$ y = r * sin(deg * \pi / 180) $$

But then the values change for the directions

```
             x->
   +----------------->
   |     3   2   1
   |      \  |  /
   |       +---+
 y |  4 -- |   | -- 0
 | |       +---+
 v |      /  |  \
   |     5   6   7
   |
   v
```

| Number | direction  | values |
|--------|------------|--------|
|      0 | up         |      6 |
|      1 | up-right   |      7 |
|      2 | righ       |      0 |
|      3 | down-right |      1 |
|      4 | down       |      2 |
|      5 | down-left  |      3 |
|      6 | left       |      4 |
|      7 | up-left    |      5 |


But that seems to be confusing we would rather have degrees

```
             x->
   +--------------------->
   |    225°  270°  315°
   |        \  |  /
   |         +---+
 y | 180° -- |   | -- 0°
 | |         +---+
 v |        /  |  \
   |    135°  90°  45°
   |
   v
```

| Number | direction  | values   |
|--------|------------|----------|
|      0 | up         |      270 |
|      1 | up-right   |      315 |
|      2 | righ       |        0 |
|      3 | down-right |       45 |
|      4 | down       |       90 |
|      5 | down-left  |      135 |
|      6 | left       |      180 |
|      7 | up-left    |      225 |

### Jump Level (04)

- Gravity Jump Robot

> - [ ] jumps from the ground to the ceiling
> - [ ] can sometimes be like an elevator

### Jump Level (FINAL)

- Jump Boss Robot

> - does everything the other jump robots does
> - [ ] turned up to eleven

## Water level

### Water  Level (01)

- Swim Robot

> - [ ] starts swiming when activated (on ground if not)
> - [ ] helps get over water
> - [ ] blocks passages sometimes

### Water Level (02)

### Water Level (03)

### Water Level (04)

### Water Level (FINAL)

## Gravity Level

### Gravity  Level (01)

- Vertical Gravity Robot

> - [ ] starts falling up and down
> - [ ] helps get over the ground
> - [ ] blocks passages sometimes

### Gravity Level (02)

- Change Gravity Robot

> - [ ] starts changeing the gravity for player
> - [ ] helps get over the ground
> - [ ] blocks passages sometimes

### Gravity Level (03)

- Horrizontal Gravity Robot

> - [ ] starts falling left and right

### Gravity Level (04)

- Bullet Gravity Robot

> - [] Acctracts bullets

### Gravity Level (FINAL)

- Gravity Boss Robot

> - [ ] turns up to eleven

## Fire Level

### Fire  Level (01)

- Fire Robot

> - [ ] starts burining when activated
> - [ ] helps get over Fire
> - [ ] blocks passages sometimes

### Fire Level (02)

- Fire explosion Robot

> - [ ] starts exploding when activated


### Fire Level (03)

- Fire shooting Robot

> - [ ] starts shooting fire when activated

### Fire Level (04)

- Fire X Robot

> - [ ] starts x fire when activated

### Fire Level (FINAL)

- Fire Boss Robot

> - [ ] turns up to eleven

## Electro Level

### Electro  Level (01)

- Electo Robot

> - [ ] starts electrifying when activated
> - [ ] activates other robots
> - [ ] blocks passages sometimes

### Electro Level (02)

- Electo Shooting Robot

> - [ ] starts shooting charges when activated
> - [ ] activates other robots

### Electro Level (03)

- Electo Jump Shooting Robot

> - [ ] starts jumping shooting charges when activated
> - [ ] activates other robots

### Electro Level (04)

### Electro Level (FINAL)

## Laser Level

### Laser  Level (01)

- Swim Robot

> - [ ] starts swiming when activated (on ground if not)
> - [ ] helps get over Laser
> - [ ] blocks passages sometimes

### Laser Level (02)

### Laser Level (03)

### Laser Level (04)

### Laser Level (FINAL)

## Light Level

### Light  Level (01)

- Light Robot

> - [ ] starts lighting

### Light Level (02)

### Light Level (03)

### Light Level (04)

### Light Level (FINAL)

## Wind Level

### Wind  Level (01)

- Wind Robot

> - [ ] starts blowing wind
> - [ ] blocks passages sometimes

### Wind Level (02)

### Wind Level (03)

### Wind Level (04)

### Wind Level (FINAL)

### TODO

- [ ] HIT ANIMATION
- [ ] Hero sticky must be resolved better
- [ ] Jump robots dont push you through platforms (damage penalty) or phase through object
- [ ] Push robots into the robot array when certain conditions are met
