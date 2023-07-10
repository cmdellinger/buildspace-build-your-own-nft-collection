const { ethers } = require("hardhat");

const main = async () => {
    const nftContractFactory = await ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy(50);
    await nftContract.waitForDeployment();
    console.log("Contract deployed to:", await nftContract.getAddress());

    // mint an NFT
    let txn = await nftContract.makeAnEpicNFT()
    // wait for mint
    await txn.wait()

    // mint another NFT
    txn = await nftContract.makeAnEpicNFT()
    // wait for mint
    await txn.wait()

    // get quantity of NFTs minted
    console.log("Quantity of NFTs minted:", await nftContract.getMintedNFTs());

    // get total number of NFTs that can be minted
    console.log("Quantity of NFTs that can be minted:", await nftContract.getMaxNFTs())
  };

  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();