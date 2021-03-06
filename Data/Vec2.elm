
{-
    Copyright (c) John P Mayer Jr, 2013

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-}

module Data.Vec2 exposing (..)

{-| A short utilities library for 2D vectors as records

#Vec2
@docs Vec2, Vec2Ext, addVec, addVec2, crossVecMag, distance, distanceSquared, dotVec, extractVec, fromIntPair, magSquared, magnitude, midVec, minimumDist, negVec, origin, rotVec, scaleVec, subVec, sumVec, vecTranslate
-}

import Transform exposing (Transform, matrix)

{-| 2D Vector -}
type alias Vec2Ext a = { a | x : Float, y : Float }

{-| TODO -}
type alias Vec2 = Vec2Ext {}

{-| TODO -}
origin : Vec2
origin = { x = 0, y = 0 }

{-| TODO -}
fromIntPair : (Int,Int) -> Vec2
fromIntPair (x,y) = { x = toFloat x, y = toFloat y }

{-| TODO -}
scaleVec : Float -> Vec2Ext a -> Vec2Ext a
scaleVec a v = { v | x = v.x * a, y = v.y * a }

{-| TODO -}
negVec : Vec2Ext a -> Vec2Ext a
negVec = scaleVec -1

{-| TODO -}
rotVec : Float -> Vec2Ext a -> Vec2Ext a
rotVec theta v =
  let newX = v.x * cos theta - v.y * sin theta
      newY = v.x * sin theta + v.y * cos theta
  in { v | x = newX, y = newY }
      
{-| TODO -}
addVec : Vec2Ext a -> Vec2Ext b -> Vec2Ext b
addVec v1 v2 = 
  let newX = v1.x + v2.x
      newY = v1.y + v2.y
  in { v2 | x = newX, y = newY }

{-| subtract the first vector from the second vector -}
subVec : Vec2Ext a -> Vec2Ext b -> Vec2Ext b
subVec v1 = addVec <| scaleVec (-1) v1
{-| TODO -}
addVec2 : Vec2 -> Vec2 -> Vec2
addVec2 = addVec
{-| TODO -}
midVec : Vec2Ext a -> Vec2Ext b -> Vec2Ext b
midVec v1 v2 = scaleVec (1/2) <| addVec v1 v2 
{-| TODO -}
extractVec : Vec2Ext a -> Vec2
extractVec v = { x = v.x, y = v.y }
{-| TODO -}
sumVec : List (Vec2Ext a) -> Vec2
sumVec = List.foldl addVec origin << List.map extractVec
{-| TODO -}
magnitude : Vec2Ext a -> Float
magnitude v = sqrt <| v.x * v.x + v.y * v.y
{-| TODO -}              
magSquared : Vec2Ext a -> Float
magSquared v = v.x * v.x + v.y * v.y
{-| TODO -}
distance : Vec2Ext a -> Vec2Ext b -> Float
distance v1 v2 = magnitude <| subVec v2 v1
{-| TODO -}
distanceSquared : Vec2Ext a -> Vec2Ext b -> Float
distanceSquared v1 v2 = magSquared <| subVec v2 v1
{-| TODO -}
dotVec : Vec2Ext a -> Vec2Ext b -> Float
dotVec v1 v2 = v1.x * v2.x + v1.y * v2.y
{-| TODO -}
crossVecMag : Vec2Ext a -> Vec2Ext b -> Float
crossVecMag v1 v2 =
  v1.x * v2.y - v1.y * v2.x
{-| TODO -}
vecTranslate : Vec2Ext a -> Transform
vecTranslate v = matrix 1 0 0 1 v.x v.y

{-| find the minimum distance and offset of a line segment and a point -}
minimumDist : Vec2Ext a -> Vec2Ext a -> Vec2Ext b -> { r : Float, offset : Float }
minimumDist v w p = 
  let l2 = distanceSquared v w
  in if l2 == 0
     then { r = distance v p, offset = 0 }
     else 
      let t = (dotVec (subVec v p) (subVec v w)) / l2
          r = if t < 0
              then distance p v 
              else 
                if t > 1
                then distance p w
                else
                  let projection = addVec v <| scaleVec t <| subVec v w
                  in distance p projection
          tFix = clamp 0 1 t
      in { r = r, offset = tFix * sqrt l2 }
