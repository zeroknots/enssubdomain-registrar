// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import { ENSRegistry } from "ens-contracts/registry/ENSRegistry.sol";
import { TestRegistrar } from "ens-contracts/registry/TestRegistrar.sol";
import { BaseRegistrarImplementation } from
    "ens-contracts/ethregistrar/BaseRegistrarImplementation.sol";
import { ENSNamehash } from "../src/ENSNameHash.sol";

/// @title ENSBaseTest
/// @author zeroknots
contract ENSBaseTest is Test {
    ENSRegistry ens;
    BaseRegistrarImplementation registrar;

    TestRegistrar rsRegistrar;

    address owner;
    address resolver;

    address controller;
    bytes32 rhinestoneNode = ENSNamehash.namehash("rhinestone.eth");
    address rhinestoneOwner;

    function setUp() public {
        owner = makeAddr("owner");
        resolver = makeAddr("resolver");
        controller = makeAddr("controller");

        ens = new ENSRegistry();
        vm.warp(1641070800);
        bytes32 baseNode = ENSNamehash.namehash("eth");
        registrar = new BaseRegistrarImplementation(ens, baseNode);
        registrar.addController(controller);
        ens.setSubnodeOwner(0x0, keccak256("eth"), address(registrar));

        rhinestoneOwner = makeAddr("registrant");
        rsRegistrar = new TestRegistrar(ens, rhinestoneNode);

        vm.prank(address(controller));
        registrar.register({
            id: uint256(keccak256("rhinestone")),
            owner: address(rsRegistrar),
            duration: 80 days
        });
    }

    function testSubDomainRecord() public {
        bytes32 label = keccak256("module1");
        address module1 = makeAddr("module1");
        rsRegistrar.register(label, module1);

        address _module1 = ens.owner(ENSNamehash.namehash("module1.rhinestone.eth"));
        assertEq(_module1, module1);
    }
}
