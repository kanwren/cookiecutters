module Main (main) where

import           Hedgehog
import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range

import           Test.Tasty (defaultMain, testGroup)
import qualified Test.Tasty.Hedgehog as THH
import           Test.Tasty.HUnit

prop_reverse :: Property
prop_reverse = property $ do
  xs <- forAll $ Gen.list (Range.linear 0 100) Gen.alpha
  reverse (reverse xs) === xs

main :: IO ()
main = defaultMain $ testGroup "tests"
  [ testGroup "properties"
    [ THH.testProperty "reverse" prop_reverse
    ]
  , testGroup "units"
    [ testCase "string reversal" $ reverse "foo" @?= "oof"
    ]
  ]

