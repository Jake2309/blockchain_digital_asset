
const FNCToken = artifacts.require("FinoToken");
const TokenFactory = artifacts.require("TokenFactory");
const Fino1155Factory = artifacts.require("Fino1155Factory");
const Fino1155Token = artifacts.require("Fino1155Token");
const NFTMarketPlace = artifacts.require("NFTMarketPlace");
const StringUtils = artifacts.require("StringUtils");

module.exports = async function (deployer, network, accounts) {
    var defaultAccount = accounts[0];
    console.log('current account: ' + defaultAccount);
    deployer.deploy(StringUtils);
    deployer.link(StringUtils, TokenFactory);
    deployer.link(StringUtils, Fino1155Factory);

    // await deployer.deploy(FNCToken).then(() => {
    //     console.log('deploy FNCToken succeeded: ' + FNCToken.address + ' totalSupply: ' + FNCToken.totalSupply);
    // });

    // await deployer.deploy(Fino1155Token).then(async (instance) => {
    //     console.log('deploy Fino1155Token succeeded: ' + Fino1155Token.address);
    // });

    await deployer.deploy(Fino1155Factory).then(async (instance) => {
        console.log('deploy Fino1155Factory succeeded: ' + Fino1155Factory.address);

        await deployer.deploy(NFTMarketPlace, Fino1155Factory.address).then(async (instance) => {
            console.log('deploy NFTMarketPlace succeeded: ' + NFTMarketPlace.address);
        });
    });



    // await deployer.deploy(TokenFactory).then(async (instance) => {
    //     console.log('deploy TokenFactory succeeded: ' + TokenFactory.address);
    // });

    console.log('======== deployed data =================');
};
