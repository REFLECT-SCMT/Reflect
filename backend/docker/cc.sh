#With the CLI containers up and running
#you can now issue commands to create and join a channel
#We are going to use Peer1 to create the channel.
docker exec -it cli-org1 sh

while getopts cc: flag
do
    case "${$flag}" in
        cc) CHANNEL_NAME = ${OPTARG};;
    esac
done

export CHANNEL_NAME


export CORE_PEER_MSPCONFIGPATH=$GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org1/admin/msp
peer channel create -c $CHANNEL_NAME -f $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org1/peer1/assets/channel.tx -o orderer1-org0:7050 --outputBlock $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org1/peer1/assets/mychannel.block --tls --cafile $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org1/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem

export CORE_PEER_MSPCONFIGPATH=$GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org1/admin/msp
export CORE_PEER_ADDRESS=peer1-org1:7051
peer channel join -b $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org1/peer1/assets/$CHANNEL_NAME.block

export CORE_PEER_ADDRESS=peer2-org1:7051
peer channel join -b $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org1/peer1/assets/$CHANNEL_NAME.block

docker exec -it cli-org2 sh 

export CORE_PEER_MSPCONFIGPATH=$GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org2/admin/msp
export CORE_PEER_ADDRESS=peer1-org2:7051
peer channel join -b $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org2/peer1/assets/$CHANNEL_NAME.block

export CORE_PEER_ADDRESS=peer2-org2:7051
peer channel join -b $GOPATH/src/github.com/Reflect/backend/docker/hyperledger/org2/peer1/assets/$CHANNEL_NAME.block