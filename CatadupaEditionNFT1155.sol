// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@4.9.3/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";

contract CatadupaEditionNFT1155 is ERC1155, Ownable {

    struct EditionMetaData {
        uint256 editionId;
        string metadataURI;
        uint256 timestamp;
        uint256 adminReserve;
        uint256 totalSupply;
        uint256 claimedAmount;
        bool isFrozen;
    }

    uint256 private _actualEdition = 1;

    mapping(uint256 => EditionMetaData) public editionMetaData;
    mapping(uint256 => bool) public editionMinted;

    mapping(uint256 => mapping(address => bool)) public hasClaimed;

    event EditionMinted(
        uint256 indexed editionId,
        uint256 totalSupply,
        string metadataURI
    );

    event NFTClaimed(
        address indexed user,
        uint256 indexed editionId,
        uint256 amount
    );

    event PermanentURI(
        string _value,
        uint256 indexed _id
    );

    constructor(address initialOwner) ERC1155("") {
        require(initialOwner != address(0), "Invalid owner");
        transferOwnership(initialOwner);

    }

    function mintEdition(
        uint256 totalSupply,
        string calldata metadataURI
    ) external onlyOwner {

        require(totalSupply > 0, "Amount must be greater than zero");
        require(bytes(metadataURI).length > 0, "metadata URI required");
        require(!editionMinted[_actualEdition], "Edition already minted");

        uint256 tokenId = _actualEdition;
        uint256 adminReserve = totalSupply/10;

        if (adminReserve > 0){
            _mint(msg.sender, tokenId, adminReserve, "");
        }

        editionMetaData[tokenId] = EditionMetaData({
            editionId: _actualEdition,
            metadataURI: metadataURI,
            timestamp: block.timestamp,
            adminReserve : adminReserve,
            totalSupply: totalSupply,
            claimedAmount: adminReserve,
            isFrozen: false
        });

        
        editionMinted[_actualEdition] = true;

        emit EditionMinted(tokenId, totalSupply, metadataURI);
        emit URI(metadataURI, tokenId);
    }

    function freezeMetaData(uint256 editionId) external onlyOwner {
        require(editionMinted[editionId], "Edition not created yet");
        require(!editionMetaData[editionId].isFrozen, "Already frozen");

        //Make frozen
        editionMetaData[editionId].isFrozen = true;

        emit PermanentURI(editionMetaData[editionId].metadataURI, editionId);
    }

    function mintCurrentEditionNFT() external {
        
        require(editionMinted[_actualEdition], "Edition not minted yet");
        require(!hasClaimed[_actualEdition][msg.sender], "Currently NFT already claimed.");

        EditionMetaData storage metadata = editionMetaData[_actualEdition];

        require(metadata.claimedAmount < metadata.totalSupply, "No more NFTs available for this edition");

        hasClaimed[_actualEdition][msg.sender] = true;

        metadata.claimedAmount += 1;
        
        _mint(msg.sender, _actualEdition, 1, "");

        emit NFTClaimed(msg.sender, _actualEdition, 1);
    }
    /* Method to send NFT manually to everyone*/
    function mintAdmin(address receiver, uint256 editionId, uint256 amount) external onlyOwner {
        require(editionMinted[editionId], "Edition not minted");
        require((editionMetaData[editionId].claimedAmount+amount) <= editionMetaData[editionId].totalSupply, "Total supply exceeded");

        EditionMetaData storage metadata = editionMetaData[editionId];

        hasClaimed[editionId][receiver] = true;

        metadata.claimedAmount += amount;

        _mint(receiver, editionId, amount, "");

        emit NFTClaimed(receiver, editionId, amount);

    }
    

    function nextEdition() external onlyOwner {
        require(editionMinted[_actualEdition], "Mint current edition first");
        _actualEdition++;
    }

    function actualEdition() external view returns (uint256) {
        return _actualEdition;
    }

    function setURI(uint256 editionId, string memory newuri) public onlyOwner {
        require(editionMinted[editionId], "Edition not created yet"); // Only can chage if edition already minted.
        require(!editionMetaData[editionId].isFrozen, "Metadata is frozen and cannot be changed");

        editionMetaData[editionId].metadataURI = newuri; // Update link
        emit URI(newuri, editionId); // Inform the network that the link have been changed
    }

    function uri(uint256 id) public view override returns (string memory){
        return editionMetaData[id].metadataURI;
    }
}
