## Mining
For the mining code of the blockchain.

## How to use  

### For Ritual Mining
1. The node installation command is as follows::  
    `wget -O ritual_install.sh https://raw.githubusercontent.com/xiaoliwe/mining/main/Ritual/install.sh && chmod +x ritual_install.sh && ./ritual_install.sh`   
    to initial the mining environment.  
2. You need to set-up the API Keys with [ZAN.TOP](https://zan.top) to get BASE's HTTPS link.  
   

### For EthStorage Mining
1. The node installation command is as follows::  
   `wget -O ethstorage_install.sh https://raw.githubusercontent.com/xiaoliwe/mining/main/EthStorage/install.sh && chmod +x ethstorage_install.sh && ./ethstorage_install.sh`  
    to initial the mining environment  

2. The official docs is here: https://docs.ethstorage.io/storage-provider-guide/tutorials  
3. You need to have a account of [BlockPI](https://dashboard.blockpi.io) to get RPC's address and [QuickNode](https://dashboard.quicknode.com/) to get the Sepolia's endpoint address. 

#### how to check the running state?
- You need to run `docker logs -f es` in the terminal.  
