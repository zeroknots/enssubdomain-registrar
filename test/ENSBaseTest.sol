// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import { ENSRegistry } from "ens-contracts/registry/ENSRegistry.sol";
import { ENSNamehash } from "../src/ENSNameHash.sol";

/// @title ENSBaseTest
/// @author zeroknots
contract ENSBaseTest is Test {
    ENSRegistry ens;

    address owner;
    address resolver;

    function setUp() public {
        ens = new ENSRegistry();

        owner = makeAddr("owner");
        resolver = makeAddr("resolver");
    }

    function testRegisterDomain() public {
        ens.setRecord(0x0, owner, resolver, 3600);
    }

    function testSubDomainRecord() public {
        ens.setSubnodeRecord(0x0, keccak256("test"), owner, resolver, 3600);

        bytes32 namehash = ENSNamehash.namehash("test");
        address _owner = ens.owner(namehash);

        assertEq(_owner, owner);
    }
}
