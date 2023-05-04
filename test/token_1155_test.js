const Fino1155Factory = artifacts.require("Fino1155Factory");

var testAccounts = [
    '0x821D0CcB36E6aB34Eeb50a56fBA9421E488fD18b',
    '0xF65791AEeE3a9C9D86921A21336e602EE8b99256',
    '0x14A1fb8D59c6de5D287A0aC0F218ACb9851e66C5'];
contract("Fino1155Factory", (accounts) => {
    it("should deploy factory success!", async () => {
        const tokenFactoryInstance = await Fino1155Factory.deployed();

        assert(tokenFactoryInstance != null, "Token Factory deploy successfully !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    });
    it("should create and mint 1155 token success", async () => {
        const tokenFactoryInstance = await Fino1155Factory.deployed();

        // Deploy new 1155 token to quorum network
        let new1155Token = await tokenFactoryInstance.create1155Token(
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

        let tokenTransfer = await tokenFactoryInstance.mintERC1155(testAccounts[0], 1, 2);

        console.log('token transfer result:');
        console.log(tokenTransfer);

        var tokenBalance = await tokenFactoryInstance.get1155BalanceByAddress(testAccounts[0], 1)
        console.log('token balance =================================')
        console.log(tokenBalance.toString())
    });
});