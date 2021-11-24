{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
module Cardano.DbSync.Types
  ( BlockDetails (..)
  , BlockEra (..)
  , CardanoBlock
  , CardanoPoint
  , CardanoProtocol
  , EpochSlot (..)
  , FetchResult (..)
  , SlotDetails (..)
  , TipInfo (..)
  , MetricSetters (..)
  , PoolFetchRetry (..)
  , Retry (..)
  ) where

import           Cardano.Prelude hiding (Meta)

import           Cardano.Db (PoolHashId, PoolMetaHash, PoolMetadataRefId, PoolOfflineData,
                   PoolOfflineFetchError, PoolUrl)

import           Cardano.DbSync.Config.Types (CardanoBlock, CardanoProtocol)

import           Cardano.Slotting.Slot (EpochNo (..), EpochSize (..), SlotNo (..))

import           Data.Time.Clock (UTCTime)
import           Data.Time.Clock.POSIX (POSIXTime)

import           Ouroboros.Network.Block (BlockNo, Point)


type CardanoPoint = Point CardanoBlock

data BlockDetails = BlockDetails
  { bdBlock :: !CardanoBlock
  , bdSlot :: !SlotDetails
  }

data BlockEra
  = Byron
  | Shelley
  | Allegra
  | Mary
  | Alonzo
  deriving (Eq, Show)


-- | Slot within an Epoch.
newtype EpochSlot = EpochSlot
  { unEpochSlot :: Word64
  } deriving (Eq, Ord, Show)

data FetchResult
    = ResultMetadata !PoolOfflineData
    | ResultError !PoolOfflineFetchError
    deriving Show

data SlotDetails = SlotDetails
  { sdSlotTime :: !UTCTime
  , sdCurrentTime :: !UTCTime
  , sdEpochNo :: !EpochNo
  , sdSlotNo :: !SlotNo
  , sdEpochSlot :: !EpochSlot
  , sdEpochSize :: !EpochSize
  } deriving (Eq, Show)

-- The hash must be unique!
data TipInfo = TipInfo
  { bHash :: !ByteString
  , bEpochNo :: !EpochNo
  , bSlotNo  :: !SlotNo
  , bBlockNo :: !BlockNo
  } deriving (Eq, Show)

-- The metrics we use.
-- Kept as a separate struct and do not put into environment because
-- when we need to test functions using this we need to initialize the
-- whole environment and not just pass in the layer. This shows clearly
-- that it needs to remain a separate parameter passed around where needed.
data MetricSetters = MetricSetters
  { metricsSetNodeBlockHeight :: BlockNo -> IO ()
  , metricsSetDbQueueLength :: Natural -> IO ()
  , metricsSetDbBlockHeight :: BlockNo -> IO ()
  , metricsSetDbSlotHeight :: SlotNo -> IO ()
  }

data PoolFetchRetry = PoolFetchRetry
  { pfrPoolHashId :: !PoolHashId
  , pfrReferenceId :: !PoolMetadataRefId
  , pfrPoolUrl :: !PoolUrl
  , pfrPoolMDHash :: !PoolMetaHash
  , pfrRetry :: !Retry
  } deriving (Show)


data Retry = Retry
  { retryFetchTime :: !POSIXTime -- Time last time time
  , retryRetryTime :: !POSIXTime -- Time to retry
  , retryCount :: !Word
  } deriving (Eq, Show, Generic)