// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // base svg template without words
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // words picked by ChatGPT when asked for 7 adjectives, animals, foods
    string[] firstWords = ["Exquisite", "Enigmatic", "Breathtaking", "Whimsical", "Savage", "Blissful", "Ethereal"];
    string[] secondWords = ["Elephant", "Penguin", "Giraffe", "Kangaroo", "Lion", "Octopus", "Koala"];
    string[] thirdWords =  ["Pizza", "Sushi", "Burger", "Pasta", "Tacos", "Salad", "Ice Cream"];


    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Finally back to building!");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }
    
    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // function to generate NFT
    function makeAnEpicNFT() public {
        // get current tokenId (starts at 0)
        uint256 newItemId = _tokenIds.current();

        // randomly get a word from each of array
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        // concatenate the svg and words together, and then close the <text> and <svg> tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // prepend data:application/json;base64, to our data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        // log svg creation
        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        //mint NFT to sender
        _safeMint(msg.sender, newItemId);

        // update URI
        _setTokenURI(newItemId, finalTokenUri);

        // increment counter for next NFT
        _tokenIds.increment();

        // log NFT mint
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}