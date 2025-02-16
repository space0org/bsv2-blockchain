// Copyright (c) 2009-2010 Satoshi Nakamoto
// Copyright (c) 2009-2016 The Bitcoin Core developers
// Copyright (c) 2019 Bitcoin Association
// Distributed under the Open BSV software license, see the accompanying file LICENSE.

#ifndef BITCOIN_CONSENSUS_PARAMS_H
#define BITCOIN_CONSENSUS_PARAMS_H

#include "uint256.h"

namespace Consensus {

/**
 * Parameters that influence chain consensus.
 */
struct Params {
    uint256 hashGenesisBlock;
    // Modified halving interval for new blockchain (every 105,000 blocks, ~2 years)
    int nSubsidyHalvingInterval = 105000;
    /** Block height and hash at which BIP34 becomes active */
    int32_t BIP34Height;
    uint256 BIP34Hash;
    /** Block height at which BIP65 becomes active */
    int32_t BIP65Height;
    /** Block height at which BIP66 becomes active */
    int32_t BIP66Height;
    /** Block height at which CSV (BIP68, BIP112 and BIP113) becomes active */
    int32_t CSVHeight;
    /** Block height at which UAHF kicks in */
    int32_t uahfHeight;
    /** Block height at which the new DAA becomes active */
    int32_t daaHeight;
    /** Block height at which the Genesis becomes active.
      * The specified block height is the height of the block where the new rules are active.
      * It is not the height of the last block with the old rules.
      */
    int32_t genesisHeight;
    /**
     * Minimum blocks including miner confirmation of the total of 2016 blocks
     * in a retargeting period, (nPowTargetTimespan / nPowTargetSpacing) which
     * is also used for BIP9 deployments.
     * Examples: 1916 for 95%, 1512 for testchains.
     */
    uint32_t nRuleChangeActivationThreshold;
    uint32_t nMinerConfirmationWindow;
    /** Proof of work parameters */
    uint256 powLimit;
    bool fPowAllowMinDifficultyBlocks;
    bool fPowNoRetargeting;
    // Modified target spacing (5 minutes between blocks)
    int64_t nPowTargetSpacing = 5 * 60;
    // Modified target timespan (3.5 days)
    int64_t nPowTargetTimespan = 3.5 * 24 * 60 * 60;
    int64_t DifficultyAdjustmentInterval() const {
        return nPowTargetTimespan / nPowTargetSpacing;
    }
    uint256 nMinimumChainWork;
    uint256 defaultAssumeValid;
};
} // namespace Consensus

#endif // BITCOIN_CONSENSUS_PARAMS_H
