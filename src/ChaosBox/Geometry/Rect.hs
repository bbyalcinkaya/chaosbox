{-# LANGUAGE TypeFamilies #-}
module ChaosBox.Geometry.Rect
  ( RectOf(..)
  , Rect
  , rect
  , square
  , bounds
  )
where

import           ChaosBox.Prelude

import           ChaosBox.Draw
import           ChaosBox.HasV2
import           Control.Lens             ((^.))
import           Data.Foldable            (toList)
import           Graphics.Rendering.Cairo hiding (Path, transform)

-- | A Rectangle
data RectOf a = RectOf
  { rectTopLeft :: a
  , rectW       :: Double
  , rectH       :: Double
  }
  deriving stock (Show, Eq, Ord, Functor, Foldable, Traversable)

type Rect = RectOf (V2 Double)

instance HasV2 a => Draw (RectOf a) where
  draw RectOf {..} = rectangle rectX rectY rectW rectH
    where V2 rectX rectY = rectTopLeft ^. _V2

rect :: a -> Double -> Double -> RectOf a
rect c w h = RectOf c w h

square :: a -> Double -> RectOf a
square c w = RectOf c w w

-- | Get the bounds of a list of positioned objects.
bounds :: (HasV2 a, Foldable f) => f a -> Rect
bounds xs = rect tl w h
 where
  l        = toList xs
  tl       = minimum $ map (^. _V2) l
  br       = maximum $ map (^. _V2) l
  (V2 w h) = br - tl
