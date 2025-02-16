struct Params {
    uint256 hashGenesisBlock;
    int nSubsidyHalvingInterval;
    int32_t BIP34Height;
    uint256 BIP34Hash;
    int32_t BIP65Height;
    int32_t BIP66Height;
    int32_t CSVHeight;
    int32_t UBCHeight;
    int32_t UBCStopHeight;
    int32_t MagneticAnomalyHeight;
    int32_t GreatWallHeight;
    int32_t GravitonHeight;
    int32_t PhononHeight;
    int32_t QuasarHeight;
    uint256 powLimit;
    bool fPowAllowMinDifficultyBlocks;
    bool fPowNoRetargeting;
    int64_t nPowTargetSpacing;
    int64_t nPowTargetTimespan;
    int64_t DifficultyAdjustmentInterval() const {
        return nPowTargetTimespan / nPowTargetSpacing;
    }
    uint256 nMinimumChainWork;
    uint256 defaultAssumeValid;
};
