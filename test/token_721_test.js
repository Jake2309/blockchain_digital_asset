const TokenFactory = artifacts.require("TokenFactory");

contract("TokenFactory", (accounts) => {
    it("should deploy factory success!", async () => {
        const tokenFactoryInstance = await TokenFactory.deployed();
        // const balance = await tokenFactoryInstance.getBalance.call(accounts[0]);

        assert(tokenFactoryInstance != null, "Token Factory deploy successfully !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    });
    it("should create land 721 token success", async () => {
        const tokenFactoryInstance = await TokenFactory.deployed();
        let new721Token = await tokenFactoryInstance.deployERC721(
            "TEST LAND 721",
            "TL721",
            "https://ipfs.io/ipfs/Qmc3yp5Ui5wYHtVz3Thk532n7F8tgU9hEVReyvPfkeDsyM?filename=lfs_metadata.json",
            1
        );
        let new721LandAddress = new721Token.receipt.logs[0].args.tokenAddress;
        console.log('TOKEN ADDRESS =============================================');
        console.log(new721LandAddress);

        let newTokenName = await tokenFactoryInstance.getDeployedTokenByAddress(new721LandAddress);
        console.log(newTokenName);
        assert(newTokenName.toLowerCase() != '', 'Token name: ' + newTokenName);

        let tokenTransferred = await tokenFactoryInstance.transfer721Token(
            new721LandAddress,
            "0xca843569e3427144cead5e4d5999a3d0ccf92b8e",
            "https://ipfs.io/ipfs/Qmc3yp5Ui5wYHtVz3Thk532n7F8tgU9hEVReyvPfkeDsyM?filename=lfs_metadata.json"
        );
        console.log(tokenTransferred);
        // const setLAndInfoSuccess = await tokenFactoryInstance.setLandInfomation(
        //     new721LandAddress,
        //     "Test set land information",
        //     "https://ipfs.io/ipfs/QmUFGNsTWXiJ3p6r7Fu7CUjSctTJqpESHYL4Vh8MkRhmFf?filename=house-1836070__480.jpg",
        //     1000000000,
        //     1000
        // );

        // if (setLAndInfoSuccess) {
        //     var tokenInfo = await tokenFactoryInstance.getLandInfo(new721LandAddress);
        //     console.log('Token info =====');
        //     console.log(tokenInfo);

        //     assert(tokenInfo != null, "token set successfully!!!");
        // }
        // const metaCoinBalance = (
        //     await metaCoinInstance.getBalance.call(accounts[0])
        // ).toNumber();
        // const metaCoinEthBalance = (
        //     await metaCoinInstance.getBalanceInEth.call(accounts[0])
        // ).toNumber();

        // assert.equal(
        //     metaCoinEthBalance,
        //     2 * metaCoinBalance,
        //     "Library function returned unexpected function, linkage may be broken"
        // );
    });
    // it("should send coin correctly", async () => {
    //     const metaCoinInstance = await MetaCoin.deployed();

    //     // Setup 2 accounts.
    //     const accountOne = accounts[0];
    //     const accountTwo = accounts[1];

    //     // Get initial balances of first and second account.
    //     const accountOneStartingBalance = (
    //         await metaCoinInstance.getBalance.call(accountOne)
    //     ).toNumber();
    //     const accountTwoStartingBalance = (
    //         await metaCoinInstance.getBalance.call(accountTwo)
    //     ).toNumber();

    //     // Make transaction from first account to second.
    //     const amount = 10;
    //     await metaCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    //     // Get balances of first and second account after the transactions.
    //     const accountOneEndingBalance = (
    //         await metaCoinInstance.getBalance.call(accountOne)
    //     ).toNumber();
    //     const accountTwoEndingBalance = (
    //         await metaCoinInstance.getBalance.call(accountTwo)
    //     ).toNumber();

    //     assert.equal(
    //         accountOneEndingBalance,
    //         accountOneStartingBalance - amount,
    //         "Amount wasn't correctly taken from the sender"
    //     );
    //     assert.equal(
    //         accountTwoEndingBalance,
    //         accountTwoStartingBalance + amount,
    //         "Amount wasn't correctly sent to the receiver"
    //     );
    // });
});