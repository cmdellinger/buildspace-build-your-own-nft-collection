const { ethers } = require("hardhat");

const main = async () => {
    const nftContract = await ethers.deployContract('MyEpicNFT');
    await nftContract.waitForDeployment();
    console.log("Contract deployed to:", await nftContract.getAddress());
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