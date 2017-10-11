module Data.ArrayBuffer.DataView
  ( DataView
  , view
  , viewWhole
  , buffer
  , byteSize
  , byteLength
  , byteOffset
  , byteLength'
  , byteOffset'
  , getInt8
  , setInt8
  , getInt16be
  , setInt16be
  , getInt16le
  , setInt16le
  , getInt32be
  , setInt32be
  , getInt32le
  , setInt32le
  ) where

import Control.Monad.Eff (Eff)
import Data.ArrayBuffer (ARRAY_BUFFER, ArrayBuffer)
import Data.Function ((>>>))
import Data.Function.Uncurried (Fn3, Fn4, Fn5, runFn3, runFn4, runFn5)
import Data.Semigroup ((<>))
import Data.Show (class Show, show)
import Data.Typelevel.Num (class Add, class Lt, class LtEq, class Nat, class Pos, D0, D1, D3, toInt)
import Data.Typelevel.Undefined (undefined)
import Data.Unit (Unit)

type Endianness = Boolean

-- | 1st Type - type-level natural number representing an offset in the underlying `ArrayBuffer`
-- | 2nd Type - type-level natural number representing a length of the `DataView`
foreign import data DataView :: Type -> Type -> Type

instance showDataView :: (Nat o, Nat l) => Show (DataView o l) where
  show dv = "DataView[" <> show (byteOffset dv) <>
                   ", " <> show (byteLength dv) <>
                   "]"

foreign import viewWhole :: ∀ s. ArrayBuffer s -> DataView D0 s

foreign import _view :: ∀ s o l. Fn3 Int Int (ArrayBuffer s) (DataView o l)

view :: ∀ s o l e. Nat o => Pos l => Add o l e => Lt o l => LtEq e s =>
                  o -> l -> ArrayBuffer s -> DataView o l
view o l b = runFn3 _view (toInt o) (toInt l) b

-- | `ArrayBuffer` being mapped by the view.
foreign import buffer :: ∀ s o l. DataView o l -> ArrayBuffer s

-- | Represents the size of the underlying `ArrayBuffer`
foreign import byteSize :: ∀ o l. DataView o l -> Int

-- | Represents the offset of this view from the start of its `ArrayBuffer`
byteOffset :: ∀ o l. Nat o => DataView o l -> Int
byteOffset = byteOffset' >>> toInt

byteOffset' :: ∀ o l. Nat o => DataView o l -> o
byteOffset' _ = undefined

-- | Represents the length of this view
byteLength :: ∀ o l. Nat l => DataView o l -> Int
byteLength = byteLength' >>> toInt

byteLength' :: ∀ o l. Nat l => DataView o l -> l
byteLength' _ = undefined

foreign import get :: ∀ e o l r.
                      Fn4 String Int Endianness (DataView o l) (Eff (arrayBuffer :: ARRAY_BUFFER | e) r)

foreign import set :: ∀ e o l r.
                      Fn5 String Int r Endianness (DataView o l) (Eff (arrayBuffer :: ARRAY_BUFFER | e) Unit)

-- TODO: custom type error messages


-- | Fetch int8 value at a certain index in a `DataView`.
getInt8 :: ∀ e o l i .
           Nat i => Lt i l =>
           i -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Int
getInt8 offset = runFn4 get "Int8" (toInt offset) false

-- | Store int8 value at a certain index in a `DataView`.
setInt8 :: ∀ e o l i .
           Nat i => Lt i l =>
           i -> Int -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Unit
setInt8 offset i = runFn5 set "Int8" (toInt offset) i false


-- | Fetch int16 value at a certain index in a `DataView` using a big-endian byte order
getInt16be :: ∀ o l i d e .
           Nat i => Add i D1 d => Lt d l =>
           i -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Int
getInt16be offset = runFn4 get "Int16" (toInt offset) false

-- | Store int16 value at a certain index in a `DataView` using a big-endian byte order
setInt16be :: ∀ o l i d e .
           Nat i => Add i D1 d => Lt d l =>
           i -> Int -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Unit
setInt16be offset i = runFn5 set "Int16" (toInt offset) i false

-- | Fetch int16 value at a certain index in a `DataView` using a little-endian byte order
getInt16le :: ∀ o l i d e .
           Nat i => Add i D1 d => Lt d l =>
           i -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Int
getInt16le offset = runFn4 get "Int16" (toInt offset) true

-- | Store int16 value at a certain index in a `DataView` using a little-endian byte order
setInt16le :: ∀ o l i d e .
           Nat i => Add i D1 d => Lt d l =>
           i -> Int -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Unit
setInt16le offset i = runFn5 set "Int16" (toInt offset) i true


-- | Fetch int32 value at a certain index in a `DataView` using a big-endian byte order
getInt32be :: ∀ o l i d e .
           Nat i => Add i D3 d => Lt d l =>
           i -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Int
getInt32be offset = runFn4 get "Int32" (toInt offset) false

-- | Store int32 value at a certain index in a `DataView` using a big-endian byte order
setInt32be :: ∀ o l i d e .
           Nat i => Add i D3 d => Lt d l =>
           i -> Int -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Unit
setInt32be offset i = runFn5 set "Int32" (toInt offset) i false

-- | Fetch int32 value at a certain index in a `DataView` using a little-endian byte order
getInt32le :: ∀ o l i d e .
           Nat i => Add i D3 d => Lt d l =>
           i -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Int
getInt32le offset = runFn4 get "Int32" (toInt offset) true

-- | Store int32 value at a certain index in a `DataView` using a little-endian byte order
setInt32le :: ∀ o l i d e .
           Nat i => Add i D3 d => Lt d l =>
           i -> Int -> DataView o l -> Eff (arrayBuffer :: ARRAY_BUFFER | e) Unit
setInt32le offset i = runFn5 set "Int32" (toInt offset) i true
