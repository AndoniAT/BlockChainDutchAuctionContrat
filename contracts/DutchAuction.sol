// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DutchAuction {
    address public auctioneer;
    uint public currentArticleIndex;
    uint public auctionStartTime;
    uint public constant AUCTION_DURATION = 3600; // Duration de l'enchere => 1 heure
    uint public constant STARTING_PRICE = 1 ether; // On declare le prix de debut à 1 ether
    uint public constant PRICE_DECREMENT = 0.1 ether;
    uint public constant RESERVE_PRICE = 0.2 ether;

    /** Creation d'une sctructure pour l'article
    Lequel aura un nom, un prix, un gagnant et un status pour savoir s'il est fermé  */
    struct Article { string name; uint currentPrice; address winningBidder; bool closed; }

    // Un tableau d'articles
    Article[] public articles;

    event BidPlaced(uint indexed articleIndex, address indexed bidder, uint amount);

    modifier onlyAuctioneer() {
        require(msg.sender == auctioneer, "Seul le auctioneer peut appeler cette fonction");
        _;
    }

    modifier auctionOpen() {
        require(block.timestamp >= auctionStartTime, "Les encheres n'ont pas encore commence");
        require(block.timestamp < auctionStartTime + AUCTION_DURATION, "L'enchere est terminee");
        _;
    }

    modifier articleOpen(uint articleIndex) {
        require(articleIndex < articles.length, "Index des articles invalide");
        require(!articles[articleIndex].closed, "L'article est deja ferme");
        _;
    }

    constructor() {
        auctioneer = msg.sender;
        auctionStartTime = block.timestamp;

        // Creation des articles à notre enchere
        articles.push(Article("Article 1", STARTING_PRICE, address(0), false));
        articles.push(Article("Article 2", STARTING_PRICE, address(0), false));
        currentArticleIndex = 0;
    }

    function getCurrentPrice() public view returns (uint) {
        uint elapsedTime = block.timestamp - auctionStartTime;
        uint decrements = elapsedTime / 60; // Diminue le prix toutes les 60 secondes
        uint currentPrice = STARTING_PRICE - (PRICE_DECREMENT * decrements);
        return currentPrice > RESERVE_PRICE ? currentPrice : RESERVE_PRICE;
    }

    /**
        Placer une offre 
     */
    function placeBid(uint articleIndex) external payable auctionOpen articleOpen(articleIndex) {
        require(msg.value > 0, "Le montant de l'enchere doit etre superieur a zero");

        uint currentPrice = getCurrentPrice();
        require(msg.value >= currentPrice, "Le montant de l'enchere est inferieur au prix actuel");
        //  Si la valeur est > 0 et plus que le prix actuel on etabli le gagnant et on ferme l'article
        articles[articleIndex].winningBidder = msg.sender;
        articles[articleIndex].closed = true;

        emit BidPlaced(articleIndex, msg.sender, msg.value);
    }

    function moveToNextArticle() external onlyAuctioneer {
        // Si l'index actuel est inferieux au total de notre collection, tous les articles on été vendus
        require(currentArticleIndex < articles.length - 1, "Tous les articles ont ete vendus aux encheres");

        // Si on a encore des articles on augmente l'index et on passe au suivant
        currentArticleIndex++;
        articles[currentArticleIndex].currentPrice = getCurrentPrice();
        articles[currentArticleIndex].closed = false;
    }
}
