# while getopts c: flag
# do
#     case "${flag}" in
#         c) channelName=${OPTARG};;
#     esac
# done
channelName="newChannel"
# Delete existing artifacts
rm -rf ../hyperledger/crypto-config/*
# rm genesis.block $channelName.tx


#Generate Crypto artifactes for organizations
cryptogen generate --config=crypto-config.yml --output=../hyperledger/crypto-config/

# # System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "$channelName"
echo "---------------------"
echo "connecting " $channelName
echo "---------------------"

export FABRIC_CFG_PATH=$GOPATH/src/github.com/Reflect/backend/docker/

##########################
#Errors for comands below
#Try to debug the issue
#and uncomment the single commented lines
###########################

# # Generate System Genesis block
# configtxgen -profile OrdererGenesis -configPath . -outputBlock ./genesis.block -channelID $SYS_CHANNEL

# # Generate channel configuration block
# configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./$channelName.tx -channelID $channelName

# echo "#######    Generating anchor peer update for Org1    ##########"
# configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ../hyperledger/transactions/Org1anchors.tx -channelID $channelName -asOrg Org1

# echo "#######    Generating anchor peer update for Org2    ##########"
# configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ../hyperledger/transactions/Org2anchors.tx -channelID $channelName -asOrg Org2