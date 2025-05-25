// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AgriMarketplace {
    struct Product {
        uint id;
        string name;
        string location;
        uint price;
        address payable seller;
        address buyer;
        bool purchased;
    }

    uint public productCount = 0;
    mapping(uint => Product) public products;

    event ProductCreated(
        uint id,
        string name,
        string location,
        uint price,
        address seller
    );

    event ProductPurchased(
        uint id,
        address buyer
    );

    function createProduct(string memory _name, string memory _location, uint _price) public {
        require(bytes(_name).length > 0, "Product name required");
        require(_price > 0, "Price must be greater than 0");

        productCount++;
        products[productCount] = Product(productCount, _name, _location, _price, payable(msg.sender), address(0), false);

        emit ProductCreated(productCount, _name, _location, _price, msg.sender);
    }

    function purchaseProduct(uint _id) public payable {
        Product storage product = products[_id];
        require(_id > 0 && _id <= productCount, "Invalid ID");
        require(msg.value >= product.price, "Insufficient payment");
        require(!product.purchased, "Already purchased");
        require(product.seller != msg.sender, "Seller can't buy own product");

        product.buyer = msg.sender;
        product.purchased = true;
        product.seller.transfer(msg.value);

        emit ProductPurchased(_id, msg.sender);
    }
}
