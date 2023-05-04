const NFTMarketPlace = artifacts.require("NFTMarketPlace");
const Fino1155Factory = artifacts.require("Fino1155Factory");

var testAccounts = [
    '0x821D0CcB36E6aB34Eeb50a56fBA9421E488fD18b',
    '0xF65791AEeE3a9C9D86921A21336e602EE8b99256',
    '0x14A1fb8D59c6de5D287A0aC0F218ACb9851e66C5'];
contract("NFTMarketPlace", (accounts) => {
    it("should create and transfer 1155 token to market success", async () => {
        const tokenFactoryInstance = await Fino1155Factory.deployed();
        const marketPlaceIns = await NFTMarketPlace.deployed();
        let listingFee = await marketPlaceIns.LISTING_FEE()

        // Deploy new 1155 token to quorum network
        let new1155Token = await tokenFactoryInstance.create1155Token(
            "TEST LAND 1155",
            "https://ipfs.io/ipfs/Qmc3yp5Ui5wYHtVz3Thk532n7F8tgU9hEVReyvPfkeDsyM?filename=lfs_metadata.json",
            1,
            10,
            { from: accounts[2] }
        );
        console.log(" ===== Token 1155 information: ===== \n");
        console.log(new1155Token);
        // console.log(JSON.stringify(new1155Token));

        // let new1155TokenAddress = new1155Token.receipt.logs[0].args[1];
        let new1155TokenAddress = new1155Token.receipt.logs[1].args[1];
        console.log('TOKEN ADDRESS =============================================');
        console.log(new1155TokenAddress);

        // let tokenAddressFromMap = await tokenFactoryInstance.getAddressById(1);
        // console.log("tokenAddressFromMap: " + tokenAddressFromMap)

        // let mintTokenToMarket = await tokenFactoryInstance.mintERC1155(marketPlaceIns.address, 1, 5);

        // console.log('token transfer result:');
        // console.log(tokenTransfer);

        var tokenBalance = await tokenFactoryInstance.get1155BalanceByAddress(accounts[2], 1)
        console.log('token balance =================================')
        console.log(tokenBalance.toString())

        // var tokenIns = await marketPlaceIns.get1155Token(new1155TokenAddress);
        // console.log('tokenIns =================================')
        // console.log(tokenIns)

        // var isApproved = await tokenFactoryInstance.

        console.log('start listing token')
        console.log('nft contract address is: ' + new1155Token.logs[0].address)
        var marketListing = await marketPlaceIns.listNft(new1155Token.logs[0].address, 1, 5, 109, { from: accounts[2], value: listingFee })
        console.log('================================ list new token to market listings =================================')
        console.log(marketListing)

        var tokenListing = marketPlaceIns.getListedNfts()
        console.log('token listing')
        console.log(tokenListing)
    });
});