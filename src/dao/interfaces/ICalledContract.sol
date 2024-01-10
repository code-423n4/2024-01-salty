// SPDX-License-Identifier: BUSL 1.1
pragma solidity =0.8.22;


interface ICalledContract
	{
    function callFromDAO(uint256) external;
	}