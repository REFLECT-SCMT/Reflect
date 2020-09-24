while getopts c: flag
do
    case "${flag}" in
        c) channelName=${OPTARG};;
    esac
done

# Delete existing artifacts
# rm -rf ../hyperledger/crypto-config
# rm genesis.block $channelName.tx
# rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
cryptogen generate --config=../docker/crypto-config.yaml --output=../hyperledger/crypto-config/

# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "$channelName"
echo $channelName

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath ./hyperledger/genesis/ -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath ../hyperledger/genesis/ -outputCreateChannelTx ./$channelName.tx -channelID $channelName

echo "#######    Generating anchor peer update for Org1    ##########"
configtxgen -profile BasicChannel -configPath ../hyperledger/genesis/ -outputAnchorPeersUpdate ../hyperledger/transactions/Org1anchors.tx -channelID $channelName -asOrg Org1

echo "#######    Generating anchor peer update for Org2    ##########"
configtxgen -profile BasicChannel -configPath ../hyperledger/genesis/ -outputAnchorPeersUpdate ../hyperledger/transactions/Org2anchors.tx -channelID $channelName -asOrg Org2