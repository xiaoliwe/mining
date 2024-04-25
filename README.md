## Mining
For the mining code of the blockchain.

## How to use  
All the mining's scripts used for the Ubuntu 22.x linux distribution. if you want to use CentOS instead, please replace the command line with `yum` instead of `apt-get`  .  

### For Ritual Mining
1. The node installation command is as follows::  
    `wget -O ritual_install.sh https://raw.githubusercontent.com/xiaoliwe/mining/main/Ritual/install.sh && chmod +x ritual_install.sh && ./ritual_install.sh`   
    to initial the mining environment.  
2. You need to set-up the API Keys with [ZAN.TOP](https://zan.top) or [Alchemy](https://dashboard.alchemy.com/) to get BASE's HTTPS link.  
3. As bellow commands will be helpful for you  
   - `docker compose up`  To start container.  
   - `docker compose down` To stop container.  

### For EthStorage Mining
1. The node installation command is as follows::  
   `wget -O ethstorage_install.sh https://raw.githubusercontent.com/xiaoliwe/mining/main/EthStorage/install.sh && chmod +x ethstorage_install.sh && ./ethstorage_install.sh`  
    to initial the mining environment  

2. The official docs is here: https://docs.ethstorage.io/storage-provider-guide/tutorials  
3. You need to have a account of [BlockPI](https://dashboard.blockpi.io) to get RPC's address and [QuickNode](https://dashboard.quicknode.com/) to get the Sepolia's endpoint address. 

#### how to check the running state?
- You need to run `docker logs -f es` in the terminal.  

### For Docker's environment
1. The docker installation command is as follows  
   `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xiaoliwe/mining/main/Docker/install.sh)"`   
   or  
1. If you're in China region, please use this:  
   1. `curl -fsSL https://raw.gitmirror.com/xiaoliwe/mining/main/Docker/install.sh | sudo bash`   
   

### For TitanNetwork Mining  
1. The node installation commands is as below:  
   `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xiaoliwe/mining/main/TitanNetwork/install.sh)"`     
2. The Identity code link is here: [Get Identity Code](https://test1.titannet.io/newoverview/activationcodemanagement)  

