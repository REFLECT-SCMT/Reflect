#This will generate two artifacts, genesis.block and channel.tx
configtxgen -profile OrgsOrdererGenesis -outputBlock $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org0/orderer/genesis.block -channelID syschannel
configtxgen -profile OrgsChannel -outputCreateChannelTx $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org0/orderer/channel.tx -channelID mychannel
