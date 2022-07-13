// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TugrikDAO.sol";
import "../src/TugrikToken.sol";

contract TugrikDAOTest is Test {
    TugrikDAO dao;
    address nobody = address(0x1);
    address owner = address(0x2);

    function setUp() public {
        vm.prank(owner);
        dao = new TugrikDAO();
    }

    function test_whenContractDeployed_thenMintsTokenToDeployer() public {
        TugrikToken token = TugrikToken(address(dao.tugrikToken()));        
        assertEq(token.balanceOf(owner), 1);
    }

    function test_givenCallerIsNotMember_whenSubmitProposal_thenReverts() public {
        vm.prank(nobody);
        vm.expectRevert();
        dao.submitProposal(
            new address[](1),
            new uint256[](1),
            new bytes[](1),
            "test"
        );
    }
}
