// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error MMCreativeNFTContract_MaxSupplyReached();
error MMCreativeNFTContract_ValueNotEqualPrice();
error MMCreativeNFTContract_WrongAvenueForThisTransaction();

/// @custom:security-contact uxtechnologist@gmail.com
contract MMCreativeNFTContract is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, ERC721Royalty, Ownable, ReentrancyGuard {
    uint256 private _tokenIdCounter;
    uint256 private immutable i_mint_price;
    uint256 private immutable i_max_tokens;
    string private s_base_uri;
    string private s_token_uri_holder;
    address private immutable i_owner;

    event MintingCompleted(uint toeknId, address owner);
    event FundsDistributed(address owner, uint amount);

    constructor(uint256 _mint_price, uint256 _max_tokens, string memory _base_uri, address _royaltyArtist, uint96 _royaltyBasis)
        ERC721("MMCreativeNFTContract", "MMC")
        Ownable(msg.sender)
    {
        i_mint_price = _mint_price;
        i_max_tokens = _max_tokens;
        s_base_uri = _base_uri;
        _setDefaultRoyalty(_royaltyArtist, _royaltyBasis);
        i_owner = msg.sender;
    }

    receive() external payable {
        revert MMCreativeNFTContract_WrongAvenueForThisTransaction();
    }

    fallback() external payable {
        revert MMCreativeNFTContract_WrongAvenueForThisTransaction();
    }

    function mintTo (
        string calldata uri //ipfs url string
    ) public payable nonReentrant returns (uint256) {
        uint256 tokenId = _tokenIdCounter;

        //check supply limits
        if (tokenId >= i_max_tokens) {
            revert MMCreativeNFTContract_MaxSupplyReached();
        }

        // confirm right amount of money for transaction
        if (msg.value != i_mint_price) {
            revert MMCreativeNFTContract_ValueNotEqualPrice();
        }

        _tokenIdCounter++;
        uint256 newItemId = _tokenIdCounter;
        _safeMint(msg.sender, newItemId);
        emit MintingCompleted(newItemId, msg.sender);

        s_token_uri_holder = uri;

        payable(i_owner).transfer(address(this).balance);
        emit FundsDistributed(i_owner, msg.value);

        _setTokenURI(newItemId, uri);
        return newItemId;
    }

    function getMaxSupply() public view returns (uint256) {
        return i_max_tokens;
    }

    function getMintPrice() public view returns (uint256) {
        return i_mint_price;
    }

    function getBaseURI() public view returns (string memory) {
        return s_base_uri;
    }

    function contractURI() public view returns (string memory) {
        return s_base_uri;
    }

    // called by platform to set royalty rates and artist payout address
    function setRoyalty(address _receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, feeNumerator);
    }

    function _baseURI() internal view override returns (string memory) {
        return s_base_uri;
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        _requireOwned(tokenId);
        return s_token_uri_holder;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
