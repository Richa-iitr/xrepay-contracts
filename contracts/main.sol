// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "./Helpers.sol";
import "@routerprotocol/router-crosstalk/contracts/RouterCrossTalk.sol";

contract XRepay is Helpers {
    constructor(address _genericHandler, address _owner)
        Helpers(_genericHandler, _owner)
    {}

    function xRepay(RepayParams memory params) public returns (bool) {
        // Encoding the data to send
        bytes memory data = abi.encode(params.amount);

        (bool success, ) = routerSend(
            params.destChain,
            params.selector,
            data,
            params.gaslimit,
            params.gasprice
        );

        return success;
    }

    function repay(
        uint256 value,
        uint256 ratemode,
        address onBehalf,
        address token
    ) external isSelf {
        aavepool.repay(token, value, ratemode, onBehalf);
    }

    function _routerSyncHandler(bytes4 _interface, bytes memory _data)
        internal
        virtual
        override
        returns (bool, bytes memory)
    {
        (uint256 _v, uint256 _d, address _c, address _t) = abi.decode(
            _data,
            (uint256, uint256, address, address)
        );
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSelector(_interface, _v, _d, _c, _t)
        );

        return (success, returnData);
    }
}
