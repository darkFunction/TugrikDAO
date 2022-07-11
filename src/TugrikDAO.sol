//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "./TugrikToken.sol";

contract TugrikDAO {
    TugrikToken public tugrikToken;

    // should be private?
    mapping (uint256 => Proposal) public proposals;
    uint256 public numProposals;

    constructor() {
        tugrikToken = new TugrikToken();
        tugrikToken.mint(msg.sender);
    }
    
    enum VoteType {
        YES,
        NO
    }

    struct Proposal {
        address target;
        uint256[] data;
        uint256 deadline;
        bool executed;
        mapping(address => bool) yesVoters;
        mapping(address => bool) noVoters;
    }

    modifier memberOnly() {
        require(tugrikToken.balanceOf(msg.sender) > 0);
        _;
    }

    function makeProposal(address target, uint256[] calldata data) 
        external 
        memberOnly 
        returns (uint256) {

        // OZ doesn't store this stuff, it just hashes it and uses the hash as an index
        
        Proposal storage proposal = proposals[numProposals];
        proposal.target = target;
        proposal.data = data;
        proposal.deadline = block.timestamp + 2 minutes;

        // Can just hash proposal and use that as id
        numProposals ++;

        return numProposals - 1;
    }

}
