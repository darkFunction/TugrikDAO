//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "./TugrikToken.sol";

contract TugrikDAO {
    TugrikToken public tugrikToken;

    mapping (uint256 => Proposal) private proposals;

    constructor() {
        tugrikToken = new TugrikToken();
        tugrikToken.mint(msg.sender);
    }
    
    struct Proposal {
        uint256 deadline;
        bool executed;
        address[] yesVoters;
        address[] noVoters;
    }

    modifier memberOnly() {
        require(tugrikToken.balanceOf(msg.sender) > 0);
        _;
    }

    event ProposalSubmitted(
        uint256 proposalId,
        address[] targets, 
        uint256[] values,
        bytes[] calldatas,
        string description
    );

    function submitProposal(
        address[] calldata targets, 
        uint256[] calldata values,
        bytes[] calldata calldatas,
        string calldata description
    ) 
        external 
        memberOnly 
    {
        uint256 proposalId = _hashProposal(targets, values, calldatas, keccak256(bytes(description)));

        Proposal storage proposal = proposals[proposalId];
        
        require(proposal.deadline == 0);
        
        proposal.deadline = block.timestamp + 2 minutes; // TODO: increase timeout

        emit ProposalSubmitted(
            proposalId,
            targets,
            values,
            calldatas,
            description
        );
    }

    function _hashProposal(
        address[] calldata targets, 
        uint256[] calldata values,
        bytes[] calldata calldatas,
        bytes32  descriptionHash
    ) 
        private
        pure
        returns (uint256) 
    {

        return uint256(keccak256(abi.encode(targets, values, calldatas, descriptionHash)));
    }

}
