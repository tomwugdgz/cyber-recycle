const hre = require("hardhat");

async function main() {
  console.log("🔄 开始部署赛博回收智能合约...");

  // 1. 部署 DataNFT 合约
  console.log("\n📦 部署 DataNFT 合约...");
  const DataNFT = await hre.ethers.getContractFactory("DataNFT");
  const dataNFT = await DataNFT.deploy();
  await dataNFT.waitForDeployment();
  const dataNFTAddress = await dataNFT.getAddress();
  console.log(`✅ DataNFT 已部署到: ${dataNFTAddress}`);

  // 2. 部署 A2APayment 合约
  console.log("\n💰 部署 A2APayment 合约...");
  const A2APayment = await hre.ethers.getContractFactory("A2APayment");
  const a2aPayment = await A2APayment.deploy();
  await a2aPayment.waitForDeployment();
  const a2aPaymentAddress = await a2aPayment.getAddress();
  console.log(`✅ A2APayment 已部署到: ${a2aPaymentAddress}`);

  // 3. 验证合约
  console.log("\n🔍 验证合约...");
  if (hre.network.name !== "hardhat" && hre.network.name !== "localhost") {
    await hre.run("verify:verify", {
      address: dataNFTAddress,
      contract: "contracts/DataNFT.sol:DataNFT"
    });
    await hre.run("verify:verify", {
      address: a2aPaymentAddress,
      contract: "contracts/A2APayment.sol:A2APayment"
    });
  }

  // 4. 输出部署信息
  console.log("\n" + "=".repeat(60));
  console.log("🎉 部署完成！");
  console.log("=".repeat(60));
  console.log(`网络: ${hre.network.name}`);
  console.log(`DataNFT: ${dataNFTAddress}`);
  console.log(`A2APayment: ${a2aPaymentAddress}`);
  console.log("=".repeat(60));

  // 5. 保存部署地址
  const fs = require("fs");
  const deploymentInfo = {
    network: hre.network.name,
    DataNFT: dataNFTAddress,
    A2APayment: a2aPaymentAddress,
    timestamp: new Date().toISOString()
  };
  
  fs.writeFileSync(
    "deployment-info.json",
    JSON.stringify(deploymentInfo, null, 2)
  );
  console.log("\n💾 部署信息已保存到 deployment-info.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
