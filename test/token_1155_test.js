const Fino1155Factory = artifacts.require("Fino1155Factory");

var testAccounts = [
    '0xfe3b557e8fb62b89f4916b721be55ceb828dbd73',
    '0x627306090abaB3A6e1400e9345bC60c78a8BEf57',
    '0xf17f52151EbEF6C7334FAD080c5704D77216b732'];
contract("Fino1155Factory", (accounts) => {
    it("should deploy factory success!", async () => {
        const tokenFactoryInstance = await Fino1155Factory.deployed();

        assert(tokenFactoryInstance != null, "Token Factory deploy successfully !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    });
    it("should create and mint 1155 token success", async () => {
        const tokenFactoryInstance = await Fino1155Factory.deployed();

        // Deploy new 1155 token to quorum network
        let new1155Token = await tokenFactoryInstance.deployERC1155(
            "TEST LAND 1155",
            "https://ipfs.io/ipfs/Qmc3yp5Ui5wYHtVz3Thk532n7F8tgU9hEVReyvPfkeDsyM?filename=lfs_metadata.json",
            1,
            10
        );
        console.log(" ===== Token 1155 information: ===== \n");
        // console.log(new1155Token);
        console.log(JSON.stringify(new1155Token));
        // console.log('token list 1155 \n');
        // console.log(tokenFactoryInstance.listToken1155);

        let new1155LandAddress = new1155Token.receipt.logs[0].args[1];
        console.log('TOKEN ADDRESS =============================================');
        console.log(new1155LandAddress);

        let tokenAddressFromMap = await tokenFactoryInstance.getAddressById(1);
        console.log("tokenAddressFromMap: " + tokenAddressFromMap)

        let tokenTransfer = await tokenFactoryInstance.mintERC1155('0xfe3b557e8fb62b89f4916b721be55ceb828dbd73', 1, 1);

        console.log('token transfer result:');
        console.log(tokenTransfer);

        let tokenInfo = await tokenFactoryInstance.getERC1155token('0xfe3b557e8fb62b89f4916b721be55ceb828dbd73', new1155LandAddress, 1)
        console.log('===== tokenInfo =====');
        console.log(tokenInfo);
        // console.log(tokenFactoryInstance.getTokenIds(new1155LandAddress));

        // let newTokenName = await tokenFactoryInstance.getDeployedTokenByAddress(new1155LandAddress);
        // console.log(newTokenName);
        // assert(newTokenName.toLowerCase() != '', 'Token name: ' + newTokenName);

        // let tokenTransferred = await tokenFactoryInstance.transfer721Token(
        //     new721LandAddress,
        //     "0xca843569e3427144cead5e4d5999a3d0ccf92b8e",
        //     "https://ipfs.io/ipfs/Qmc3yp5Ui5wYHtVz3Thk532n7F8tgU9hEVReyvPfkeDsyM?filename=lfs_metadata.json"
        // );
        // console.log(tokenTransferred);

    });

});