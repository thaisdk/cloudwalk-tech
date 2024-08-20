# CloudWalk's Software Engineer Test

Hi, welcome to Thais's (thaisdekassia1@gmail.com) software engineer test. 

## 3.1 - Understand the Industry
 
### 3.1.1 - Explain the money flow and the information flow in the acquirer market and the role of the main players.


  ### # Money Flow

  Main players:

    cardholder > merchant > acquirer > issuer > cardholder

  The process typically works as follows:

    transaction initiation > authorization requested > analysis > response > liquidation > merchant payment

  The money flow can vary based on the country, and there may be additional or fewer steps involved.

  ### # Information Flow

    gateway > acquirer > payment network > issuer bank 


  - Gateway: Collects the payment data and initiates the transaction by sending this information to the acquirer.

  - Acquirer: Processes the transaction data and forwards it to the payment network.

  - Payment Network: Intermediary worker, routing the transaction details between the acquirer and the issuer.

  - Issuer: Verifies the cardholder's details and available funds, and sends an authorization response back through the payment network to the acquirer and merchant.

### 3.1.2 - Difference between acquirer, sub-acquirer and payment gateway and how the flow explained in question 1 changes for these players.

  ### # Payment Gateway

  The payment gateway is the first player in the transaction process. It’s responsible for securely sending transaction information to the acquirer and waiting for a response to approve or deny the transaction.

  ### # Acquirer
  The acquirer is a financial institution that processes credit and debit card transactions on behalf of merchants. They contract directly with merchants and handle the communication with the payment networks and issuers.

  ### # Sub-acquirer
  A sub-acquirer is a company that operates under the main acquirer. They facilitate transactions for merchants, often handling smaller merchants or specialized markets. Sub-acquirers rely on the main acquirer for processing and settlement.  

  ### # Flow Changes:

  As mentioned earlier, the steps can vary depending on the country and how the payment chain is structured.

- <b>With a Sub-Acquirer:</b> The sub-acquirer collects transaction details from the merchant and passes them to the main acquirer. The main acquirer then handles the communication with the payment network and issuer.

- <b>With a Payment Gateway:</b> The gateway acts as a secure channel between the merchant and the acquirer, ensuring that transaction data is transmitted safely and accurately.

## 3.2 - Get your hands dirty

1. With the rule-based validation, we have observed:

    - Many transactions with an empty device_id `(830)`.
    - More denied transactions `(1949)` than approved ones`(1250)`

  You can check the data at `GET localhost:3000/api/v1/transactions`

2. Possible fraud patterns include:

    - Transaction location anomalies
    - Suspicious merchant details.


## 3.3 - Solve the problem
### Setup

This application is made with [Docker](https://github.com/docker/awesome-compose/tree/master/official-documentation-samples/rails/). To install do the following:

1. Build your docker container with ```make build```
2. After that run the project with ```make up```
3. Open another terminal and run the project seed ```make seed```
4. If you across opon perms issues while running make seed use this command
  ```make perms```
5. You're done!

Now you can check at ```localhost:3000/api/v1/transactions```
