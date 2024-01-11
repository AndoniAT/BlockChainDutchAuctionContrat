const DutchAuction = artifacts.require("DutchAuction");

contract('DutchAuction', (accounts) => {
    let enchereInstance;

    before(async () => {
        enchereInstance = await DutchAuction.deployed();
    });

    it('Doit être initialisé avec l\'adresse correcte de l\adress auctioneer', async () => {
        const auctioneer = await enchereInstance.auctioneer.call();
        assert.equal(auctioneer, accounts[0], "Le auctioneer n'est pas correctement paramétré");
    });

    it('Devrait commencer avec un prix actuel de 1 éther', async () => {
        const currentPrice = await enchereInstance.getCurrentPrice.call();
        assert.equal(currentPrice, web3.utils.toWei('1', 'ether'), "Le prix de départ n'est pas 1 éther");
    });

    it('Devrait diminuer le prix avec le temps', async () => {
      const startingPrice = await enchereInstance.getCurrentPrice.call();
      
      // Avancer le temps de 120 secondes (2 minutes)
      await new Promise((resolve, reject) => {
          web3.currentProvider.send({
              jsonrpc: "2.0",
              method: "evm_increaseTime",
              params: [120], // 120 secondes
              id: new Date().getTime()
          }, (err, result) => {
              if (err) { return reject(err); }
              return resolve(result);
          });
      });

      // Miner un nouveau bloc pour que le changement de temps prenne effet
      await new Promise((resolve, reject) => {
          web3.currentProvider.send({
              jsonrpc: '2.0',
              method: 'evm_mine',
              id: new Date().getTime()
          }, (err, result) => {
              if (err) { return reject(err); }
              return resolve(result);
          });
      });

      const newPrice = await enchereInstance.getCurrentPrice.call();
      assert.isTrue(newPrice.lt(startingPrice), "Le prix n'a pas diminué avec le temps");
  });


  it('devrait clôturer l\'enchère après une enchère valide', async () => {
    await enchereInstance.placeBid(0, { from: accounts[1], value: web3.utils.toWei('1', 'ether') }); // Placer une enchère valide
    
    // Vérifier si l'article est marqué comme fermé
    const article = await enchereInstance.articles(0);
    assert.isTrue(article.closed, "L'enchère n'est pas clôturée après une enchère valide");
  });

  it('Devrait clôturer l\'enchère après la durée de l\'enchère', async () => {
      // Avancer le temps pour dépasser la durée de l'enchère
      await advanceTime(3600); // (on suppose que la durée de l'enchère est de 3600 secondes)
      const article = await enchereInstance.articles(0); // Vérifier si l'enchère est marquée comme fermée
      assert.isTrue(article.closed, "L'enchère n'est pas clôturée après la durée de l'enchère");
  });

  // Fonction pour avancer le temps
  async function advanceTime(time) {
      await new Promise((resolve, reject) => {
          web3.currentProvider.send({
              jsonrpc: "2.0",
              method: "evm_increaseTime",
              params: [time],
              id: new Date().getTime()
          }, (err, result) => {
              if (err) { return reject(err); }
              return resolve(result);
          });
      });

      await new Promise((resolve, reject) => {
          web3.currentProvider.send({
              jsonrpc: '2.0',
              method: 'evm_mine',
              id: new Date().getTime()
          }, (err, result) => {
              if (err) { return reject(err); }
              return resolve(result);
          });
      });
  }

});
