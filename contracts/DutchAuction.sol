// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract DutchAuction {
    using Strings for uint256;
    address public auctioneer;
    uint public currentArticleIndex;
    uint public auctionStartTime;
    uint public startTimeCurrentAuction;
    uint public constant AUCTION_DURATION = 3600 seconds; // Duration de l'enchere => 1 heure
    uint public constant STARTING_PRICE = 1 ether; // On declare le prix de debut à 1 ether
    uint public constant PRICE_DECREMENT = 0.1 ether;
    uint public constant RESERVE_PRICE = 0.2 ether;
    uint public constant INTERVAL = 50 seconds;
    uint public startBlock;

    /** Creation d'une sctructure pour l'article
    Lequel aura un nom, un prix, un gagnant et un status pour savoir s'il est fermé  */
    struct Article { uint id; string name; uint currentPrice; address winningBidder; bool closed; uint bought; uint boughtFor; }

    // Un tableau d'articles
    Article[] public articles;

    event Log(string message, uint value);
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
        startBlock = block.number;
        auctioneer = msg.sender;
        auctionStartTime = block.timestamp;
        startTimeCurrentAuction = auctionStartTime;
        emit Log("CreateContract:", auctionStartTime);

        // Creation des articles à notre enchere
        articles.push(Article( 1, "Article 1", STARTING_PRICE, address(0), false, 0, 0 ether ));
        articles.push(Article( 2, "Article 2", STARTING_PRICE, address(0), false, 0, 0 ether ));
        articles.push(Article( 3, "Article 3", STARTING_PRICE, address(0), false, 0, 0 ether ));
        articles.push(Article( 4, "Article 4", STARTING_PRICE, address(0), false, 0, 0 ether ) );
        articles.push(Article( 5, "Article 5", STARTING_PRICE, address(0), false, 0, 0 ether ) );
        articles.push(Article( 6, "Article 6", STARTING_PRICE, address(0), false, 0, 0 ether ) );
        currentArticleIndex = 0;
    }

    function getArticles() public view returns (Article[] memory) {
        return articles;
    }

    function getCurrentArticle() public view returns (Article memory) {
        return articles[ currentArticleIndex ];
    }

    function getArticleNames() public view returns (string[] memory) {
        string[] memory articleNames = new string[](articles.length);

        for (uint i = 0; i < articles.length; i++) {
            articleNames[i] = articles[i].name;
        }

        return articleNames;
    }

    function getOpenArticles() public view returns (Article[] memory) {
        uint openArticleCount = 0;

        // Compter le nombre d'articles ouverts
        for (uint i = 0; i < articles.length; i++) {
            if (!articles[i].closed) {
                openArticleCount++;
            }
        }

        // Créer un tableau de la taille appropriée pour les articles ouverts
        Article[] memory openArticles = new Article[](openArticleCount);

        // Remplir le tableau avec les articles ouverts
        uint index = 0;
        for (uint i = 0; i < articles.length; i++) {
            if (!articles[i].closed) {
                openArticles[index] = articles[i];
                index++;
            }
        }

        return openArticles;
    }

    function getClosedArticles() public view returns (Article[] memory) {
        uint closedArticleCount = 0;

        // Compter le nombre d'articles ouverts
        for (uint i = 0; i < articles.length; i++) {
            if (articles[i].closed) {
                closedArticleCount++;
            }
        }

        // Créer un tableau de la taille appropriée pour les articles ouverts
        Article[] memory closedArticles = new Article[](closedArticleCount);

        // Remplir le tableau avec les articles ouverts
        uint index = 0;
        for (uint i = 0; i < articles.length; i++) {
            if (articles[i].closed) {
                closedArticles[index] = articles[i];
                index++;
            }
        }

        return closedArticles;
    }

    function getCurrentPrice() public view returns (uint) {
        uint elapsedTime = getElapsedTime();
        uint decrements = elapsedTime / INTERVAL; // Diminue le prix toutes les 60 secondes
        uint currentPrice = STARTING_PRICE - (PRICE_DECREMENT * decrements);
        return currentPrice > RESERVE_PRICE ? currentPrice : RESERVE_PRICE;
    }

    function getStartTime() public view returns (uint) {
        return startTimeCurrentAuction;
    }
    
    function getElapsedTime() public view returns (uint) {
        return getTimeStamp() - startTimeCurrentAuction;
    }

    function getTimeStamp() public view returns (uint) {
        uint tmp = block.timestamp;
        return tmp;
    }


    function moveToNextArticle() external onlyAuctioneer {
        // Si l'index actuel est inferieur au total de notre collection, tous les articles on été vendus
        require(currentArticleIndex < articles.length - 1, "Tous les articles ont ete vendus aux encheres");

        // Si on a encore des articles on augmente l'index et on passe au suivant
        currentArticleIndex++;
        articles[currentArticleIndex].currentPrice = getCurrentPrice();
        articles[currentArticleIndex].closed = false;
    }

    /**
        Placer une offre 
     */
    function placeBid(uint articleIndex) external payable auctionOpen articleOpen(articleIndex) {
        require(msg.value > 0, "Le montant de l'enchere doit etre superieur a zero");

        uint currentPrice = getCurrentPrice();
        //require(msg.value >= currentPrice, "Le montant de l'enchere est inferieur au prix actuel");
        require(msg.value >= currentPrice, string(abi.encodePacked("Le montant de l'enchere est inferieur au prix actuel time: ", block.timestamp.toString(), ' start : ', auctionStartTime.toString())));


        //  Si la valeur est > 0 et plus que le prix actuel on etabli le gagnant et on ferme l'article
        uint now_place = block.timestamp;
        
        articles[articleIndex].winningBidder = msg.sender;
        articles[articleIndex].closed = true;
        articles[articleIndex].bought = now_place;
        articles[articleIndex].boughtFor = msg.value;
        currentArticleIndex++;
        require(currentArticleIndex < articles.length - 1, "Tous les articles ont ete vendus aux encheres");
        startTimeCurrentAuction = now_place;
        //articles[currentArticleIndex].currentPrice = getCurrentPrice();
        //articles[currentArticleIndex].closed = false;

        emit BidPlaced(articleIndex, msg.sender, msg.value);
    }
}
