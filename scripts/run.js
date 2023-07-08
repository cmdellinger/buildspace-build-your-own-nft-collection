const { ethers } = require("hardhat");

const main = async () => {
    const nftContract = await ethers.deployContract('MyEpicNFT');
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