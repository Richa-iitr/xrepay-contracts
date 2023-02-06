import { ethers } from "hardhat";

async function main() {

  const Lock = await ethers.getContractFactory("XRepay");
  const lock = await Lock.deploy("0xDE1CC4c8a3026ad79BA6104333bED630B23210cd", "0x15C6b352c1F767Fa2d79625a40Ca4087Fab9a198");

  await lock.deployed();
  

  console.log(`Lock with 1 ETH and unlock timestamp deployed to ${lock.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
