// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.8.1;

library ConvertLib {
    function convert(uint amount,uint conversionRate) public pure returns (uint convertedAmount) {
        return amount * conversionRate;
    }
}
