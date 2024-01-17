# Salty.IO audit details
- Total Prize Pool: $80,000 USDC 
  - HM awards: $54,615 USDC
  - Analysis awards: $3,310 USDC
  - QA awards: $1,655 USDC
  - Bot Race awards: $4,965 USDC
  - Gas awards: $1,655 USDC
  - Judge awards: $8,000 USDC
  - Lookout awards: $5,300 USDC
  - Scout awards: $500 USDC
 
* Join [C4 Discord](https://discord.gg/code4rena) to register
* Submit findings [using the C4 form](https://code4rena.com/contests/2024-01-saltyio/submit)
* [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
* Starts January 16, 2024 20:00 UTC 
* Ends January 30, 2024 20:00 UTC 

# Overview
Salty.IO is a Decentralized Exchange on Ethereum which uses Automatic Atomic Arbitrage (AAA) to generate yield and provide Zero Fees on all swaps.

With AAA, market inefficiencies are arbitraged at swap time to create profits - which are then distributed to liquidity providers and stakers and used to form Protocol Owned Liquidity (POL) for the DAO.

Additionally, Salty.IO provides USDS, an overcollateralized ERC20 stablecoin native to the protocol which uses WBTC/WETH LP as collateral.

The exchange is 100% decentralized at launch - with all parameters, regional exclusions, whitelisting, and contracts controlled by the DAO itself.

Futher details about the project can be found at https://docs.salty.io

# Links
- [Documentation](https://docs.salty.io)
- [Technical Overview](https://tech.salty.io)
- [Video Technical Walkthrough](https://www.youtube.com/watch?v=bmAjm8J3q3Y)
- [Previous ABDK audit](https://github.com/abdk-consulting/audits/tree/main/othernet_global_pte_ltd)
- [Previous Trail of Bits audit](https://github.com/trailofbits/publications/blob/master/reviews/2023-10-saltyio-securityreview.pdf)
- [Twitter](https://x.com/salty_io)
- [Discord](https://discord.gg/saltyio)


# Technical Overview
The Salty.IO codebase is divided up into the following folders:

**/arbitrage** - handles searching for arbitrage opportunities at user swap time -  with the actual arbitrage swaps being done within Pools.sol itself.

**/dao** - handles creating governance proposals, voting, acting on successful proposals and managing POL (Protocol Owned Liquidity). DAO adjustable parameters are stored in ~Config.sol contracts and are stored on a per folder basis.

**/launch** - handles the initial airdrop, initial distribution, and bootstrapping ballot (a decentralized vote by the airdrop recipients to start up the DEX and distribute SALT).

**/pools** - a core part of the exchange which handles liquidity pools, swaps, arbitrage, and user token deposits (which reduces gas costs for multiple trades) and pools contribution to recent arbitrage trades (for proportional rewards distribution).

**/price_feed** - implements a redundant price aggregator (initially using Chainlink, Uniswap v3 TWAP and the Salty.IO reserves) to provide the BTC and ETH prices used by the overcollateralized stablecoin framework.

**/rewards** - handles global SALT emissions, SALT rewards (which are sent to liquidity providers and stakers), and includes a rewards emitter mechanism (which emits a percentage of rewards over time to reduce rewards volatility).

**/stable** - includes the USDS contract and collateral functionality which allows users to deposit WBTC/WETH LP as collateral, borrow USDS (which mints it when borrowed), repay USDS (which burns it) and allow users to liquidate undercollateralized positions.

**/staking** - implements a staking rewards mechanism which handles users receiving rewards proportional to some "userShare".  What the userShare actually represents is dependent on the contract that derives from StakingRewards.sol (namely Staking.sol which handles users staking SALT, and CollateralAndLiquidity.sol which handles users depositing collateral and liquidity).

**/** - includes the SALT token, the default AccessManager (which allows for DAO controlled geo-restriction) and the Upkeep contract (which contains a user callable performUpkeep() function that ensures proper functionality of ecosystem rewards, emissions, POL formation, etc).

Futher technical details about each component can be found at https://tech.salty.io


# Build / Test Instructions
forge build

**To run unit tests** \
Note - the RPC URL needs to be a Sepolia RPC (e.g. https://rpc.sepolia.org) \
`COVERAGE="yes" NETWORK="sep" forge test -vv --rpc-url http://x.x.x.x:yyy`


# Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-01-salty/blob/main/4naly3er-report.md).

Automated findings output for the audit can be found [here](https://github.com/code-423n4/2024-01-salty/blob/main/bot-report.md) within 24 hours of audit opening.

_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

* Any issue from the ABDK audit labeled as "Info" will be considered ineligible.
* Fee on transfer tokens are not supported on the exchange.
* The mechanism by which ownership is relinquished after just one call is deliberate.
* Our choice not to validate contract addresses using methods like `isContract` was deliberate.
* Custom error messages have been intentionally excluded, regardless of their potential gas savings.
* The length of our revert strings is by design, and we are not interested in gas reductions that could be achieved by shortening them.
* The absence of checks for the zero address ('0x0') in the code is an intentional gas-saving measure.
* The level of logic inlining present in the code is as intended, and there is no interest in pursuing additional inlining for runtime gas savings.
* Our abstraction of logic is at the desired level, and we are not looking to decrease bytecode size further to save on deployment gas costs.
* We have consciously chosen readability over minor gas savings that might be achieved by using Yul.
* Broadly, code alterations for minor gas optimizations that yield savings of less than 100 gas per operation are not under consideration. 

# Scope
| Contract | SLOC | Libraries used |  
| ----------- | ----------- | ----------- |
| [ArbitrageSearch.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/arbitrage/ArbitrageSearch.sol) | 72 | - |
| [DAO.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/dao/DAO.sol) | 251 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [DAOConfig.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/dao/DAOConfig.sol) | 134 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [Proposals.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/dao/Proposals.sol) | 267 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [Parameters.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/dao/Parameters.sol) | 93 | - |
| [Airdrop.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/launch/Airdrop.sol) | 56 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [BootstrapBallot.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/launch/BootstrapBallot.sol) | 50 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [InitialDistribution.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/launch/InitialDistribution.sol) | 51 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [PoolUtils.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/pools/PoolUtils.sol) | 33 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [PoolsConfig.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/pools/PoolsConfig.sol) | 96 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [PoolStats.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/pools/PoolStats.sol) | 89 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [Pools.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/pools/Pools.sol) | 229 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [PoolMath.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/pools/PoolMath.sol) | 69 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [CoreChainlinkFeed.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/price_feed/CoreChainlinkFeed.sol) | 47 | [`@chainlink`](https://docs.chain.link/data-feeds/api-reference) |
| [CoreUniswapFeed.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/price_feed/CoreUniswapFeed.sol) | 87 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/), [`@uniswapv3-core`](https://docs.uniswap.org/sdk/v3/overview) |
| [PriceAggregator.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/price_feed/PriceAggregator.sol) | 133 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [CoreSaltyFeed.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/price_feed/CoreSaltyFeed.sol) | 34 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [RewardsConfig.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/rewards/RewardsConfig.sol) | 70 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [Emissions.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/rewards/Emissions.sol) | 35 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [RewardsEmitter.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/rewards/RewardsEmitter.sol) | 89 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [SaltRewards.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/rewards/SaltRewards.sol) | 88 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [USDS.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/stable/USDS.sol) | 33 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [StableConfig.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/stable/StableConfig.sol) | 104 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [CollateralAndLiquidity.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/stable/CollateralAndLiquidity.sol) | 190 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [Liquidizer.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/stable/Liquidizer.sol) | 93 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [StakingConfig.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/staking/StakingConfig.sol) | 70 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [Liquidity.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/staking/Liquidity.sol) | 85 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [StakingRewards.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/staking/StakingRewards.sol) | 169 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [Staking.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/staking/Staking.sol) | 117 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [ManagedWallet.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/ManagedWallet.sol) | 48 | - |
| [AccessManager.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/AccessManager.sol) | 35 | - |
| [Salt.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/Salt.sol) | 16 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [SigningTools.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/SigningTools.sol) | 20 | - |
| [Upkeep.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/Upkeep.sol) | 169 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [ExchangeConfig.sol](https://github.com/code-423n4/2024-01-salty/blob/main/src/ExchangeConfig.sol) | 58 | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |

# Out of scope
[src/arbitrage/tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/arbitrage/tests ) \
[src/dao/tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/dao/tests ) \
[src/dev/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/dev ) \
[src/launch/tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/launch/tests ) \
[src/pools/tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/pools/tests ) \
[src/price_feed/tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/price_feed/tests ) \
[src/rewards/tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/rewards/tests ) \
[src/root_tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/root_tests ) \
[src/scenario_tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/scenario_tests ) \
[src/stable/tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/stable/tests ) \
[src/staking/tests/*](https://github.com/code-423n4/2024-01-salty/blob/main/src/staking/tests ) \
[lib/*](https://github.com/code-423n4/2024-01-salty/blob/main/lib)


# Additional Context
* Bisection search used to optimize arbitrage in ArbitrageSearch.sol
* Algebra used in PoolMath.sol to perform liquidity zapping.
* Initial tokens whitelisted on the exchange will be WBTC, WETH and DAI as well as the native USDS and SALT tokens.
* Salty.IO will be deployed on Ethereum mainnet.
* The only trusted role is the DAO.  There is no other ownership or priviledged role as the exchange is decentralized at launch.
* DOS exceeding 15 minutes would be valid.

# Attack ideas (Where to look for bugs)
* Areas related to the incorrect loss or theft of tokens held by any account.
* Any issue that would prevent the accurate reporting of BTC and ETH price from the PriceAggregator.
* Issues that would prevent the correct functioning of rewards distribution.
* Any issue that would prevent the DAO from functioning correctly.
* Any issue related to the USDS stablecoin, collateral and the liquidation process.
* Precision issues which could result in transactions failing or the DEX entering an undesirable state.
* Issues with performUpkeep in UpKeep.sol that would cause it to fail or enter an undesirable state.

# Scoping Summary
```
- If you have a public code repo, please share it here:  
- How many contracts are in scope?:   35
- Total SLoC for these contracts?:  3,288
- How many external imports are there?: 58 
- How many separate interfaces and struct definitions are there for the contracts within scope?:  29 interfaces , 8 structs
- Does most of your code generally use composition or inheritance?:   Composition
- How many external calls?:   96
- What is the overall line coverage percentage provided by your tests?: 99
- Is this an upgrade of an existing system?: False
- Check all that apply (e.g. timelock, NFT, AMM, ERC20, rollups, etc.): AMM, ERC-20 Token 
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?:  False
- Please describe required context:   
- Does it use an oracle?:  Chainlink
- Describe any novel or unique curve logic or mathematical models your code uses: 
- Is this either a fork of or an alternate implementation of another project?: no
- Does it use a side-chain?: no
- Describe any specific areas you would like addressed: 
```

## Miscellaneous

Employees of Salty.IO and employees' family members are ineligible to participate in this audit.
