# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Using bools for storage incurs overhead | 9 |
| [GAS-2](#GAS-2) | Cache array length outside of loop | 18 |
| [GAS-3](#GAS-3) | For Operations that will not overflow, you could use unchecked | 1286 |
| [GAS-4](#GAS-4) | Use Custom Errors | 16 |
| [GAS-5](#GAS-5) | Don't initialize variables with default value | 31 |
| [GAS-6](#GAS-6) | Long revert strings | 8 |
| [GAS-7](#GAS-7) | Functions guaranteed to revert when called by normal users can be marked `payable` | 46 |
| [GAS-8](#GAS-8) | `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too) | 31 |
| [GAS-9](#GAS-9) | Using `private` rather than `public` for constants, saves gas | 11 |
| [GAS-10](#GAS-10) | Use shift Right/Left instead of division/multiplication if possible | 2 |
| [GAS-11](#GAS-11) | Splitting require() statements that use && saves gas | 5 |
| [GAS-12](#GAS-12) | Use != 0 instead of > 0 for unsigned integer comparison | 34 |
### <a name="GAS-1"></a>[GAS-1] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (9)*:
```solidity
File: src/AccessManager.sol

26:     mapping(uint256 => mapping(address => bool)) private _walletsWithAccess;

```

```solidity
File: src/dao/DAO.sol

67: 	mapping(string=>bool) public excludedCountries;

```

```solidity
File: src/dao/Proposals.sol

59: 	mapping(address=>bool) private _userHasActiveProposal;

```

```solidity
File: src/launch/Airdrop.sol

26: 	bool public claimingAllowed;

29: 	mapping(address=>bool) public claimed;

```

```solidity
File: src/launch/BootstrapBallot.sol

21: 	bool public ballotFinalized;

22: 	bool public startExchangeApproved;

25: 	mapping(address=>bool) public hasVoted;

```

```solidity
File: src/pools/Pools.sol

43: 	bool public exchangeIsLive;

```

### <a name="GAS-2"></a>[GAS-2] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (18)*:
```solidity
File: src/dao/Proposals.sol

423: 		for( uint256 i = 0; i < _openBallotsForTokenWhitelisting.length(); i++ )

```

```solidity
File: src/pools/PoolStats.sol

53: 		for( uint256 i = 0; i < poolIDs.length; i++ )

65: 		for( uint256 i = 0; i < poolIDs.length; i++ )

81: 		for( uint256 i = 0; i < poolIDs.length; i++ )

106: 		for( uint256 i = 0; i < poolIDs.length; i++ )

```

```solidity
File: src/rewards/RewardsEmitter.sol

60: 		for( uint256 i = 0; i < addedRewards.length; i++ )

116: 		for( uint256 i = 0; i < poolIDs.length; i++ )

146: 		for( uint256 i = 0; i < rewards.length; i++ )

```

```solidity
File: src/rewards/SaltRewards.sol

64: 		for( uint256 i = 0; i < addedRewards.length; i++ )

87: 		for( uint256 i = 0; i < addedRewards.length; i++ )

129: 		for( uint256 i = 0; i < poolIDs.length; i++ )

```

```solidity
File: src/staking/StakingRewards.sol

152: 		for( uint256 i = 0; i < poolIDs.length; i++ )

185: 		for( uint256 i = 0; i < addedRewards.length; i++ )

216: 		for( uint256 i = 0; i < shares.length; i++ )

226: 		for( uint256 i = 0; i < rewards.length; i++ )

260: 		for( uint256 i = 0; i < rewards.length; i++ )

277: 		for( uint256 i = 0; i < shares.length; i++ )

296: 		for( uint256 i = 0; i < cooldowns.length; i++ )

```

### <a name="GAS-3"></a>[GAS-3] For Operations that will not overflow, you could use unchecked

*Instances (1286)*:
```solidity
File: src/AccessManager.sol

4: import "./interfaces/IAccessManager.sol";

4: import "./interfaces/IAccessManager.sol";

5: import "./dao/interfaces/IDAO.sol";

5: import "./dao/interfaces/IDAO.sol";

5: import "./dao/interfaces/IDAO.sol";

6: import "./SigningTools.sol";

45:         geoVersion += 1;

```

```solidity
File: src/ExchangeConfig.sol

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "./launch/interfaces/IInitialDistribution.sol";

5: import "./launch/interfaces/IInitialDistribution.sol";

5: import "./launch/interfaces/IInitialDistribution.sol";

6: import "./rewards/interfaces/IRewardsEmitter.sol";

6: import "./rewards/interfaces/IRewardsEmitter.sol";

6: import "./rewards/interfaces/IRewardsEmitter.sol";

7: import "./interfaces/IExchangeConfig.sol";

7: import "./interfaces/IExchangeConfig.sol";

8: import "./launch/interfaces/IAirdrop.sol";

8: import "./launch/interfaces/IAirdrop.sol";

8: import "./launch/interfaces/IAirdrop.sol";

9: import "./interfaces/IUpkeep.sol";

9: import "./interfaces/IUpkeep.sol";

10: import "./interfaces/IManagedWallet.sol";

10: import "./interfaces/IManagedWallet.sol";

24: 	IDAO public dao; // can only be set once

24: 	IDAO public dao; // can only be set once

25: 	IUpkeep public upkeep; // can only be set once

25: 	IUpkeep public upkeep; // can only be set once

26: 	IInitialDistribution public initialDistribution; // can only be set once

26: 	IInitialDistribution public initialDistribution; // can only be set once

27: 	IAirdrop public airdrop; // can only be set once

27: 	IAirdrop public airdrop; // can only be set once

30: 	VestingWallet public teamVestingWallet;		// can only be set once

30: 	VestingWallet public teamVestingWallet;		// can only be set once

31: 	VestingWallet public daoVestingWallet;		// can only be set once

31: 	VestingWallet public daoVestingWallet;		// can only be set once

```

```solidity
File: src/ManagedWallet.sol

4: import "./interfaces/IManagedWallet.sol";

4: import "./interfaces/IManagedWallet.sol";

49: 		require( proposedMainWallet == address(0), "Cannot overwrite non-zero proposed mainWallet." );

66:     		activeTimelock = block.timestamp + TIMELOCK_DURATION; // establish the timelock

66:     		activeTimelock = block.timestamp + TIMELOCK_DURATION; // establish the timelock

66:     		activeTimelock = block.timestamp + TIMELOCK_DURATION; // establish the timelock

68: 			activeTimelock = type(uint256).max; // effectively never

68: 			activeTimelock = type(uint256).max; // effectively never

```

```solidity
File: src/Salt.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

5: import "./interfaces/ISalt.sol";

5: import "./interfaces/ISalt.sol";

13: 	uint256 public constant INITIAL_SUPPLY = 100 * MILLION_ETHER ;

37:     	return INITIAL_SUPPLY - totalSupply();

```

```solidity
File: src/Upkeep.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

6: import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

6: import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

6: import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

6: import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

7: import "./price_feed/interfaces/IPriceAggregator.sol";

7: import "./price_feed/interfaces/IPriceAggregator.sol";

7: import "./price_feed/interfaces/IPriceAggregator.sol";

8: import "./stable/interfaces/IStableConfig.sol";

8: import "./stable/interfaces/IStableConfig.sol";

8: import "./stable/interfaces/IStableConfig.sol";

9: import "./rewards/interfaces/IEmissions.sol";

9: import "./rewards/interfaces/IEmissions.sol";

9: import "./rewards/interfaces/IEmissions.sol";

10: import "./pools/interfaces/IPoolsConfig.sol";

10: import "./pools/interfaces/IPoolsConfig.sol";

10: import "./pools/interfaces/IPoolsConfig.sol";

11: import "./interfaces/IExchangeConfig.sol";

11: import "./interfaces/IExchangeConfig.sol";

12: import "./dao/interfaces/IDAOConfig.sol";

12: import "./dao/interfaces/IDAOConfig.sol";

12: import "./dao/interfaces/IDAOConfig.sol";

13: import "./pools/interfaces/IPools.sol";

13: import "./pools/interfaces/IPools.sol";

13: import "./pools/interfaces/IPools.sol";

14: import "./dao/interfaces/IDAO.sol";

14: import "./dao/interfaces/IDAO.sol";

14: import "./dao/interfaces/IDAO.sol";

119: 		uint256 rewardAmount = withdrawnAmount * daoConfig.upkeepRewardPercent() / 100;

119: 		uint256 rewardAmount = withdrawnAmount * daoConfig.upkeepRewardPercent() / 100;

152: 		uint256 amountOfWETH = wethBalance * stableConfig.percentArbitrageProfitsForStablePOL() / 100;

152: 		uint256 amountOfWETH = wethBalance * stableConfig.percentArbitrageProfitsForStablePOL() / 100;

165: 		uint256 amountOfWETH = wethBalance * daoConfig.arbitrageProfitsPercentPOL() / 100;

165: 		uint256 amountOfWETH = wethBalance * daoConfig.arbitrageProfitsPercentPOL() / 100;

186: 		uint256 timeSinceLastUpkeep = block.timestamp - lastUpkeepTimeEmissions;

207: 		uint256 timeSinceLastUpkeep = block.timestamp - lastUpkeepTimeRewardsEmitters;

289: 		return daoWETH * daoConfig.upkeepRewardPercent() / 100;

289: 		return daoWETH * daoConfig.upkeepRewardPercent() / 100;

```

```solidity
File: src/arbitrage/ArbitrageSearch.sol

4: import "../interfaces/IExchangeConfig.sol";

4: import "../interfaces/IExchangeConfig.sol";

5: import "../pools/PoolUtils.sol";

5: import "../pools/PoolUtils.sol";

16:    	uint256 constant public MIDPOINT_PRECISION = 0.001e18; // .001 ETH precision for arb search

16:    	uint256 constant public MIDPOINT_PRECISION = 0.001e18; // .001 ETH precision for arb search

68: 			uint256 amountOut = (reservesA1 * midpoint) / (reservesA0 + midpoint);

68: 			uint256 amountOut = (reservesA1 * midpoint) / (reservesA0 + midpoint);

68: 			uint256 amountOut = (reservesA1 * midpoint) / (reservesA0 + midpoint);

69: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

69: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

69: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

70: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

70: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

70: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

72: 			int256 profitMidpoint = int256(amountOut) - int256(midpoint);

80: 			midpoint += MIDPOINT_PRECISION;

82: 			amountOut = (reservesA1 * midpoint) / (reservesA0 + midpoint);

82: 			amountOut = (reservesA1 * midpoint) / (reservesA0 + midpoint);

82: 			amountOut = (reservesA1 * midpoint) / (reservesA0 + midpoint);

83: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

83: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

83: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

84: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

84: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

84: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

86: 			int256 profitRightOfMidpoint = int256(amountOut) - int256(midpoint);

112: 			uint256 rightPoint = swapAmountInValueInETH + (swapAmountInValueInETH >> 2); // 100% + 25% of swapAmountInValueInETH

112: 			uint256 rightPoint = swapAmountInValueInETH + (swapAmountInValueInETH >> 2); // 100% + 25% of swapAmountInValueInETH

112: 			uint256 rightPoint = swapAmountInValueInETH + (swapAmountInValueInETH >> 2); // 100% + 25% of swapAmountInValueInETH

112: 			uint256 rightPoint = swapAmountInValueInETH + (swapAmountInValueInETH >> 2); // 100% + 25% of swapAmountInValueInETH

115: 			for( uint256 i = 0; i < 8; i++ )

115: 			for( uint256 i = 0; i < 8; i++ )

117: 				uint256 midpoint = (leftPoint + rightPoint) >> 1;

126: 			bestArbAmountIn = (leftPoint + rightPoint) >> 1;

129: 			uint256 amountOut = (reservesA1 * bestArbAmountIn) / (reservesA0 + bestArbAmountIn);

129: 			uint256 amountOut = (reservesA1 * bestArbAmountIn) / (reservesA0 + bestArbAmountIn);

129: 			uint256 amountOut = (reservesA1 * bestArbAmountIn) / (reservesA0 + bestArbAmountIn);

130: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

130: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

130: 			amountOut = (reservesB1 * amountOut) / (reservesB0 + amountOut);

131: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

131: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

131: 			amountOut = (reservesC1 * amountOut) / (reservesC0 + amountOut);

133: 			if ( ( int256(amountOut) - int256(bestArbAmountIn) ) < int256(PoolUtils.DUST) )

```

```solidity
File: src/dao/DAO.sol

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "../price_feed/interfaces/IPriceAggregator.sol";

5: import "../price_feed/interfaces/IPriceAggregator.sol";

5: import "../price_feed/interfaces/IPriceAggregator.sol";

6: import "../rewards/interfaces/IRewardsEmitter.sol";

6: import "../rewards/interfaces/IRewardsEmitter.sol";

6: import "../rewards/interfaces/IRewardsEmitter.sol";

7: import "../rewards/interfaces/IRewardsConfig.sol";

7: import "../rewards/interfaces/IRewardsConfig.sol";

7: import "../rewards/interfaces/IRewardsConfig.sol";

8: import "../stable/interfaces/IStableConfig.sol";

8: import "../stable/interfaces/IStableConfig.sol";

8: import "../stable/interfaces/IStableConfig.sol";

9: import "../stable/interfaces/ILiquidizer.sol";

9: import "../stable/interfaces/ILiquidizer.sol";

9: import "../stable/interfaces/ILiquidizer.sol";

10: import "../interfaces/IExchangeConfig.sol";

10: import "../interfaces/IExchangeConfig.sol";

11: import "../staking/interfaces/IStaking.sol";

11: import "../staking/interfaces/IStaking.sol";

11: import "../staking/interfaces/IStaking.sol";

12: import "../interfaces/IAccessManager.sol";

12: import "../interfaces/IAccessManager.sol";

13: import "./interfaces/ICalledContract.sol";

13: import "./interfaces/ICalledContract.sol";

14: import "./interfaces/IProposals.sol";

14: import "./interfaces/IProposals.sol";

15: import "./interfaces/IDAO.sol";

15: import "./interfaces/IDAO.sol";

16: import "../pools/PoolUtils.sol";

16: import "../pools/PoolUtils.sol";

17: import "./Parameters.sol";

18: import "../Upkeep.sol";

247: 			require( saltBalance >= bootstrappingRewards * 2, "Whitelisting is not currently possible due to insufficient bootstrapping rewards" );

265: 			exchangeConfig.salt().approve( address(liquidityRewardsEmitter), bootstrappingRewards * 2 );

341: 		uint256 amountToSendToTeam = claimedSALT / 10;

345: 		uint256 remainingSALT = claimedSALT - amountToSendToTeam;

348: 		uint256 saltToBurn = ( remainingSALT * daoConfig.percentPolRewardsBurned() ) / 100;

348: 		uint256 saltToBurn = ( remainingSALT * daoConfig.percentPolRewardsBurned() ) / 100;

369: 		uint256 liquidityToWithdraw = (liquidityHeld * percentToLiquidate) / 100;

369: 		uint256 liquidityToWithdraw = (liquidityHeld * percentToLiquidate) / 100;

```

```solidity
File: src/dao/DAOConfig.sol

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "./interfaces/IDAOConfig.sol";

5: import "./interfaces/IDAOConfig.sol";

40: 	uint256 public baseBallotQuorumPercentTimes1000 = 10 * 1000; // Default 10% of the total amount of SALT staked with a 1000x multiplier

40: 	uint256 public baseBallotQuorumPercentTimes1000 = 10 * 1000; // Default 10% of the total amount of SALT staked with a 1000x multiplier

40: 	uint256 public baseBallotQuorumPercentTimes1000 = 10 * 1000; // Default 10% of the total amount of SALT staked with a 1000x multiplier

49: 	uint256 public requiredProposalPercentStakeTimes1000 = 500;  // Defaults to 0.50% with a 1000x multiplier

49: 	uint256 public requiredProposalPercentStakeTimes1000 = 500;  // Defaults to 0.50% with a 1000x multiplier

69:                 bootstrappingRewards += 50000 ether;

74:                 bootstrappingRewards -= 50000 ether;

86: 				percentPolRewardsBurned += 5;

91: 				percentPolRewardsBurned -= 5;

102: 			if (baseBallotQuorumPercentTimes1000 < 20 * 1000)

103: 				baseBallotQuorumPercentTimes1000 += 1000;

107: 			if (baseBallotQuorumPercentTimes1000 > 5 * 1000 )

108: 				baseBallotQuorumPercentTimes1000 -= 1000;

120:                 ballotMinimumDuration += 1 days;

125:                 ballotMinimumDuration -= 1 days;

136: 			if (requiredProposalPercentStakeTimes1000 < 2000) // Maximum 2%

136: 			if (requiredProposalPercentStakeTimes1000 < 2000) // Maximum 2%

137: 				requiredProposalPercentStakeTimes1000 += 100; // Increase by 0.10%

137: 				requiredProposalPercentStakeTimes1000 += 100; // Increase by 0.10%

137: 				requiredProposalPercentStakeTimes1000 += 100; // Increase by 0.10%

141: 			if (requiredProposalPercentStakeTimes1000 > 100) // Minimum 0.10%

141: 			if (requiredProposalPercentStakeTimes1000 > 100) // Minimum 0.10%

142: 			   requiredProposalPercentStakeTimes1000 -= 100; // Decrease by 0.10%

142: 			   requiredProposalPercentStakeTimes1000 -= 100; // Decrease by 0.10%

142: 			   requiredProposalPercentStakeTimes1000 -= 100; // Decrease by 0.10%

154: 				maxPendingTokensForWhitelisting += 1;

159: 				maxPendingTokensForWhitelisting -= 1;

171:                 arbitrageProfitsPercentPOL += 5;

176:                 arbitrageProfitsPercentPOL -= 5;

188:                 upkeepRewardPercent += 1;

193:                 upkeepRewardPercent -= 1;

```

```solidity
File: src/dao/Parameters.sol

4: import "../price_feed/interfaces/IPriceAggregator.sol";

4: import "../price_feed/interfaces/IPriceAggregator.sol";

4: import "../price_feed/interfaces/IPriceAggregator.sol";

5: import "../rewards/interfaces/IRewardsConfig.sol";

5: import "../rewards/interfaces/IRewardsConfig.sol";

5: import "../rewards/interfaces/IRewardsConfig.sol";

6: import "../staking/interfaces/IStakingConfig.sol";

6: import "../staking/interfaces/IStakingConfig.sol";

6: import "../staking/interfaces/IStakingConfig.sol";

7: import "../stable/interfaces/IStableConfig.sol";

7: import "../stable/interfaces/IStableConfig.sol";

7: import "../stable/interfaces/IStableConfig.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

9: import "./interfaces/IDAOConfig.sol";

9: import "./interfaces/IDAOConfig.sol";

```

```solidity
File: src/dao/Proposals.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

6: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

6: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

6: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

6: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

8: import "openzeppelin-contracts/contracts/utils/Strings.sol";

8: import "openzeppelin-contracts/contracts/utils/Strings.sol";

8: import "openzeppelin-contracts/contracts/utils/Strings.sol";

8: import "openzeppelin-contracts/contracts/utils/Strings.sol";

9: import "../pools/interfaces/IPoolsConfig.sol";

9: import "../pools/interfaces/IPoolsConfig.sol";

9: import "../pools/interfaces/IPoolsConfig.sol";

10: import "../staking/interfaces/IStaking.sol";

10: import "../staking/interfaces/IStaking.sol";

10: import "../staking/interfaces/IStaking.sol";

11: import "../interfaces/IExchangeConfig.sol";

11: import "../interfaces/IExchangeConfig.sol";

12: import "./interfaces/IDAOConfig.sol";

12: import "./interfaces/IDAOConfig.sol";

13: import "./interfaces/IProposals.sol";

13: import "./interfaces/IProposals.sol";

14: import "./interfaces/IDAO.sol";

14: import "./interfaces/IDAO.sol";

15: import "../pools/PoolUtils.sol";

15: import "../pools/PoolUtils.sol";

67: 	uint256 immutable firstPossibleProposalTimestamp = block.timestamp + 45 days;

90: 			uint256 requiredXSalt = ( totalStaked * daoConfig.requiredProposalPercentStakeTimes1000() ) / ( 100 * 1000 );

90: 			uint256 requiredXSalt = ( totalStaked * daoConfig.requiredProposalPercentStakeTimes1000() ) / ( 100 * 1000 );

90: 			uint256 requiredXSalt = ( totalStaked * daoConfig.requiredProposalPercentStakeTimes1000() ) / ( 100 * 1000 );

105: 		uint256 ballotMinimumEndTime = block.timestamp + daoConfig.ballotMinimumDuration();

108: 		ballotID = nextBallotID++;

108: 		ballotID = nextBallotID++;

165: 		require( token.totalSupply() < type(uint112).max, "Token supply cannot exceed uint112.max" ); // 5 quadrillion max supply with 18 decimals of precision

165: 		require( token.totalSupply() < type(uint112).max, "Token supply cannot exceed uint112.max" ); // 5 quadrillion max supply with 18 decimals of precision

202: 		uint256 maxSendable = balance * 5 / 100;

202: 		uint256 maxSendable = balance * 5 / 100;

224: 		require( bytes(country).length == 2, "Country must be an ISO 3166 Alpha-2 Code" );

233: 		require( bytes(country).length == 2, "Country must be an ISO 3166 Alpha-2 Code" );

269: 		else // If a Ballot is not a Parameter Ballot, it is an Approval ballot

269: 		else // If a Ballot is not a Parameter Ballot, it is an Approval ballot

284: 			_votesCastForBallot[ballotID][lastVote.vote] -= lastVote.votingPower;

287: 		_votesCastForBallot[ballotID][vote] += userVotingPower;

324: 			requiredQuorum = ( 1 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

324: 			requiredQuorum = ( 1 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

324: 			requiredQuorum = ( 1 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

324: 			requiredQuorum = ( 1 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

326: 			requiredQuorum = ( 2 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

326: 			requiredQuorum = ( 2 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

326: 			requiredQuorum = ( 2 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

326: 			requiredQuorum = ( 2 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

329: 			requiredQuorum = ( 3 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

329: 			requiredQuorum = ( 3 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

329: 			requiredQuorum = ( 3 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

329: 			requiredQuorum = ( 3 * totalStaked * daoConfig.baseBallotQuorumPercentTimes1000()) / ( 100 * 1000 );

335: 		uint256 minimumQuorum = totalSupply * 5 / 1000;

335: 		uint256 minimumQuorum = totalSupply * 5 / 1000;

348: 			return votes[Vote.INCREASE] + votes[Vote.DECREASE] + votes[Vote.NO_CHANGE];

348: 			return votes[Vote.INCREASE] + votes[Vote.DECREASE] + votes[Vote.NO_CHANGE];

350: 			return votes[Vote.YES] + votes[Vote.NO];

423: 		for( uint256 i = 0; i < _openBallotsForTokenWhitelisting.length(); i++ )

423: 		for( uint256 i = 0; i < _openBallotsForTokenWhitelisting.length(); i++ )

429: 			if ( (yesTotal + noTotal) >= quorum ) // Make sure that quorum has been reached

429: 			if ( (yesTotal + noTotal) >= quorum ) // Make sure that quorum has been reached

429: 			if ( (yesTotal + noTotal) >= quorum ) // Make sure that quorum has been reached

430: 			if ( yesTotal > noTotal )  // Make sure the token vote is favorable

430: 			if ( yesTotal > noTotal )  // Make sure the token vote is favorable

431: 			if ( yesTotal > mostYes )  // Make sure these are the most yes votes seen

431: 			if ( yesTotal > mostYes )  // Make sure these are the most yes votes seen

```

```solidity
File: src/launch/Airdrop.sol

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

6: import "../interfaces/IExchangeConfig.sol";

6: import "../interfaces/IExchangeConfig.sol";

7: import "../staking/interfaces/IStaking.sol";

7: import "../staking/interfaces/IStaking.sol";

7: import "../staking/interfaces/IStaking.sol";

8: import "./interfaces/IAirdrop.sol";

8: import "./interfaces/IAirdrop.sol";

64: 		saltAmountForEachUser = saltBalance / numberAuthorized();

```

```solidity
File: src/launch/BootstrapBallot.sol

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "../interfaces/IExchangeConfig.sol";

5: import "../interfaces/IExchangeConfig.sol";

6: import "./interfaces/IBootstrapBallot.sol";

6: import "./interfaces/IBootstrapBallot.sol";

7: import "./interfaces/IAirdrop.sol";

7: import "./interfaces/IAirdrop.sol";

8: import "../SigningTools.sol";

41: 		completionTimestamp = block.timestamp + ballotDuration;

57: 			startExchangeYes++;

57: 			startExchangeYes++;

59: 			startExchangeNo++;

59: 			startExchangeNo++;

```

```solidity
File: src/launch/InitialDistribution.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

5: import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

5: import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

5: import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

6: import "../rewards/interfaces/ISaltRewards.sol";

6: import "../rewards/interfaces/ISaltRewards.sol";

6: import "../rewards/interfaces/ISaltRewards.sol";

7: import "../rewards/interfaces/IEmissions.sol";

7: import "../rewards/interfaces/IEmissions.sol";

7: import "../rewards/interfaces/IEmissions.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

9: import "./interfaces/IInitialDistribution.sol";

9: import "./interfaces/IInitialDistribution.sol";

10: import "./interfaces/IBootstrapBallot.sol";

10: import "./interfaces/IBootstrapBallot.sol";

11: import "./interfaces/IAirdrop.sol";

11: import "./interfaces/IAirdrop.sol";

12: import "../interfaces/ISalt.sol";

12: import "../interfaces/ISalt.sol";

53: 		require( salt.balanceOf(address(this)) == 100 * MILLION_ETHER, "SALT has already been sent from the contract" );

56: 		salt.safeTransfer( address(emissions), 52 * MILLION_ETHER );

59: 		salt.safeTransfer( address(daoVestingWallet), 25 * MILLION_ETHER );

62: 		salt.safeTransfer( address(teamVestingWallet), 10 * MILLION_ETHER );

65: 		salt.safeTransfer( address(airdrop), 5 * MILLION_ETHER );

72: 		salt.safeTransfer( address(saltRewards), 8 * MILLION_ETHER );

73: 		saltRewards.sendInitialSaltRewards(5 * MILLION_ETHER, poolIDs );

```

```solidity
File: src/pools/PoolMath.sol

3: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

4: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

4: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

4: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

4: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

5: import "./interfaces/IPools.sol";

5: import "./interfaces/IPools.sol";

6: import "./PoolUtils.sol";

15:     k = r0 * r1

18:     s1 = r1 - k / (r0 + s0)

18:     s1 = r1 - k / (r0 + s0)

18:     s1 = r1 - k / (r0 + s0)

21:     s1 = r1 - r0 * r1 / (r0 + s0)

21:     s1 = r1 - r0 * r1 / (r0 + s0)

21:     s1 = r1 - r0 * r1 / (r0 + s0)

21:     s1 = r1 - r0 * r1 / (r0 + s0)

24:     (r0 + s0) / ( r1 - s1)

24:     (r0 + s0) / ( r1 - s1)

24:     (r0 + s0) / ( r1 - s1)

27:     a0 = z0 - s0

28:     a1 = z1 + s1

31:     a0 / a1 = (r0 + s0) / ( r1 - s1)

31:     a0 / a1 = (r0 + s0) / ( r1 - s1)

31:     a0 / a1 = (r0 + s0) / ( r1 - s1)

31:     a0 / a1 = (r0 + s0) / ( r1 - s1)

34:     (z0 - s0) / ( z1 + s1) = (r0 + s0) / ( r1 - s1)

34:     (z0 - s0) / ( z1 + s1) = (r0 + s0) / ( r1 - s1)

34:     (z0 - s0) / ( z1 + s1) = (r0 + s0) / ( r1 - s1)

34:     (z0 - s0) / ( z1 + s1) = (r0 + s0) / ( r1 - s1)

34:     (z0 - s0) / ( z1 + s1) = (r0 + s0) / ( r1 - s1)

34:     (z0 - s0) / ( z1 + s1) = (r0 + s0) / ( r1 - s1)

41:     (c-x)/(d+y) = (a+x)/(b-y)

41:     (c-x)/(d+y) = (a+x)/(b-y)

41:     (c-x)/(d+y) = (a+x)/(b-y)

41:     (c-x)/(d+y) = (a+x)/(b-y)

41:     (c-x)/(d+y) = (a+x)/(b-y)

41:     (c-x)/(d+y) = (a+x)/(b-y)

44:     y = b - ab/(a+x)

44:     y = b - ab/(a+x)

44:     y = b - ab/(a+x)

47:     (c-x)/(d+y) = (a+x)/(b-y)

47:     (c-x)/(d+y) = (a+x)/(b-y)

47:     (c-x)/(d+y) = (a+x)/(b-y)

47:     (c-x)/(d+y) = (a+x)/(b-y)

47:     (c-x)/(d+y) = (a+x)/(b-y)

47:     (c-x)/(d+y) = (a+x)/(b-y)

50:     (c-x)(b-y) = (a+x)(d+y)

50:     (c-x)(b-y) = (a+x)(d+y)

50:     (c-x)(b-y) = (a+x)(d+y)

50:     (c-x)(b-y) = (a+x)(d+y)

53:     bc - cy - bx + xy = ad + ay + dx + xy

53:     bc - cy - bx + xy = ad + ay + dx + xy

53:     bc - cy - bx + xy = ad + ay + dx + xy

53:     bc - cy - bx + xy = ad + ay + dx + xy

53:     bc - cy - bx + xy = ad + ay + dx + xy

53:     bc - cy - bx + xy = ad + ay + dx + xy

56:     bc - cy - bx = ad + ay + dx

56:     bc - cy - bx = ad + ay + dx

56:     bc - cy - bx = ad + ay + dx

56:     bc - cy - bx = ad + ay + dx

59:     - bc + cy + bx = - ad - ay - dx

59:     - bc + cy + bx = - ad - ay - dx

59:     - bc + cy + bx = - ad - ay - dx

59:     - bc + cy + bx = - ad - ay - dx

59:     - bc + cy + bx = - ad - ay - dx

59:     - bc + cy + bx = - ad - ay - dx

62:     bx + dx + ay + cy = bc - ad

62:     bx + dx + ay + cy = bc - ad

62:     bx + dx + ay + cy = bc - ad

62:     bx + dx + ay + cy = bc - ad

65:     x(b+d) + y(a+c) = bc - ad

65:     x(b+d) + y(a+c) = bc - ad

65:     x(b+d) + y(a+c) = bc - ad

65:     x(b+d) + y(a+c) = bc - ad

68:     x(b+d) + b(a+c) - ab(a+c)/(a+x) = bc - ad

68:     x(b+d) + b(a+c) - ab(a+c)/(a+x) = bc - ad

68:     x(b+d) + b(a+c) - ab(a+c)/(a+x) = bc - ad

68:     x(b+d) + b(a+c) - ab(a+c)/(a+x) = bc - ad

68:     x(b+d) + b(a+c) - ab(a+c)/(a+x) = bc - ad

68:     x(b+d) + b(a+c) - ab(a+c)/(a+x) = bc - ad

68:     x(b+d) + b(a+c) - ab(a+c)/(a+x) = bc - ad

68:     x(b+d) + b(a+c) - ab(a+c)/(a+x) = bc - ad

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

71:     x(b+d)(a+x) + b(a+c)(a+x) - ab(a+c) = (bc - ad)(a+x)

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

74:     x(ab+bx+ad+dx) + b(aa+ax+ac+cx) - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

77:     abx+bxx+adx+dxx + aab+abx+abc+bcx - aab - abc = abc+bcx-aad-adx

80:     abx + bxx + adx + dxx + abx = abc - aad - adx

80:     abx + bxx + adx + dxx + abx = abc - aad - adx

80:     abx + bxx + adx + dxx + abx = abc - aad - adx

80:     abx + bxx + adx + dxx + abx = abc - aad - adx

80:     abx + bxx + adx + dxx + abx = abc - aad - adx

80:     abx + bxx + adx + dxx + abx = abc - aad - adx

83:     bxx + dxx + abx + abx + adx + adx = abc - aad

83:     bxx + dxx + abx + abx + adx + adx = abc - aad

83:     bxx + dxx + abx + abx + adx + adx = abc - aad

83:     bxx + dxx + abx + abx + adx + adx = abc - aad

83:     bxx + dxx + abx + abx + adx + adx = abc - aad

83:     bxx + dxx + abx + abx + adx + adx = abc - aad

86:     xx(b+d) + x(2ab + 2ad) = abc - aad

86:     xx(b+d) + x(2ab + 2ad) = abc - aad

86:     xx(b+d) + x(2ab + 2ad) = abc - aad

86:     xx(b+d) + x(2ab + 2ad) = abc - aad

89:     xx(b+d) + x(2ab + 2ad) + (aad-abc) = 0

89:     xx(b+d) + x(2ab + 2ad) + (aad-abc) = 0

89:     xx(b+d) + x(2ab + 2ad) + (aad-abc) = 0

89:     xx(b+d) + x(2ab + 2ad) + (aad-abc) = 0

89:     xx(b+d) + x(2ab + 2ad) + (aad-abc) = 0

92:     xx(b+d) + x(2a)(b+d) + (aad-abc) = 0

92:     xx(b+d) + x(2a)(b+d) + (aad-abc) = 0

92:     xx(b+d) + x(2a)(b+d) + (aad-abc) = 0

92:     xx(b+d) + x(2a)(b+d) + (aad-abc) = 0

92:     xx(b+d) + x(2a)(b+d) + (aad-abc) = 0

95:     xx + x(2a) + (aad-abc)/(b+d) = 0

95:     xx + x(2a) + (aad-abc)/(b+d) = 0

95:     xx + x(2a) + (aad-abc)/(b+d) = 0

95:     xx + x(2a) + (aad-abc)/(b+d) = 0

95:     xx + x(2a) + (aad-abc)/(b+d) = 0

97:     xxA + xB + C = 0

97:     xxA + xB + C = 0

101:     C = a(ad - bc)/(b+d)

101:     C = a(ad - bc)/(b+d)

101:     C = a(ad - bc)/(b+d)

109:     C = r0(r0z1 - r1z0)/(r1 + z1)

109:     C = r0(r0z1 - r1z0)/(r1 + z1)

109:     C = r0(r0z1 - r1z0)/(r1 + z1)

111:     x = [-B + sqrt(B^2 - 4AC)] / 2A

111:     x = [-B + sqrt(B^2 - 4AC)] / 2A

111:     x = [-B + sqrt(B^2 - 4AC)] / 2A

111:     x = [-B + sqrt(B^2 - 4AC)] / 2A

119:         if (x >= 2**128) { x >>= 128; msb += 128; }

119:         if (x >= 2**128) { x >>= 128; msb += 128; }

119:         if (x >= 2**128) { x >>= 128; msb += 128; }

120:         if (x >= 2**64) { x >>= 64; msb += 64; }

120:         if (x >= 2**64) { x >>= 64; msb += 64; }

120:         if (x >= 2**64) { x >>= 64; msb += 64; }

121:         if (x >= 2**32) { x >>= 32; msb += 32; }

121:         if (x >= 2**32) { x >>= 32; msb += 32; }

121:         if (x >= 2**32) { x >>= 32; msb += 32; }

122:         if (x >= 2**16) { x >>= 16; msb += 16; }

122:         if (x >= 2**16) { x >>= 16; msb += 16; }

122:         if (x >= 2**16) { x >>= 16; msb += 16; }

123:         if (x >= 2**8) { x >>= 8; msb += 8; }

123:         if (x >= 2**8) { x >>= 8; msb += 8; }

123:         if (x >= 2**8) { x >>= 8; msb += 8; }

124:         if (x >= 2**4) { x >>= 4; msb += 4; }

124:         if (x >= 2**4) { x >>= 4; msb += 4; }

124:         if (x >= 2**4) { x >>= 4; msb += 4; }

125:         if (x >= 2**2) { x >>= 2; msb += 2; }

125:         if (x >= 2**2) { x >>= 2; msb += 2; }

125:         if (x >= 2**2) { x >>= 2; msb += 2; }

126:         if (x >= 2**1) { x >>= 1; msb += 1; }

126:         if (x >= 2**1) { x >>= 1; msb += 1; }

126:         if (x >= 2**1) { x >>= 1; msb += 1; }

162: 			shift = maximumMSB - 80;

184:         uint256 B = 2 * r0;

192:         uint256 C = r0 * ( r1 * z0 - r0 * z1 ) / ( r1 + z1 );

192:         uint256 C = r0 * ( r1 * z0 - r0 * z1 ) / ( r1 + z1 );

192:         uint256 C = r0 * ( r1 * z0 - r0 * z1 ) / ( r1 + z1 );

192:         uint256 C = r0 * ( r1 * z0 - r0 * z1 ) / ( r1 + z1 );

192:         uint256 C = r0 * ( r1 * z0 - r0 * z1 ) / ( r1 + z1 );

192:         uint256 C = r0 * ( r1 * z0 - r0 * z1 ) / ( r1 + z1 );

193:         uint256 discriminant = B * B + 4 * A * C;

193:         uint256 discriminant = B * B + 4 * A * C;

193:         uint256 discriminant = B * B + 4 * A * C;

193:         uint256 discriminant = B * B + 4 * A * C;

203: 		swapAmount = ( sqrtDiscriminant - B ) / ( 2 * A );

203: 		swapAmount = ( sqrtDiscriminant - B ) / ( 2 * A );

203: 		swapAmount = ( sqrtDiscriminant - B ) / ( 2 * A );

215: 		if ( zapAmountA * reserveB > reserveA * zapAmountB )

215: 		if ( zapAmountA * reserveB > reserveA * zapAmountB )

219: 		if ( zapAmountA * reserveB < reserveA * zapAmountB )

219: 		if ( zapAmountA * reserveB < reserveA * zapAmountB )

```

```solidity
File: src/pools/PoolStats.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

5: import "../interfaces/IExchangeConfig.sol";

5: import "../interfaces/IExchangeConfig.sol";

6: import "./interfaces/IPoolsConfig.sol";

6: import "./interfaces/IPoolsConfig.sol";

7: import "./interfaces/IPoolStats.sol";

7: import "./interfaces/IPoolStats.sol";

8: import "./PoolUtils.sol";

42: 		_arbitrageProfits[poolID] += arbitrageProfit;

53: 		for( uint256 i = 0; i < poolIDs.length; i++ )

53: 		for( uint256 i = 0; i < poolIDs.length; i++ )

65: 		for( uint256 i = 0; i < poolIDs.length; i++ )

65: 		for( uint256 i = 0; i < poolIDs.length; i++ )

81: 		for( uint256 i = 0; i < poolIDs.length; i++ )

81: 		for( uint256 i = 0; i < poolIDs.length; i++ )

106: 		for( uint256 i = 0; i < poolIDs.length; i++ )

106: 		for( uint256 i = 0; i < poolIDs.length; i++ )

112: 			uint256 arbitrageProfit = _arbitrageProfits[poolID] / 3;

118: 					_calculatedProfits[indicies.index1] += arbitrageProfit;

121: 					_calculatedProfits[indicies.index2] += arbitrageProfit;

124: 					_calculatedProfits[indicies.index3] += arbitrageProfit;

```

```solidity
File: src/pools/PoolUtils.sol

3: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

3: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

5: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

5: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

5: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

5: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

5: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "./interfaces/IPools.sol";

6: import "./interfaces/IPools.sol";

61: 		uint256 maxAmountIn = reservesIn * maximumInternalSwapPercentTimes1000 / (100 * 1000);

61: 		uint256 maxAmountIn = reservesIn * maximumInternalSwapPercentTimes1000 / (100 * 1000);

61: 		uint256 maxAmountIn = reservesIn * maximumInternalSwapPercentTimes1000 / (100 * 1000);

```

```solidity
File: src/pools/Pools.sol

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

4: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

7: import "openzeppelin-contracts/contracts/access/Ownable.sol";

7: import "openzeppelin-contracts/contracts/access/Ownable.sol";

7: import "openzeppelin-contracts/contracts/access/Ownable.sol";

7: import "openzeppelin-contracts/contracts/access/Ownable.sol";

8: import "../interfaces/IExchangeConfig.sol";

8: import "../interfaces/IExchangeConfig.sol";

9: import "../arbitrage/ArbitrageSearch.sol";

9: import "../arbitrage/ArbitrageSearch.sol";

10: import "./interfaces/IPoolsConfig.sol";

10: import "./interfaces/IPoolsConfig.sol";

11: import "./interfaces/IPools.sol";

11: import "./interfaces/IPools.sol";

12: import "./PoolStats.sol";

13: import "./PoolMath.sol";

14: import "./PoolUtils.sol";

35: 		uint128 reserve0;						// The token reserves such that address(token0) < address(token1)

35: 		uint128 reserve0;						// The token reserves such that address(token0) < address(token1)

100: 			reserves.reserve0 += uint128(maxAmount0);

101: 			reserves.reserve1 += uint128(maxAmount1);

104: 			return ( maxAmount0, maxAmount1, (maxAmount0 + maxAmount1) );

109: 		uint256 proportionalB = ( maxAmount0 * reserve1 ) / reserve0;

109: 		uint256 proportionalB = ( maxAmount0 * reserve1 ) / reserve0;

115: 			addedAmount0 = ( maxAmount1 * reserve0 ) / reserve1;

115: 			addedAmount0 = ( maxAmount1 * reserve0 ) / reserve1;

125: 		reserves.reserve0 += uint128(addedAmount0);

126: 		reserves.reserve1 += uint128(addedAmount1);

132: 			addedLiquidity = (totalLiquidity * addedAmount0) / reserve0;

132: 			addedLiquidity = (totalLiquidity * addedAmount0) / reserve0;

134: 			addedLiquidity = (totalLiquidity * addedAmount1) / reserve1;

134: 			addedLiquidity = (totalLiquidity * addedAmount1) / reserve1;

179: 		reclaimedA = ( reserves.reserve0 * liquidityToRemove ) / totalLiquidity;

179: 		reclaimedA = ( reserves.reserve0 * liquidityToRemove ) / totalLiquidity;

180: 		reclaimedB = ( reserves.reserve1 * liquidityToRemove ) / totalLiquidity;

180: 		reclaimedB = ( reserves.reserve1 * liquidityToRemove ) / totalLiquidity;

182: 		reserves.reserve0 -= uint128(reclaimedA);

183: 		reserves.reserve1 -= uint128(reclaimedB);

209: 		_userDeposits[msg.sender][token] += amount;

224: 		_userDeposits[msg.sender][token] -= amount;

259: 			reserve1 += amountIn;

260: 			amountOut = reserve0 * amountIn / reserve1;

260: 			amountOut = reserve0 * amountIn / reserve1;

261: 			reserve0 -= amountOut;

265: 			reserve0 += amountIn;

266: 			amountOut = reserve1 * amountIn / reserve0;

266: 			amountOut = reserve1 * amountIn / reserve0;

267: 			reserve1 -= amountOut;

290: 		arbitrageProfit = amountOut - arbitrageAmountIn;

293:  		_userDeposits[address(dao)][weth] += arbitrageProfit;

311: 			return 0; // can't arbitrage as there are not enough reserves to determine swapAmountInValueInETH

311: 			return 0; // can't arbitrage as there are not enough reserves to determine swapAmountInValueInETH

313: 		swapAmountInValueInETH = ( swapAmountIn * reservesWETH ) / reservesTokenIn;

313: 		swapAmountInValueInETH = ( swapAmountIn * reservesWETH ) / reservesTokenIn;

372: 		userDeposits[swapTokenIn] -= swapAmountIn;

377: 		userDeposits[swapTokenOut] += swapAmountOut;

```

```solidity
File: src/pools/PoolsConfig.sol

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

4: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "openzeppelin-contracts/contracts/access/Ownable.sol";

6: import "./interfaces/IPoolsConfig.sol";

6: import "./interfaces/IPoolsConfig.sol";

7: import "./PoolUtils.sol";

41: 	uint256 public maximumInternalSwapPercentTimes1000 = 1000;  // Defaults to 1.0% with a 1000x multiplier

41: 	uint256 public maximumInternalSwapPercentTimes1000 = 1000;  // Defaults to 1.0% with a 1000x multiplier

82:                 maximumWhitelistedPools += 10;

87:                 maximumWhitelistedPools -= 10;

99:                 maximumInternalSwapPercentTimes1000 += 250;

104:                 maximumInternalSwapPercentTimes1000 -= 250;

```

```solidity
File: src/price_feed/CoreChainlinkFeed.sol

4: import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

4: import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

4: import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

4: import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

4: import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

5: import "./interfaces/IPriceFeed.sol";

5: import "./interfaces/IPriceFeed.sol";

34: 			uint80, // _roundID

34: 			uint80, // _roundID

36: 			uint256, // _startedAt

36: 			uint256, // _startedAt

38: 			uint80 // _answeredInRound

38: 			uint80 // _answeredInRound

43: 			uint256 answerDelay = block.timestamp - _answerTimestamp;

50: 		catch (bytes memory) // Catching any failure

50: 		catch (bytes memory) // Catching any failure

59: 		return uint256(price) * 10**10;

59: 		return uint256(price) * 10**10;

59: 		return uint256(price) * 10**10;

```

```solidity
File: src/price_feed/CoreSaltyFeed.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

5: import "../interfaces/IExchangeConfig.sol";

5: import "../interfaces/IExchangeConfig.sol";

6: import "../pools/interfaces/IPools.sol";

6: import "../pools/interfaces/IPools.sol";

6: import "../pools/interfaces/IPools.sol";

7: import "./interfaces/IPriceFeed.sol";

7: import "./interfaces/IPriceFeed.sol";

8: import "../pools/PoolUtils.sol";

8: import "../pools/PoolUtils.sol";

40: 		return ( reservesUSDS * 10**8 ) / reservesWBTC;

40: 		return ( reservesUSDS * 10**8 ) / reservesWBTC;

40: 		return ( reservesUSDS * 10**8 ) / reservesWBTC;

40: 		return ( reservesUSDS * 10**8 ) / reservesWBTC;

52: 		return ( reservesUSDS * 10**18 ) / reservesWETH;

52: 		return ( reservesUSDS * 10**18 ) / reservesWETH;

52: 		return ( reservesUSDS * 10**18 ) / reservesWETH;

52: 		return ( reservesUSDS * 10**18 ) / reservesWETH;

```

```solidity
File: src/price_feed/CoreUniswapFeed.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

5: import "v3-core/interfaces/IUniswapV3Pool.sol";

5: import "v3-core/interfaces/IUniswapV3Pool.sol";

5: import "v3-core/interfaces/IUniswapV3Pool.sol";

6: import "v3-core/libraries/FixedPoint96.sol";

6: import "v3-core/libraries/FixedPoint96.sol";

6: import "v3-core/libraries/FixedPoint96.sol";

7: import "v3-core/libraries/TickMath.sol";

7: import "v3-core/libraries/TickMath.sol";

7: import "v3-core/libraries/TickMath.sol";

8: import "v3-core/libraries/FullMath.sol";

8: import "v3-core/libraries/FullMath.sol";

8: import "v3-core/libraries/FullMath.sol";

9: import "./interfaces/IPriceFeed.sol";

9: import "./interfaces/IPriceFeed.sol";

53: 		secondsAgo[0] = uint32(twapInterval); // from (before)

53: 		secondsAgo[0] = uint32(twapInterval); // from (before)

54: 		secondsAgo[1] = 0; // to (now)

54: 		secondsAgo[1] = 0; // to (now)

59: 		int24 tick = int24((tickCumulatives[1] - tickCumulatives[0]) / int56(uint56(twapInterval)));

59: 		int24 tick = int24((tickCumulatives[1] - tickCumulatives[0]) / int56(uint56(twapInterval)));

67: 			return FullMath.mulDiv( 10 ** ( 18 + decimals1 - decimals0 ), FixedPoint96.Q96, p );

67: 			return FullMath.mulDiv( 10 ** ( 18 + decimals1 - decimals0 ), FixedPoint96.Q96, p );

67: 			return FullMath.mulDiv( 10 ** ( 18 + decimals1 - decimals0 ), FixedPoint96.Q96, p );

67: 			return FullMath.mulDiv( 10 ** ( 18 + decimals1 - decimals0 ), FixedPoint96.Q96, p );

70: 			return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / ( p * ( 10 ** ( decimals0 - decimals1 ) ) );

70: 			return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / ( p * ( 10 ** ( decimals0 - decimals1 ) ) );

70: 			return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / ( p * ( 10 ** ( decimals0 - decimals1 ) ) );

70: 			return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / ( p * ( 10 ** ( decimals0 - decimals1 ) ) );

70: 			return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / ( p * ( 10 ** ( decimals0 - decimals1 ) ) );

70: 			return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / ( p * ( 10 ** ( decimals0 - decimals1 ) ) );

70: 			return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / ( p * ( 10 ** ( decimals0 - decimals1 ) ) );

70: 			return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / ( p * ( 10 ** ( decimals0 - decimals1 ) ) );

72: 		return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / p;

72: 		return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / p;

72: 		return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / p;

72: 		return ( FixedPoint96.Q96 * ( 10 ** 18 ) ) / p;

107: 			uniswapWBTC_WETH = 10**36 / uniswapWBTC_WETH;

107: 			uniswapWBTC_WETH = 10**36 / uniswapWBTC_WETH;

107: 			uniswapWBTC_WETH = 10**36 / uniswapWBTC_WETH;

110: 			uniswapWETH_USDC = 10**36 / uniswapWETH_USDC;

110: 			uniswapWETH_USDC = 10**36 / uniswapWETH_USDC;

110: 			uniswapWETH_USDC = 10**36 / uniswapWETH_USDC;

112: 		return ( uniswapWETH_USDC * 10**18) / uniswapWBTC_WETH;

112: 		return ( uniswapWETH_USDC * 10**18) / uniswapWBTC_WETH;

112: 		return ( uniswapWETH_USDC * 10**18) / uniswapWBTC_WETH;

112: 		return ( uniswapWETH_USDC * 10**18) / uniswapWBTC_WETH;

126:         	return 10**36 / uniswapWETH_USDC;

126:         	return 10**36 / uniswapWETH_USDC;

126:         	return 10**36 / uniswapWETH_USDC;

```

```solidity
File: src/price_feed/PriceAggregator.sol

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "./interfaces/IPriceFeed.sol";

5: import "./interfaces/IPriceFeed.sol";

6: import "./interfaces/IPriceAggregator.sol";

6: import "./interfaces/IPriceAggregator.sol";

19: 	IPriceFeed public priceFeed1; // CoreUniswapFeed by default

19: 	IPriceFeed public priceFeed1; // CoreUniswapFeed by default

20: 	IPriceFeed public priceFeed2; // CoreChainlinkFeed by default

20: 	IPriceFeed public priceFeed2; // CoreChainlinkFeed by default

21: 	IPriceFeed public priceFeed3; // CoreSaltyFeed by default

21: 	IPriceFeed public priceFeed3; // CoreSaltyFeed by default

29: 	uint256 public maximumPriceFeedPercentDifferenceTimes1000 = 3000; // Defaults to 3.0% with a 1000x multiplier

29: 	uint256 public maximumPriceFeedPercentDifferenceTimes1000 = 3000; // Defaults to 3.0% with a 1000x multiplier

60: 		priceFeedModificationCooldownExpiration = block.timestamp + priceFeedModificationCooldown;

70:                 maximumPriceFeedPercentDifferenceTimes1000 += 500;

75:                 maximumPriceFeedPercentDifferenceTimes1000 -= 500;

87:                 priceFeedModificationCooldown += 5 days;

92:                 priceFeedModificationCooldown -= 5 days;

102: 			return x - y;

104: 		return y - x;

113: 			numNonZero++;

113: 			numNonZero++;

116: 			numNonZero++;

116: 			numNonZero++;

119: 			numNonZero++;

119: 			numNonZero++;

139: 		uint256 averagePrice = ( priceA + priceB ) / 2;

139: 		uint256 averagePrice = ( priceA + priceB ) / 2;

142: 		if (  (_absoluteDifference(priceA, priceB) * 100000) / averagePrice > maximumPriceFeedPercentDifferenceTimes1000 )

142: 		if (  (_absoluteDifference(priceA, priceB) * 100000) / averagePrice > maximumPriceFeedPercentDifferenceTimes1000 )

```

```solidity
File: src/rewards/Emissions.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "../rewards/interfaces/IRewardsConfig.sol";

5: import "../rewards/interfaces/IRewardsConfig.sol";

5: import "../rewards/interfaces/IRewardsConfig.sol";

6: import "../interfaces/IExchangeConfig.sol";

6: import "../interfaces/IExchangeConfig.sol";

7: import "./interfaces/IEmissions.sol";

7: import "./interfaces/IEmissions.sol";

8: import "../interfaces/ISalt.sol";

8: import "../interfaces/ISalt.sol";

55: 		uint256 saltToSend = ( saltBalance * timeSinceLastUpkeep * rewardsConfig.emissionsWeeklyPercentTimes1000() ) / ( 100 * 1000 weeks );

55: 		uint256 saltToSend = ( saltBalance * timeSinceLastUpkeep * rewardsConfig.emissionsWeeklyPercentTimes1000() ) / ( 100 * 1000 weeks );

55: 		uint256 saltToSend = ( saltBalance * timeSinceLastUpkeep * rewardsConfig.emissionsWeeklyPercentTimes1000() ) / ( 100 * 1000 weeks );

55: 		uint256 saltToSend = ( saltBalance * timeSinceLastUpkeep * rewardsConfig.emissionsWeeklyPercentTimes1000() ) / ( 100 * 1000 weeks );

```

```solidity
File: src/rewards/RewardsConfig.sol

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "./interfaces/IRewardsConfig.sol";

5: import "./interfaces/IRewardsConfig.sol";

19: 	uint256 public rewardsEmitterDailyPercentTimes1000 = 1000;  // Defaults to 1.0% with a 1000x multiplier

19: 	uint256 public rewardsEmitterDailyPercentTimes1000 = 1000;  // Defaults to 1.0% with a 1000x multiplier

23: 	uint256 public emissionsWeeklyPercentTimes1000 = 500;  // Defaults to 0.50% with a 1000x multiplier

23: 	uint256 public emissionsWeeklyPercentTimes1000 = 500;  // Defaults to 0.50% with a 1000x multiplier

41:                 rewardsEmitterDailyPercentTimes1000 = rewardsEmitterDailyPercentTimes1000 + 250;

46:                 rewardsEmitterDailyPercentTimes1000 = rewardsEmitterDailyPercentTimes1000 - 250;

57:                 emissionsWeeklyPercentTimes1000 = emissionsWeeklyPercentTimes1000 + 250;

62:                 emissionsWeeklyPercentTimes1000 = emissionsWeeklyPercentTimes1000 - 250;

74:                 stakingRewardsPercent = stakingRewardsPercent + 5;

79:                 stakingRewardsPercent = stakingRewardsPercent - 5;

91:                 percentRewardsSaltUSDS = percentRewardsSaltUSDS + 5;

96:                 percentRewardsSaltUSDS = percentRewardsSaltUSDS - 5;

```

```solidity
File: src/rewards/RewardsEmitter.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

6: import "../rewards/interfaces/IRewardsConfig.sol";

6: import "../rewards/interfaces/IRewardsConfig.sol";

6: import "../rewards/interfaces/IRewardsConfig.sol";

7: import "../pools/interfaces/IPoolsConfig.sol";

7: import "../pools/interfaces/IPoolsConfig.sol";

7: import "../pools/interfaces/IPoolsConfig.sol";

8: import "../interfaces/IExchangeConfig.sol";

8: import "../interfaces/IExchangeConfig.sol";

9: import "./interfaces/IRewardsEmitter.sol";

9: import "./interfaces/IRewardsEmitter.sol";

10: import "../interfaces/ISalt.sol";

10: import "../interfaces/ISalt.sol";

11: import "../pools/PoolUtils.sol";

11: import "../pools/PoolUtils.sol";

60: 		for( uint256 i = 0; i < addedRewards.length; i++ )

60: 		for( uint256 i = 0; i < addedRewards.length; i++ )

69: 				pendingRewards[ addedReward.poolID ] += amountToAdd;

70: 				sum += amountToAdd;

112: 		uint256 numeratorMult = timeSinceLastUpkeep * rewardsConfig.rewardsEmitterDailyPercentTimes1000();

113: 		uint256 denominatorMult = 1 days * 100000; // simplification of numberSecondsInOneDay * (100 percent) * 1000

113: 		uint256 denominatorMult = 1 days * 100000; // simplification of numberSecondsInOneDay * (100 percent) * 1000

113: 		uint256 denominatorMult = 1 days * 100000; // simplification of numberSecondsInOneDay * (100 percent) * 1000

113: 		uint256 denominatorMult = 1 days * 100000; // simplification of numberSecondsInOneDay * (100 percent) * 1000

113: 		uint256 denominatorMult = 1 days * 100000; // simplification of numberSecondsInOneDay * (100 percent) * 1000

116: 		for( uint256 i = 0; i < poolIDs.length; i++ )

116: 		for( uint256 i = 0; i < poolIDs.length; i++ )

121: 			uint256 amountToAddForPool = ( pendingRewards[poolID] * numeratorMult ) / denominatorMult;

121: 			uint256 amountToAddForPool = ( pendingRewards[poolID] * numeratorMult ) / denominatorMult;

126: 				pendingRewards[poolID] -= amountToAddForPool;

128: 				sum += amountToAddForPool;

146: 		for( uint256 i = 0; i < rewards.length; i++ )

146: 		for( uint256 i = 0; i < rewards.length; i++ )

```

```solidity
File: src/rewards/SaltRewards.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "../rewards/interfaces/IRewardsEmitter.sol";

5: import "../rewards/interfaces/IRewardsEmitter.sol";

5: import "../rewards/interfaces/IRewardsEmitter.sol";

6: import "../rewards/interfaces/IRewardsConfig.sol";

6: import "../rewards/interfaces/IRewardsConfig.sol";

6: import "../rewards/interfaces/IRewardsConfig.sol";

7: import "../interfaces/IExchangeConfig.sol";

7: import "../interfaces/IExchangeConfig.sol";

8: import "./interfaces/ISaltRewards.sol";

8: import "./interfaces/ISaltRewards.sol";

9: import "../interfaces/ISalt.sol";

9: import "../interfaces/ISalt.sol";

10: import "../pools/PoolUtils.sol";

10: import "../pools/PoolUtils.sol";

64: 		for( uint256 i = 0; i < addedRewards.length; i++ )

64: 		for( uint256 i = 0; i < addedRewards.length; i++ )

67: 			uint256 rewardsForPool = ( liquidityRewardsAmount * profitsForPools[i] ) / totalProfits;

67: 			uint256 rewardsForPool = ( liquidityRewardsAmount * profitsForPools[i] ) / totalProfits;

71: 				rewardsForPool += directRewardsForSaltUSDS;

84: 		uint256 amountPerPool = liquidityBootstrapAmount / poolIDs.length; // poolIDs.length is guaranteed to not be zero

84: 		uint256 amountPerPool = liquidityBootstrapAmount / poolIDs.length; // poolIDs.length is guaranteed to not be zero

84: 		uint256 amountPerPool = liquidityBootstrapAmount / poolIDs.length; // poolIDs.length is guaranteed to not be zero

87: 		for( uint256 i = 0; i < addedRewards.length; i++ )

87: 		for( uint256 i = 0; i < addedRewards.length; i++ )

129: 		for( uint256 i = 0; i < poolIDs.length; i++ )

129: 		for( uint256 i = 0; i < poolIDs.length; i++ )

130: 			totalProfits += profitsForPools[i];

139: 		uint256 directRewardsForSaltUSDS = ( saltRewardsToDistribute * rewardsConfig.percentRewardsSaltUSDS() ) / 100;

139: 		uint256 directRewardsForSaltUSDS = ( saltRewardsToDistribute * rewardsConfig.percentRewardsSaltUSDS() ) / 100;

140: 		uint256 remainingRewards = saltRewardsToDistribute - directRewardsForSaltUSDS;

143: 		uint256 stakingRewardsAmount = ( remainingRewards * rewardsConfig.stakingRewardsPercent() ) / 100;

143: 		uint256 stakingRewardsAmount = ( remainingRewards * rewardsConfig.stakingRewardsPercent() ) / 100;

144: 		uint256 liquidityRewardsAmount = remainingRewards - stakingRewardsAmount;

```

```solidity
File: src/stable/CollateralAndLiquidity.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

5: import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

6: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

6: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

6: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

6: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

6: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

7: import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

8: import "../price_feed/interfaces/IPriceAggregator.sol";

8: import "../price_feed/interfaces/IPriceAggregator.sol";

8: import "../price_feed/interfaces/IPriceAggregator.sol";

9: import "./interfaces/ICollateralAndLiquidity.sol";

9: import "./interfaces/ICollateralAndLiquidity.sol";

10: import "./interfaces/IStableConfig.sol";

10: import "./interfaces/IStableConfig.sol";

11: import "./interfaces/ILiquidizer.sol";

11: import "./interfaces/ILiquidizer.sol";

12: import "../staking/Liquidity.sol";

12: import "../staking/Liquidity.sol";

63: 		wbtcTenToTheDecimals = 10 ** IERC20Metadata(address(wbtc)).decimals();

63: 		wbtcTenToTheDecimals = 10 ** IERC20Metadata(address(wbtc)).decimals();

64: 		wethTenToTheDecimals = 10 ** IERC20Metadata(address(weth)).decimals();

64: 		wethTenToTheDecimals = 10 ** IERC20Metadata(address(weth)).decimals();

102: 		usdsBorrowedByUsers[msg.sender] += amountBorrowed;

122: 		usdsBorrowedByUsers[msg.sender] -= amountRepaid;

159: 		uint256 rewardedWBTC = (reclaimedWBTC * rewardPercent) / 100;

159: 		uint256 rewardedWBTC = (reclaimedWBTC * rewardPercent) / 100;

160: 		uint256 rewardedWETH = (reclaimedWETH * rewardPercent) / 100;

160: 		uint256 rewardedWETH = (reclaimedWETH * rewardPercent) / 100;

163: 		uint256 rewardValue = underlyingTokenValueInUSD( rewardedWBTC, rewardedWETH ); // in 18 decimals

163: 		uint256 rewardValue = underlyingTokenValueInUSD( rewardedWBTC, rewardedWETH ); // in 18 decimals

164: 		uint256 maxRewardValue = stableConfig.maxRewardValueForCallingLiquidation(); // 18 decimals

164: 		uint256 maxRewardValue = stableConfig.maxRewardValueForCallingLiquidation(); // 18 decimals

167: 			rewardedWBTC = (rewardedWBTC * maxRewardValue) / rewardValue;

167: 			rewardedWBTC = (rewardedWBTC * maxRewardValue) / rewardValue;

168: 			rewardedWETH = (rewardedWETH * maxRewardValue) / rewardValue;

168: 			rewardedWETH = (rewardedWETH * maxRewardValue) / rewardValue;

176: 		wbtc.safeTransfer( address(liquidizer), reclaimedWBTC - rewardedWBTC );

177: 		weth.safeTransfer( address(liquidizer), reclaimedWETH - rewardedWETH );

202: 		uint256 btcValue = ( amountBTC * btcPrice ) / wbtcTenToTheDecimals;

202: 		uint256 btcValue = ( amountBTC * btcPrice ) / wbtcTenToTheDecimals;

203: 		uint256 ethValue = ( amountETH * ethPrice ) / wethTenToTheDecimals;

203: 		uint256 ethValue = ( amountETH * ethPrice ) / wethTenToTheDecimals;

205: 		return btcValue + ethValue;

232: 		uint256 userWBTC = (reservesWBTC * userCollateralAmount ) / totalCollateralShares;

232: 		uint256 userWBTC = (reservesWBTC * userCollateralAmount ) / totalCollateralShares;

233: 		uint256 userWETH = (reservesWETH * userCollateralAmount ) / totalCollateralShares;

233: 		uint256 userWETH = (reservesWETH * userCollateralAmount ) / totalCollateralShares;

250: 		uint256 requiredCollateralValueAfterWithdrawal = ( usdsBorrowedByUsers[wallet] * stableConfig.initialCollateralRatioPercent() ) / 100;

250: 		uint256 requiredCollateralValueAfterWithdrawal = ( usdsBorrowedByUsers[wallet] * stableConfig.initialCollateralRatioPercent() ) / 100;

258: 		uint256 maxWithdrawableValue = userCollateralValue - requiredCollateralValueAfterWithdrawal;

261: 		return userCollateralAmount * maxWithdrawableValue / userCollateralValue;

261: 		return userCollateralAmount * maxWithdrawableValue / userCollateralValue;

280: 		uint256 maxBorrowableAmount = ( userCollateralValue * 100 ) / stableConfig.initialCollateralRatioPercent();

280: 		uint256 maxBorrowableAmount = ( userCollateralValue * 100 ) / stableConfig.initialCollateralRatioPercent();

286: 		return maxBorrowableAmount - usdsBorrowedByUsers[wallet];

307: 		return (( userCollateralValue * 100 ) / usdsBorrowedAmount) < stableConfig.minimumCollateralRatioPercent();

307: 		return (( userCollateralValue * 100 ) / usdsBorrowedAmount) < stableConfig.minimumCollateralRatioPercent();

313: 		address[] memory liquidatableUsers = new address[](endIndex - startIndex + 1);

313: 		address[] memory liquidatableUsers = new address[](endIndex - startIndex + 1);

321: 			for ( uint256 i = startIndex; i <= endIndex; i++ )

321: 			for ( uint256 i = startIndex; i <= endIndex; i++ )

326: 				uint256 minCollateralValue = (usdsBorrowedByUsers[wallet] * stableConfig.minimumCollateralRatioPercent()) / 100;

326: 				uint256 minCollateralValue = (usdsBorrowedByUsers[wallet] * stableConfig.minimumCollateralRatioPercent()) / 100;

329: 				uint256 minCollateral = (minCollateralValue * totalCollateralShares) / totalCollateralValue;

329: 				uint256 minCollateral = (minCollateralValue * totalCollateralShares) / totalCollateralValue;

333: 					liquidatableUsers[count++] = wallet;

333: 					liquidatableUsers[count++] = wallet;

338: 		for ( uint256 i = 0; i < count; i++ )

338: 		for ( uint256 i = 0; i < count; i++ )

350: 		return findLiquidatableUsers( 0, numberOfUsersWithBorrowedUSDS() - 1 );

```

```solidity
File: src/stable/Liquidizer.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

5: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

6: import "openzeppelin-contracts/contracts/access/Ownable.sol";

6: import "openzeppelin-contracts/contracts/access/Ownable.sol";

6: import "openzeppelin-contracts/contracts/access/Ownable.sol";

6: import "openzeppelin-contracts/contracts/access/Ownable.sol";

7: import "../stable/interfaces/ICollateralAndLiquidity.sol";

7: import "../stable/interfaces/ICollateralAndLiquidity.sol";

7: import "../stable/interfaces/ICollateralAndLiquidity.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

8: import "../pools/interfaces/IPoolsConfig.sol";

9: import "../interfaces/IExchangeConfig.sol";

9: import "../interfaces/IExchangeConfig.sol";

10: import "../pools/interfaces/IPools.sol";

10: import "../pools/interfaces/IPools.sol";

10: import "../pools/interfaces/IPools.sol";

11: import "./interfaces/ILiquidizer.sol";

11: import "./interfaces/ILiquidizer.sol";

12: import "./interfaces/IUSDS.sol";

12: import "./interfaces/IUSDS.sol";

13: import "../pools/PoolUtils.sol";

13: import "../pools/PoolUtils.sol";

85: 		usdsThatShouldBeBurned += usdsToBurn;

119: 			usdsThatShouldBeBurned -= usdsBalance;

```

```solidity
File: src/stable/StableConfig.sol

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "./interfaces/IStableConfig.sol";

5: import "./interfaces/IStableConfig.sol";

52: 			uint256 remainingRatioAfterReward = minimumCollateralRatioPercent - rewardPercentForCallingLiquidation - 1;

52: 			uint256 remainingRatioAfterReward = minimumCollateralRatioPercent - rewardPercentForCallingLiquidation - 1;

55:                 rewardPercentForCallingLiquidation += 1;

60:                 rewardPercentForCallingLiquidation -= 1;

72:                 maxRewardValueForCallingLiquidation += 100 ether;

77:                 maxRewardValueForCallingLiquidation -= 100 ether;

89:                 minimumCollateralValueForBorrowing += 500 ether;

94:                 minimumCollateralValueForBorrowing -= 500 ether;

106:                 initialCollateralRatioPercent += 25;

111:                 initialCollateralRatioPercent -= 25;

123:                 minimumCollateralRatioPercent += 1;

128: 			uint256 remainingRatioAfterReward = minimumCollateralRatioPercent - 1 - rewardPercentForCallingLiquidation;

128: 			uint256 remainingRatioAfterReward = minimumCollateralRatioPercent - 1 - rewardPercentForCallingLiquidation;

131:                 minimumCollateralRatioPercent -= 1;

143:                 percentArbitrageProfitsForStablePOL += 1;

148:                 percentArbitrageProfitsForStablePOL -= 1;

```

```solidity
File: src/stable/USDS.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

5: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "openzeppelin-contracts/contracts/access/Ownable.sol";

6: import "../stable/interfaces/ICollateralAndLiquidity.sol";

6: import "../stable/interfaces/ICollateralAndLiquidity.sol";

6: import "../stable/interfaces/ICollateralAndLiquidity.sol";

7: import "./interfaces/IUSDS.sol";

7: import "./interfaces/IUSDS.sol";

```

```solidity
File: src/staking/Liquidity.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "../pools/interfaces/IPoolsConfig.sol";

5: import "../pools/interfaces/IPoolsConfig.sol";

5: import "../pools/interfaces/IPoolsConfig.sol";

6: import "../interfaces/IExchangeConfig.sol";

6: import "../interfaces/IExchangeConfig.sol";

7: import "./interfaces/IStakingConfig.sol";

7: import "./interfaces/IStakingConfig.sol";

8: import "../pools/interfaces/IPools.sol";

8: import "../pools/interfaces/IPools.sol";

8: import "../pools/interfaces/IPools.sol";

9: import "./interfaces/ILiquidity.sol";

9: import "./interfaces/ILiquidity.sol";

10: import "./StakingRewards.sol";

11: import "../pools/PoolMath.sol";

11: import "../pools/PoolMath.sol";

12: import "../pools/PoolUtils.sol";

12: import "../pools/PoolUtils.sol";

61: 			zapAmountA -= swapAmountA;

62: 			zapAmountB += pools.depositSwapWithdraw( tokenA, tokenB, swapAmountA, 0, block.timestamp );

71: 			zapAmountB -= swapAmountB;

72: 			zapAmountA += pools.depositSwapWithdraw( tokenB, tokenA, swapAmountB, 0, block.timestamp );

111: 			tokenA.safeTransfer( msg.sender, maxAmountA - addedAmountA );

114: 			tokenB.safeTransfer( msg.sender, maxAmountB - addedAmountB );

```

```solidity
File: src/staking/Staking.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "./interfaces/IStaking.sol";

5: import "./interfaces/IStaking.sol";

6: import "../interfaces/ISalt.sol";

6: import "../interfaces/ISalt.sol";

7: import "./StakingRewards.sol";

8: import "../pools/PoolUtils.sol";

8: import "../pools/PoolUtils.sol";

65: 		uint256 completionTime = block.timestamp + numWeeks * ( 1 weeks );

65: 		uint256 completionTime = block.timestamp + numWeeks * ( 1 weeks );

67: 		unstakeID = nextUnstakeID++;

67: 		unstakeID = nextUnstakeID++;

112: 		uint256 expeditedUnstakeFee = u.unstakedXSALT - u.claimableSALT;

160:         Unstake[] memory unstakes = new Unstake[](end - start + 1);

160:         Unstake[] memory unstakes = new Unstake[](end - start + 1);

163:         for(uint256 i = start; i <= end; i++)

163:         for(uint256 i = start; i <= end; i++)

164:             unstakes[index++] = _unstakesByID[ userUnstakes[i]];

164:             unstakes[index++] = _unstakesByID[ userUnstakes[i]];

179: 		return unstakesForUser( user, 0, unstakeIDs.length - 1 );

207: 		uint256 percentAboveMinimum = 100 - minUnstakePercent;

208: 		uint256 unstakeRange = maxUnstakeWeeks - minUnstakeWeeks;

210: 		uint256 numerator = unstakedXSALT * ( minUnstakePercent * unstakeRange + percentAboveMinimum * ( numWeeks - minUnstakeWeeks ) );

210: 		uint256 numerator = unstakedXSALT * ( minUnstakePercent * unstakeRange + percentAboveMinimum * ( numWeeks - minUnstakeWeeks ) );

210: 		uint256 numerator = unstakedXSALT * ( minUnstakePercent * unstakeRange + percentAboveMinimum * ( numWeeks - minUnstakeWeeks ) );

210: 		uint256 numerator = unstakedXSALT * ( minUnstakePercent * unstakeRange + percentAboveMinimum * ( numWeeks - minUnstakeWeeks ) );

210: 		uint256 numerator = unstakedXSALT * ( minUnstakePercent * unstakeRange + percentAboveMinimum * ( numWeeks - minUnstakeWeeks ) );

211:     	return numerator / ( 100 * unstakeRange );

211:     	return numerator / ( 100 * unstakeRange );

```

```solidity
File: src/staking/StakingConfig.sol

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

4: import "openzeppelin-contracts/contracts/access/Ownable.sol";

5: import "./interfaces/IStakingConfig.sol";

5: import "./interfaces/IStakingConfig.sol";

18: 	uint256 public minUnstakeWeeks = 2;  // minUnstakePercent returned for unstaking this number of weeks

18: 	uint256 public minUnstakeWeeks = 2;  // minUnstakePercent returned for unstaking this number of weeks

39:                 minUnstakeWeeks += 1;

44:                 minUnstakeWeeks -= 1;

56:                 maxUnstakeWeeks += 8;

61:                 maxUnstakeWeeks -= 8;

73:                 minUnstakePercent += 5;

78:                 minUnstakePercent -= 5;

90:                 modificationCooldown += 15 minutes;

95:                 modificationCooldown -= 15 minutes;

```

```solidity
File: src/staking/StakingRewards.sol

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

4: import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

5: import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

6: import "openzeppelin-contracts/contracts/utils/math/Math.sol";

7: import "../pools/interfaces/IPoolsConfig.sol";

7: import "../pools/interfaces/IPoolsConfig.sol";

7: import "../pools/interfaces/IPoolsConfig.sol";

8: import "../interfaces/IExchangeConfig.sol";

8: import "../interfaces/IExchangeConfig.sol";

9: import "./interfaces/IStakingRewards.sol";

9: import "./interfaces/IStakingRewards.sol";

10: import "./interfaces/IStakingConfig.sol";

10: import "./interfaces/IStakingConfig.sol";

11: import "../interfaces/ISalt.sol";

11: import "../interfaces/ISalt.sol";

52: 		salt = _exchangeConfig.salt(); // cached for efficiency

52: 		salt = _exchangeConfig.salt(); // cached for efficiency

65: 		if ( msg.sender != address(exchangeConfig.dao()) ) // DAO doesn't use the cooldown

65: 		if ( msg.sender != address(exchangeConfig.dao()) ) // DAO doesn't use the cooldown

70: 			user.cooldownExpiration = block.timestamp + stakingConfig.modificationCooldown();

78:         if ( existingTotalShares != 0 ) // prevent / 0

78:         if ( existingTotalShares != 0 ) // prevent / 0

78:         if ( existingTotalShares != 0 ) // prevent / 0

81: 			uint256 virtualRewardsToAdd = Math.ceilDiv( totalRewards[poolID] * increaseShareAmount, existingTotalShares );

83: 			user.virtualRewards += uint128(virtualRewardsToAdd);

84: 	        totalRewards[poolID] += uint128(virtualRewardsToAdd);

88: 		user.userShare += uint128(increaseShareAmount);

89: 		totalShares[poolID] = existingTotalShares + increaseShareAmount;

105: 		if ( msg.sender != address(exchangeConfig.dao()) ) // DAO doesn't use the cooldown

105: 		if ( msg.sender != address(exchangeConfig.dao()) ) // DAO doesn't use the cooldown

110: 			user.cooldownExpiration = block.timestamp + stakingConfig.modificationCooldown();

114: 		uint256 rewardsForAmount = ( totalRewards[poolID] * decreaseShareAmount ) / totalShares[poolID];

114: 		uint256 rewardsForAmount = ( totalRewards[poolID] * decreaseShareAmount ) / totalShares[poolID];

118: 		uint256 virtualRewardsToRemove = (user.virtualRewards * decreaseShareAmount) / user.userShare;

118: 		uint256 virtualRewardsToRemove = (user.virtualRewards * decreaseShareAmount) / user.userShare;

121: 		totalRewards[poolID] -= rewardsForAmount;

122: 		totalShares[poolID] -= decreaseShareAmount;

125: 		user.userShare -= uint128(decreaseShareAmount);

126: 		user.virtualRewards -= uint128(virtualRewardsToRemove);

133: 			claimableRewards = rewardsForAmount - virtualRewardsToRemove;

152: 		for( uint256 i = 0; i < poolIDs.length; i++ )

152: 		for( uint256 i = 0; i < poolIDs.length; i++ )

159: 			userInfo[poolID].virtualRewards += uint128(pendingRewards);

161: 			claimableRewards += pendingRewards;

185: 		for( uint256 i = 0; i < addedRewards.length; i++ )

185: 		for( uint256 i = 0; i < addedRewards.length; i++ )

194: 			totalRewards[ poolID ] += amountToAdd;

195: 			sum = sum + amountToAdd;

216: 		for( uint256 i = 0; i < shares.length; i++ )

216: 		for( uint256 i = 0; i < shares.length; i++ )

226: 		for( uint256 i = 0; i < rewards.length; i++ )

226: 		for( uint256 i = 0; i < rewards.length; i++ )

243: 		uint256 rewardsShare = ( totalRewards[poolID] * user.userShare ) / totalShares[poolID];

243: 		uint256 rewardsShare = ( totalRewards[poolID] * user.userShare ) / totalShares[poolID];

251: 		return rewardsShare - user.virtualRewards;

260: 		for( uint256 i = 0; i < rewards.length; i++ )

260: 		for( uint256 i = 0; i < rewards.length; i++ )

277: 		for( uint256 i = 0; i < shares.length; i++ )

277: 		for( uint256 i = 0; i < shares.length; i++ )

296: 		for( uint256 i = 0; i < cooldowns.length; i++ )

296: 		for( uint256 i = 0; i < cooldowns.length; i++ )

303: 				cooldowns[i] = cooldownExpiration - block.timestamp;

```

### <a name="GAS-4"></a>[GAS-4] Use Custom Errors
[Source](https://blog.soliditylang.org/2021/04/21/custom-errors/)
Instead of using error strings, to reduce deployment and runtime cost, you should use Custom Errors. This would save both deployment and runtime cost.

*Instances (16)*:
```solidity
File: src/Upkeep.sol

97:     	require(msg.sender == address(this), "Only callable from within the same contract");

```

```solidity
File: src/dao/Proposals.sol

103: 		require( openBallotsByName[ string.concat(ballotName, "_confirm")] == 0, "Cannot create a proposal for a ballot with a secondary confirmation" );

251: 		require( keccak256(abi.encodePacked(newWebsiteURL)) != keccak256(abi.encodePacked("")), "newWebsiteURL cannot be empty" );

```

```solidity
File: src/launch/Airdrop.sol

60: 		require(numberAuthorized() > 0, "No addresses authorized to claim airdrop.");

```

```solidity
File: src/pools/Pools.sol

83: 		require(block.timestamp <= deadline, "TX EXPIRED");

187:         require((reserves.reserve0 >= PoolUtils.DUST) && (reserves.reserve0 >= PoolUtils.DUST), "Insufficient reserves after liquidity removal");

207:         require( amount > PoolUtils.DUST, "Deposit amount too small");

222:         require( amount > PoolUtils.DUST, "Withdraw amount too small");

243:         require((reserve0 >= PoolUtils.DUST) && (reserve1 >= PoolUtils.DUST), "Insufficient reserves before swap");

271:         require( (reserve0 >= PoolUtils.DUST) && (reserve1 >= PoolUtils.DUST), "Insufficient reserves after swap");

```

```solidity
File: src/pools/PoolsConfig.sol

48: 		require(tokenA != tokenB, "tokenA and tokenB cannot be the same token");

136: 		require(address(pair.tokenA) != address(0) && address(pair.tokenB) != address(0), "This poolID does not exist");

```

```solidity
File: src/staking/Liquidity.sol

42: 		require(block.timestamp <= deadline, "TX EXPIRED");

```

```solidity
File: src/staking/Staking.sol

153:         require(end >= start, "Invalid range: end cannot be less than start");

157:         require(userUnstakes.length > end, "Invalid range: end is out of bounds");

158:         require(start < userUnstakes.length, "Invalid range: start is out of bounds");

```

### <a name="GAS-5"></a>[GAS-5] Don't initialize variables with default value

*Instances (31)*:
```solidity
File: src/arbitrage/ArbitrageSearch.sol

115: 			for( uint256 i = 0; i < 8; i++ )

```

```solidity
File: src/dao/Proposals.sol

421: 		uint256 bestID = 0;

422: 		uint256 mostYes = 0;

423: 		for( uint256 i = 0; i < _openBallotsForTokenWhitelisting.length(); i++ )

```

```solidity
File: src/pools/PoolMath.sol

156: 		uint256 shift = 0;

```

```solidity
File: src/pools/PoolStats.sol

53: 		for( uint256 i = 0; i < poolIDs.length; i++ )

65: 		for( uint256 i = 0; i < poolIDs.length; i++ )

81: 		for( uint256 i = 0; i < poolIDs.length; i++ )

106: 		for( uint256 i = 0; i < poolIDs.length; i++ )

```

```solidity
File: src/price_feed/CoreChainlinkFeed.sol

30: 		int256 price = 0;

```

```solidity
File: src/price_feed/CoreUniswapFeed.sol

82: 		uint256 twap = 0;

```

```solidity
File: src/rewards/RewardsEmitter.sol

59: 		uint256 sum = 0;

60: 		for( uint256 i = 0; i < addedRewards.length; i++ )

115: 		uint256 sum = 0;

116: 		for( uint256 i = 0; i < poolIDs.length; i++ )

146: 		for( uint256 i = 0; i < rewards.length; i++ )

```

```solidity
File: src/rewards/SaltRewards.sol

64: 		for( uint256 i = 0; i < addedRewards.length; i++ )

87: 		for( uint256 i = 0; i < addedRewards.length; i++ )

128: 		uint256 totalProfits = 0;

129: 		for( uint256 i = 0; i < poolIDs.length; i++ )

```

```solidity
File: src/stable/CollateralAndLiquidity.sol

314: 		uint256 count = 0;

338: 		for ( uint256 i = 0; i < count; i++ )

```

```solidity
File: src/staking/StakingRewards.sol

128: 		uint256 claimableRewards = 0;

152: 		for( uint256 i = 0; i < poolIDs.length; i++ )

184: 		uint256 sum = 0;

185: 		for( uint256 i = 0; i < addedRewards.length; i++ )

216: 		for( uint256 i = 0; i < shares.length; i++ )

226: 		for( uint256 i = 0; i < rewards.length; i++ )

260: 		for( uint256 i = 0; i < rewards.length; i++ )

277: 		for( uint256 i = 0; i < shares.length; i++ )

296: 		for( uint256 i = 0; i < cooldowns.length; i++ )

```

### <a name="GAS-6"></a>[GAS-6] Long revert strings

*Instances (8)*:
```solidity
File: src/Upkeep.sol

97:     	require(msg.sender == address(this), "Only callable from within the same contract");

```

```solidity
File: src/launch/Airdrop.sol

60: 		require(numberAuthorized() > 0, "No addresses authorized to claim airdrop.");

```

```solidity
File: src/pools/Pools.sol

187:         require((reserves.reserve0 >= PoolUtils.DUST) && (reserves.reserve0 >= PoolUtils.DUST), "Insufficient reserves after liquidity removal");

243:         require((reserve0 >= PoolUtils.DUST) && (reserve1 >= PoolUtils.DUST), "Insufficient reserves before swap");

```

```solidity
File: src/pools/PoolsConfig.sol

48: 		require(tokenA != tokenB, "tokenA and tokenB cannot be the same token");

```

```solidity
File: src/staking/Staking.sol

153:         require(end >= start, "Invalid range: end cannot be less than start");

157:         require(userUnstakes.length > end, "Invalid range: end is out of bounds");

158:         require(start < userUnstakes.length, "Invalid range: start is out of bounds");

```

### <a name="GAS-7"></a>[GAS-7] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (46)*:
```solidity
File: src/ExchangeConfig.sol

48: 	function setContracts( IDAO _dao, IUpkeep _upkeep, IInitialDistribution _initialDistribution, IAirdrop _airdrop, VestingWallet _teamVestingWallet, VestingWallet _daoVestingWallet ) external onlyOwner

62: 	function setAccessManager( IAccessManager _accessManager ) external onlyOwner

```

```solidity
File: src/Upkeep.sol

105: 	function step1() public onlySameContract

112: 	function step2(address receiver) public onlySameContract

145: 	function step3() public onlySameContract

158: 	function step4() public onlySameContract

171: 	function step5() public onlySameContract

184: 	function step6() public onlySameContract

194: 	function step7() public onlySameContract

205: 	function step8() public onlySameContract

217: 	function step9() public onlySameContract

224: 	function step10() public onlySameContract

231: 	function step11() public onlySameContract

```

```solidity
File: src/dao/DAOConfig.sol

64: 	function changeBootstrappingRewards(bool increase) external onlyOwner

81: 	function changePercentPolRewardsBurned(bool increase) external onlyOwner

98: 	function changeBaseBallotQuorumPercent(bool increase) external onlyOwner

115: 	function changeBallotDuration(bool increase) external onlyOwner

132: 	function changeRequiredProposalPercentStake(bool increase) external onlyOwner

149: 	function changeMaxPendingTokensForWhitelisting(bool increase) external onlyOwner

166: 	function changeArbitrageProfitsPercentPOL(bool increase) external onlyOwner

183: 	function changeUpkeepRewardPercent(bool increase) external onlyOwner

```

```solidity
File: src/pools/Pools.sol

60: 	function setContracts( IDAO _dao, ICollateralAndLiquidity _collateralAndLiquidity ) external onlyOwner

```

```solidity
File: src/pools/PoolsConfig.sol

45: 	function whitelistPool( IPools pools, IERC20 tokenA, IERC20 tokenB ) external onlyOwner

63: 	function unwhitelistPool( IPools pools, IERC20 tokenA, IERC20 tokenB ) external onlyOwner

77: 	function changeMaximumWhitelistedPools(bool increase) external onlyOwner

94: 	function changeMaximumInternalSwapPercentTimes1000(bool increase) external onlyOwner

```

```solidity
File: src/price_feed/PriceAggregator.sol

37: 	function setInitialFeeds( IPriceFeed _priceFeed1, IPriceFeed _priceFeed2, IPriceFeed _priceFeed3 ) public onlyOwner

47: 	function setPriceFeed( uint256 priceFeedNum, IPriceFeed newPriceFeed ) public onlyOwner

65: 	function changeMaximumPriceFeedPercentDifferenceTimes1000(bool increase) public onlyOwner

82: 	function changePriceFeedModificationCooldown(bool increase) public onlyOwner

```

```solidity
File: src/rewards/RewardsConfig.sol

36: 	function changeRewardsEmitterDailyPercent(bool increase) external onlyOwner

52: 	function changeEmissionsWeeklyPercent(bool increase) external onlyOwner

69: 	function changeStakingRewardsPercent(bool increase) external onlyOwner

86: 	function changePercentRewardsSaltUSDS(bool increase) external onlyOwner

```

```solidity
File: src/stable/Liquidizer.sol

63: 	function setContracts( ICollateralAndLiquidity _collateralAndLiquidity, IPools _pools, IDAO _dao) external onlyOwner

```

```solidity
File: src/stable/StableConfig.sol

47: 	function changeRewardPercentForCallingLiquidation(bool increase) external onlyOwner

67: 	function changeMaxRewardValueForCallingLiquidation(bool increase) external onlyOwner

84: 	function changeMinimumCollateralValueForBorrowing(bool increase) external onlyOwner

101: 	function changeInitialCollateralRatioPercent(bool increase) external onlyOwner

118: 	function changeMinimumCollateralRatioPercent(bool increase) external onlyOwner

138: 	function changePercentArbitrageProfitsForStablePOL(bool increase) external onlyOwner

```

```solidity
File: src/stable/USDS.sol

29: 	function setCollateralAndLiquidity( ICollateralAndLiquidity _collateralAndLiquidity ) external onlyOwner

```

```solidity
File: src/staking/StakingConfig.sol

34: 	function changeMinUnstakeWeeks(bool increase) external onlyOwner

51: 	function changeMaxUnstakeWeeks(bool increase) external onlyOwner

68: 	function changeMinUnstakePercent(bool increase) external onlyOwner

85: 	function changeModificationCooldown(bool increase) external onlyOwner

```

### <a name="GAS-8"></a>[GAS-8] `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too)
*Saves 5 gas per loop*

*Instances (31)*:
```solidity
File: src/arbitrage/ArbitrageSearch.sol

115: 			for( uint256 i = 0; i < 8; i++ )

```

```solidity
File: src/dao/Proposals.sol

108: 		ballotID = nextBallotID++;

423: 		for( uint256 i = 0; i < _openBallotsForTokenWhitelisting.length(); i++ )

```

```solidity
File: src/launch/BootstrapBallot.sol

57: 			startExchangeYes++;

59: 			startExchangeNo++;

```

```solidity
File: src/pools/PoolStats.sol

53: 		for( uint256 i = 0; i < poolIDs.length; i++ )

65: 		for( uint256 i = 0; i < poolIDs.length; i++ )

81: 		for( uint256 i = 0; i < poolIDs.length; i++ )

106: 		for( uint256 i = 0; i < poolIDs.length; i++ )

```

```solidity
File: src/price_feed/PriceAggregator.sol

113: 			numNonZero++;

116: 			numNonZero++;

119: 			numNonZero++;

```

```solidity
File: src/rewards/RewardsEmitter.sol

60: 		for( uint256 i = 0; i < addedRewards.length; i++ )

116: 		for( uint256 i = 0; i < poolIDs.length; i++ )

146: 		for( uint256 i = 0; i < rewards.length; i++ )

```

```solidity
File: src/rewards/SaltRewards.sol

64: 		for( uint256 i = 0; i < addedRewards.length; i++ )

87: 		for( uint256 i = 0; i < addedRewards.length; i++ )

129: 		for( uint256 i = 0; i < poolIDs.length; i++ )

```

```solidity
File: src/stable/CollateralAndLiquidity.sol

321: 			for ( uint256 i = startIndex; i <= endIndex; i++ )

333: 					liquidatableUsers[count++] = wallet;

338: 		for ( uint256 i = 0; i < count; i++ )

```

```solidity
File: src/staking/Staking.sol

67: 		unstakeID = nextUnstakeID++;

163:         for(uint256 i = start; i <= end; i++)

164:             unstakes[index++] = _unstakesByID[ userUnstakes[i]];

```

```solidity
File: src/staking/StakingRewards.sol

152: 		for( uint256 i = 0; i < poolIDs.length; i++ )

185: 		for( uint256 i = 0; i < addedRewards.length; i++ )

216: 		for( uint256 i = 0; i < shares.length; i++ )

226: 		for( uint256 i = 0; i < rewards.length; i++ )

260: 		for( uint256 i = 0; i < rewards.length; i++ )

277: 		for( uint256 i = 0; i < shares.length; i++ )

296: 		for( uint256 i = 0; i < cooldowns.length; i++ )

```

### <a name="GAS-9"></a>[GAS-9] Using `private` rather than `public` for constants, saves gas
If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (11)*:
```solidity
File: src/ManagedWallet.sol

17:     uint256 constant public TIMELOCK_DURATION = 30 days;

```

```solidity
File: src/Salt.sol

12: 	uint256 public constant MILLION_ETHER = 1000000 ether;

13: 	uint256 public constant INITIAL_SUPPLY = 100 * MILLION_ETHER ;

```

```solidity
File: src/SigningTools.sol

7: 	address constant public EXPECTED_SIGNER = 0x1234519DCA2ef23207E1CA7fd70b96f281893bAa;

```

```solidity
File: src/arbitrage/ArbitrageSearch.sol

16:    	uint256 constant public MIDPOINT_PRECISION = 0.001e18; // .001 ETH precision for arb search

```

```solidity
File: src/launch/InitialDistribution.sol

19: 	uint256 constant public MILLION_ETHER = 1000000 ether;

```

```solidity
File: src/pools/PoolUtils.sol

13: 	uint256 constant public DUST = 100;

16:     bytes32 constant public STAKED_SALT = bytes32(0);

```

```solidity
File: src/price_feed/CoreUniswapFeed.sol

17:     uint256 public constant TWAP_PERIOD = 30 minutes;

```

```solidity
File: src/rewards/Emissions.sol

19:     uint256 constant public MAX_TIME_SINCE_LAST_UPKEEP = 1 weeks;

```

```solidity
File: src/rewards/RewardsEmitter.sol

31: 	uint256 constant public MAX_TIME_SINCE_LAST_UPKEEP = 1 days;

```

### <a name="GAS-10"></a>[GAS-10] Use shift Right/Left instead of division/multiplication if possible

*Instances (2)*:
```solidity
File: src/pools/PoolMath.sol

111:     x = [-B + sqrt(B^2 - 4AC)] / 2A

```

```solidity
File: src/price_feed/PriceAggregator.sol

139: 		uint256 averagePrice = ( priceA + priceB ) / 2;

```

### <a name="GAS-11"></a>[GAS-11] Splitting require() statements that use && saves gas

*Instances (5)*:
```solidity
File: src/pools/Pools.sol

187:         require((reserves.reserve0 >= PoolUtils.DUST) && (reserves.reserve0 >= PoolUtils.DUST), "Insufficient reserves after liquidity removal");

193: 		require( (reclaimedA >= minReclaimedA) && (reclaimedB >= minReclaimedB), "Insufficient underlying tokens returned" );

243:         require((reserve0 >= PoolUtils.DUST) && (reserve1 >= PoolUtils.DUST), "Insufficient reserves before swap");

271:         require( (reserve0 >= PoolUtils.DUST) && (reserve1 >= PoolUtils.DUST), "Insufficient reserves after swap");

```

```solidity
File: src/pools/PoolsConfig.sol

136: 		require(address(pair.tokenA) != address(0) && address(pair.tokenB) != address(0), "This poolID does not exist");

```

### <a name="GAS-12"></a>[GAS-12] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (34)*:
```solidity
File: src/arbitrage/ArbitrageSearch.sol

107: 			if ( reservesA0 <= PoolUtils.DUST || reservesA1 <= PoolUtils.DUST || reservesB0 <= PoolUtils.DUST || reservesB1 <= PoolUtils.DUST || reservesC0 <= PoolUtils.DUST || reservesC1 <= PoolUtils.DUST )

107: 			if ( reservesA0 <= PoolUtils.DUST || reservesA1 <= PoolUtils.DUST || reservesB0 <= PoolUtils.DUST || reservesB1 <= PoolUtils.DUST || reservesC0 <= PoolUtils.DUST || reservesC1 <= PoolUtils.DUST )

107: 			if ( reservesA0 <= PoolUtils.DUST || reservesA1 <= PoolUtils.DUST || reservesB0 <= PoolUtils.DUST || reservesB1 <= PoolUtils.DUST || reservesC0 <= PoolUtils.DUST || reservesC1 <= PoolUtils.DUST )

```

```solidity
File: src/dao/DAOConfig.sol

102: 			if (baseBallotQuorumPercentTimes1000 < 20 * 1000)

136: 			if (requiredProposalPercentStakeTimes1000 < 2000) // Maximum 2%

```

```solidity
File: src/dao/Proposals.sol

92: 			require( requiredXSalt > 0, "requiredXSalt cannot be zero" );

277: 		require( userVotingPower > 0, "Staked SALT required to vote" );

283: 		if ( lastVote.votingPower > 0 )

```

```solidity
File: src/launch/Airdrop.sol

60: 		require(numberAuthorized() > 0, "No addresses authorized to claim airdrop.");

```

```solidity
File: src/launch/BootstrapBallot.sol

36: 		require( ballotDuration > 0, "ballotDuration cannot be zero" );

```

```solidity
File: src/pools/PoolMath.sol

172:         if ( r0 < PoolUtils.DUST)

178:         if ( z0 < PoolUtils.DUST)

```

```solidity
File: src/pools/PoolStats.sol

113: 			if ( arbitrageProfit > 0 )

```

```solidity
File: src/pools/Pools.sol

173: 		require( liquidityToRemove > 0, "The amount of liquidityToRemove cannot be zero" );

340: 		if (arbitrageAmountIn > 0)

```

```solidity
File: src/pools/PoolsConfig.sol

98:             if (maximumInternalSwapPercentTimes1000 < 2000)

```

```solidity
File: src/price_feed/PriceAggregator.sol

69:             if (maximumPriceFeedPercentDifferenceTimes1000 < 7000)

112: 		if (price1 > 0)

115: 		if (price2 > 0)

118: 		if (price3 > 0)

```

```solidity
File: src/rewards/RewardsConfig.sol

40:             if (rewardsEmitterDailyPercentTimes1000 < 2500)

56:             if (emissionsWeeklyPercentTimes1000 < 1000)

```

```solidity
File: src/rewards/RewardsEmitter.sol

75: 		if ( sum > 0 )

```

```solidity
File: src/stable/CollateralAndLiquidity.sol

83: 		require( userShareForPool( msg.sender, collateralPoolID ) > 0, "User does not have any collateral" );

98: 		require( userShareForPool( msg.sender, collateralPoolID ) > 0, "User does not have any collateral" );

117: 		require( userShareForPool( msg.sender, collateralPoolID ) > 0, "User does not have any collateral" );

119: 		require( amountRepaid > 0, "Cannot repay zero amount" );

```

```solidity
File: src/stable/Liquidizer.sol

145: 		if ( saltBalance > 0 )

```

```solidity
File: src/stable/USDS.sol

43: 		require( amount > 0, "Cannot mint zero USDS" );

```

```solidity
File: src/staking/Liquidity.sol

56: 		if ( swapAmountA > 0)

66: 		else if ( swapAmountB > 0)

```

```solidity
File: src/staking/Staking.sol

115: 		if ( expeditedUnstakeFee > 0 )

```

```solidity
File: src/staking/StakingRewards.sol

164: 		if ( claimableRewards > 0 )

201: 		if ( sum > 0 )

```


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Return values of `approve()` not checked | 9 |
### <a name="NC-1"></a>[NC-1] Return values of `approve()` not checked
Not all IERC20 implementations `revert()` when there's a failure in `approve()`. The function signature has a boolean return value and they indicate errors that way instead. By not checking the return value, operations that should have marked as failed, may potentially go through without actually approving anything

*Instances (9)*:
```solidity
File: src/dao/DAO.sol

91: 		usds.approve(address(collateralAndLiquidity), type(uint256).max);

92: 		dai.approve(address(collateralAndLiquidity), type(uint256).max);

265: 			exchangeConfig.salt().approve( address(liquidityRewardsEmitter), bootstrappingRewards * 2 );

```

```solidity
File: src/rewards/SaltRewards.sol

42: 		salt.approve( address(liquidityRewardsEmitter), type(uint256).max );

```

```solidity
File: src/stable/Liquidizer.sol

72: 		weth.approve( address(pools), type(uint256).max );

73: 		dai.approve( address(pools), type(uint256).max );

```

```solidity
File: src/staking/Liquidity.sol

58: 			tokenA.approve( address(pools), swapAmountA );

68: 			tokenB.approve( address(pools), swapAmountB );

97: 		tokenB.approve( address(pools), maxAmountB );

```


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) |  `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()` | 8 |
| [L-2](#L-2) | Empty Function Body - Consider commenting why | 11 |
| [L-3](#L-3) | Unsafe ERC20 operation(s) | 16 |
| [L-4](#L-4) | Use of ecrecover is susceptible to signature malleability | 1 |
### <a name="L-1"></a>[L-1]  `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`
Use `abi.encode()` instead which will pad items to 32 bytes, which will [prevent hash collisions](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html#non-standard-packed-mode) (e.g. `abi.encodePacked(0x123,0x456)` => `0x123456` => `abi.encodePacked(0x1,0x23456)`, but `abi.encode(0x123,0x456)` => `0x0...1230...456`). "Unless there is a compelling reason, `abi.encode` should be preferred". If there is only one argument to `abi.encodePacked()` it can often be cast to `bytes()` or `bytes32()` [instead](https://ethereum.stackexchange.com/questions/30912/how-to-compare-strings-in-solidity#answer-82739).
If all arguments are strings and or bytes, `bytes.concat()` should be used instead

*Instances (8)*:
```solidity
File: src/AccessManager.sol

53: 		bytes32 messageHash = keccak256(abi.encodePacked(block.chainid, geoVersion, wallet));

```

```solidity
File: src/dao/Proposals.sol

251: 		require( keccak256(abi.encodePacked(newWebsiteURL)) != keccak256(abi.encodePacked("")), "newWebsiteURL cannot be empty" );

251: 		require( keccak256(abi.encodePacked(newWebsiteURL)) != keccak256(abi.encodePacked("")), "newWebsiteURL cannot be empty" );

```

```solidity
File: src/launch/BootstrapBallot.sol

53: 		bytes32 messageHash = keccak256(abi.encodePacked(block.chainid, msg.sender));

```

```solidity
File: src/pools/PoolUtils.sol

25:             return keccak256(abi.encodePacked(address(tokenB), address(tokenA)));

27:         return keccak256(abi.encodePacked(address(tokenA), address(tokenB)));

36:             return (keccak256(abi.encodePacked(address(tokenB), address(tokenA))), true);

38:         return (keccak256(abi.encodePacked(address(tokenA), address(tokenB))), false);

```

### <a name="L-2"></a>[L-2] Empty Function Body - Consider commenting why

*Instances (11)*:
```solidity
File: src/Upkeep.sol

247:  		try this.step1() {}

250:  		try this.step2(msg.sender) {}

253:  		try this.step3() {}

256:  		try this.step4() {}

259:  		try this.step5() {}

262:  		try this.step6() {}

265:  		try this.step7() {}

268:  		try this.step8() {}

271:  		try this.step9() {}

274:  		try this.step10() {}

277:  		try this.step11() {}

```

### <a name="L-3"></a>[L-3] Unsafe ERC20 operation(s)

*Instances (16)*:
```solidity
File: src/Upkeep.sol

91: 		weth.approve( address(pools), type(uint256).max );

```

```solidity
File: src/dao/DAO.sol

90: 		salt.approve(address(collateralAndLiquidity), type(uint256).max);

91: 		usds.approve(address(collateralAndLiquidity), type(uint256).max);

92: 		dai.approve(address(collateralAndLiquidity), type(uint256).max);

265: 			exchangeConfig.salt().approve( address(liquidityRewardsEmitter), bootstrappingRewards * 2 );

```

```solidity
File: src/launch/Airdrop.sol

67: 		salt.approve( address(staking), saltBalance );

```

```solidity
File: src/rewards/RewardsEmitter.sol

50: 		salt.approve(address(stakingRewards), type(uint256).max);

```

```solidity
File: src/rewards/SaltRewards.sol

41: 		salt.approve( address(stakingRewardsEmitter), type(uint256).max );

42: 		salt.approve( address(liquidityRewardsEmitter), type(uint256).max );

```

```solidity
File: src/stable/Liquidizer.sol

71: 		wbtc.approve( address(pools), type(uint256).max );

72: 		weth.approve( address(pools), type(uint256).max );

73: 		dai.approve( address(pools), type(uint256).max );

```

```solidity
File: src/staking/Liquidity.sol

58: 			tokenA.approve( address(pools), swapAmountA );

68: 			tokenB.approve( address(pools), swapAmountB );

96: 		tokenA.approve( address(pools), maxAmountA );

97: 		tokenB.approve( address(pools), maxAmountB );

```

### <a name="L-4"></a>[L-4] Use of ecrecover is susceptible to signature malleability
The built-in EVM precompile ecrecover is susceptible to signature malleability, which could lead to replay attacks.Consider using OpenZeppelin’s ECDSA library instead of the built-in function.

*Instances (1)*:
```solidity
File: src/SigningTools.sol

26: 		address recoveredAddress = ecrecover(messageHash, v, r, s);

```

