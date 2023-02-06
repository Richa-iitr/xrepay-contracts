// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@routerprotocol/router-crosstalk/contracts/RouterCrossTalk.sol";

interface IAavePool {
    function repay(
        address asset,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external;
}

abstract contract Helpers is RouterCrossTalk {
    address immutable owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "not-owner");
        _;
    }

    constructor(address _genericHandler, address _owner)
        RouterCrossTalk(_genericHandler)
    {
        owner = _owner;
    }

    IAavePool internal constant aavepool =
        IAavePool(0x368EedF3f56ad10b9bC57eed4Dac65B26Bb667f6);

    struct RouterLinker {
        address _rSyncContract;
        uint8 _chainID;
        address _linkedContract;
    }

    struct RepayParams {
        uint8 srcChain;
        uint8 destChain;
        bytes4 selector;
        uint256 amount;
        uint256 gaslimit;
        uint256 gasprice;
    }

    /// @notice Function Maps the two contracts on cross-chain environment
    /// @param linker Linker object to be verified
    function MapContract(RouterLinker calldata linker) external {
        iRouterCrossTalk crossTalk = iRouterCrossTalk(linker._rSyncContract);
        require(
            msg.sender == crossTalk.fetchLinkSetter(),
            "Router Generic Handler : Only Link Setter can map contracts"
        );
        crossTalk.Link{gas: 57786}(linker._chainID, linker._linkedContract);
    }

    function setFeeAddress(address _feeAddress) external onlyOwner {
        setFeeToken(_feeAddress);
    }

    function approveFee(address _feeToken, uint256 _value) external {
        approveFees(_feeToken, _value);
    }
}
