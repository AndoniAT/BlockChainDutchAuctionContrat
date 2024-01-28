// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract DutchAuction {
    using Strings for uint256;
    uint public constant AUCTION_DURATION = 3600 seconds; // Duration de l'enchere => 1 heure
    uint public constant STARTING_PRICE = 1 ether; // On declare le prix de debut à 1 ether
    uint public constant PRICE_DECREMENT = 0.1 ether;
    uint public constant RESERVE_PRICE = 0.2 ether;
    uint public constant INTERVAL = 50 seconds;
    uint public startBlock;

    /** Creation d'une sctructure pour l'article
    Lequel aura un nom, un prix, un gagnant et un status pour savoir s'il est fermé  */
    struct Article { uint id; string name; uint currentPrice; address winningBidder; bool closed; uint bought; uint boughtFor; }
    struct Auction { uint id; string name; uint currentArticleIndex; address auctioneer; Article[] articles; uint auctionStartTime; uint startTimeCurrentAuction; }

    Auction[] public auctions;

    event Log(string message, uint value);
    event BidPlaced(uint indexed articleIndex, address indexed bidder, uint amount);

    /*modifier onlyAuctioneer() {
        require(msg.sender == auctioneer, "Seul le auctioneer peut appeler cette fonction");
        _;
    }*/

    modifier auctionOpen(uint auctionIndex) {
        require(block.timestamp >= auctions[auctionIndex].auctionStartTime, "L'enchere n'a pas encore commence");
        require(block.timestamp < auctions[auctionIndex].auctionStartTime + AUCTION_DURATION, "L'enchere est terminee");
        _;
    }

    modifier articleOpen(uint articleIndex, uint auctionIndex) {
        require(articleIndex < auctions[auctionIndex].articles.length, "Index des articles invalide");
        require(!auctions[auctionIndex].articles[articleIndex].closed, "L'article est deja ferme");
        _;
    }

    constructor() {
        startBlock = block.number;
        emit Log("CreateContract:", block.timestamp);

        // Creation de deux encheres par default
        string[] memory s = new string[](4);
        s[0] = "Article 1";
        s[1] = "Article 2";
        s[2] = "Article 3";
        s[3] = "Article 4";
        createAuction("Auction 1", s);
        
        string[] memory s2 = new string[](3);
        s2[0] = "Chemise";
        s2[1] = "PC";
        s2[2] = "Valise";
        createAuction("Auction 2", s2);
    }

    function getArticles(uint auctionIndex) public view returns (Article[] memory) {
        return auctions[auctionIndex].articles;
    }

    function getCurrentArticle(uint auctionIndex) public view returns (Article memory) {
        return auctions[auctionIndex].articles[ auctions[auctionIndex].currentArticleIndex ];
    }

    function getArticleNames(uint auctionIndex) public view returns (string[] memory) {
        string[] memory articleNames = new string[](auctions[auctionIndex].articles.length);

        for (uint i = 0; i < auctions[auctionIndex].articles.length; i++) {
            articleNames[i] = auctions[auctionIndex].articles[i].name;
        }

        return articleNames;
    }

    function getOpenArticles(uint auctionIndex) public view returns (Article[] memory) {
        uint openArticleCount = 0;

        // Compter le nombre d'articles ouverts
        for (uint i = 0; i < auctions[auctionIndex].articles.length; i++) {
            if (!auctions[auctionIndex].articles[i].closed) {
                openArticleCount++;
            }
        }

        // Créer un tableau de la taille appropriée pour les articles ouverts
        Article[] memory openArticles = new Article[](openArticleCount);

        // Remplir le tableau avec les articles ouverts
        uint index = 0;
        for (uint i = 0; i < auctions[auctionIndex].articles.length; i++) {
            if (!auctions[auctionIndex].articles[i].closed) {
                openArticles[index] = auctions[auctionIndex].articles[i];
                index++;
            }
        }

        return openArticles;
    }

    function getClosedArticles(uint auctionIndex) public view returns (Article[] memory) {
        uint closedArticleCount = 0;
        Auction memory auction = auctions[auctionIndex];
        // Compter le nombre d'articles ouverts
        for (uint i = 0; i < auction.articles.length; i++) {
            if (auction.articles[i].closed) {
                closedArticleCount++;
            }
        }

        // Créer un tableau de la taille appropriée pour les articles ouverts
        Article[] memory closedArticles = new Article[](closedArticleCount);

        // Remplir le tableau avec les articles ouverts
        uint index = 0;
        for (uint i = 0; i < auction.articles.length; i++) {
            if (auction.articles[i].closed) {
                closedArticles[index] = auction.articles[i];
                index++;
            }
        }

        return closedArticles;
    }

    function getCurrentPrice( uint auctionIndex ) public view returns (uint) {
        uint elapsedTime = getElapsedTime( auctionIndex );
        uint decrements = elapsedTime / INTERVAL; // Diminue le prix toutes les 60 secondes
        uint currentPrice = STARTING_PRICE - (PRICE_DECREMENT * decrements);
        return currentPrice > RESERVE_PRICE ? currentPrice : RESERVE_PRICE;
    }

    function getStartTime(uint auctionIndex) public view returns (uint) {
        return auctions[auctionIndex].startTimeCurrentAuction;
    }
    
    function getElapsedTime(uint auctionIndex) public view returns (uint) {
        return getTimeStamp() - auctions[auctionIndex].startTimeCurrentAuction;
    }

    function getTimeStamp() public view returns (uint) {
        uint tmp = block.timestamp;
        return tmp;
    }

    function getAuctions() public view returns (Auction[] memory) {
        return auctions;
    }

    /**
     * Obtenir l'enchere par id (index)
     */
    function getAuction(uint id) public view returns (Auction memory) {
        return auctions[id];
    }

    /**
        Placer une offre 
     */
    function placeBid(uint articleIndex, uint auctionIndex) external payable auctionOpen(auctionIndex) articleOpen(articleIndex, auctionIndex) {
    //function placeBid(uint articleIndex, uint auctionIndex) external payable {
        require(msg.value > 0, "Le montant de l'enchere doit etre superieur a zero");

        uint currentPrice = getCurrentPrice( auctionIndex );
        //require(msg.value >= currentPrice, "Le montant de l'enchere est inferieur au prix actuel");
        require(msg.value >= currentPrice, string(abi.encodePacked("Le montant de l'enchere est inferieur au prix actuel time: ", block.timestamp.toString(), ' start : ', auctions[auctionIndex].auctionStartTime.toString())));


        //  Si la valeur est > 0 et plus que le prix actuel on etabli le gagnant et on ferme l'article
        uint now_place = block.timestamp;
        
        auctions[auctionIndex].articles[articleIndex].winningBidder = msg.sender;
        auctions[auctionIndex].articles[articleIndex].closed = true;
        auctions[auctionIndex].articles[articleIndex].bought = now_place;
        auctions[auctionIndex].articles[articleIndex].boughtFor = msg.value;
        auctions[auctionIndex].currentArticleIndex++;
        require(auctions[auctionIndex].currentArticleIndex < auctions[auctionIndex].articles.length - 1, "Tous les articles ont ete vendus aux encheres");
        auctions[auctionIndex].startTimeCurrentAuction = now_place;

        emit BidPlaced(articleIndex, msg.sender, msg.value);
    }

    /**
        Creer un enchere
     */
    /*function createAuction(string memory name, string[] memory  articles ) external {
        uint id = auctions.length;
        address auctioneer = msg.sender;
        uint auctionStartTime = block.timestamp;
        uint startTimeCurrentAuction = auctionStartTime;
        Article[] storage articlesFinal = auctions[id].articles;


        for (uint i = 0; i < articles.length; i++) {
            articlesFinal.push(Article( i, articles[i], STARTING_PRICE, address(0), false, 0, 0 ether ));
        }

        auctions.push(Auction(id, name, 0, auctioneer, articlesFinal, auctionStartTime, startTimeCurrentAuction));
        emit Log("Create Auction:", auctionStartTime);
    }*/

    function createAuction(string memory name, string[] memory articles) public {
        uint id = auctions.length;
        address auctioneer = msg.sender;
        uint auctionStartTime = block.timestamp;
        uint startTimeCurrentAuction = auctionStartTime;

        // Créer une nouvelle instance d'Auction avec des valeurs par défaut
        Auction storage newAuction = auctions.push();
        newAuction.id = id;
        newAuction.name = name;
        newAuction.auctioneer = auctioneer;
        newAuction.auctionStartTime = auctionStartTime;
        newAuction.startTimeCurrentAuction = startTimeCurrentAuction;

        // Ajouter chaque élément du tableau d'articles en mémoire au tableau en stockage
        for (uint i = 1; i <= articles.length; i++) {
            newAuction.articles.push(Article( i, articles[i-1], STARTING_PRICE, address(0), false, 0, 0 ether ));
        }

        emit Log("Create Auction:", auctionStartTime);
    }

}
