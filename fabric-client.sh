# export the trusted certificate before using the command
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls-ca/crypto/tls-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/tls-ca/admin
export FABRIC_CA_CLIENT_MSPDIR=msp
export FABRIC_CA_CLIENT_MSPDIR=tls-msp

#This will enroll the tls admin on port:7052
#register the peer of that organization on that port
#they are added using same ca-certificate
fabric-ca-client enroll -d -u https://tcs-admin:tsc-adminpw@0.0.0.0:7052
fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1pw --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2pw --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1pw --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2pw --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7052

#rca-org0 is added on port:7053
#an orderer and admin is added
#atrrs=* is defined as it s added as root user
fabric-ca-client enroll -d -u https://rca-org0-admin:rca-org0-adminpw@0.0.0.0:7053
fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name admin-org0 --id.secret org0adminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053


#rca-org1 is added on port:7054
#here we have also added peer along with admin and user
#no attrs are given and default are passed
fabric-ca-client enroll -d -u https://rca-org1-admin:rca-org1-adminpw@0.0.0.0:7054
fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1pw --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2pw --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name admin-org1 --id.secret org1Adminpw --id.type user -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name user-org1 --id.secret org1Userpw --id.type user -u https://0.0.0.0:7054

#rca-org2 is added on port:7054
#same as rca-org1
#use to have communication demonstration in our demo
fabric-ca-client enroll -d -u https://rca-org2-admin:rca-org2-adminpw@0.0.0.0:7055
fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1pw --id.type peer -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2pw --id.type peer -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name admin-org2 --id.secret org2Adminpw --id.type user -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name user-org2 --id.secret org2Userpw --id.type user -u https://0.0.0.0:7055

#enrolling the peer on port:7054
fabric-ca-client enroll -d -u https://peer1-org1:peer1pw@0.0.0.0:7054

#it is assume that certificate of TLS CA  has been copied  to the path given below
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/peer2

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer1/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org1:peer1pw@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-org1
#Go to path /tmp/hyperledger/org1/peer1/tls-msp/keystore and change the name of the key to key.pem

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer2/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org1:peer2pw@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-org1
#Go to path /tmp/hyperledger/org1/peer2/tls-msp/keystore and change the name of the key to key.pem.

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer2/assets/ca/org1-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org1:peer2pw@0.0.0.0:7054

export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org1:org1Adminpw@0.0.0.0:7054

#After enrollment, you should have an admin MSP
#You will copy the certificate from this MSP and
#move it to the Peer1’s MSP in the admincerts folder
#You will need to disseminate this admin certificate to other peers in the org
#and it will need to go in to the admincerts folder of each peers’ MSP.
#The command below is only for Peer1, the exchange of the admin certificate to Peer2 will happen out-of-band.
#If the admincerts folder is missing from the peer’s local MSP, the peer will fail to start up.
mkdir /tmp/hyperledger/org1/peer1/msp/admincerts
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/peer1/msp/admincerts/org1-admin-cert.pem


export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer1/assets/ca/org2-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org2:peer1pw@0.0.0.0:7055

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer1/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org2:peer1pw@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-org2
#Go to path /tmp/hyperledger/org2/peer1/tls-msp/keystore and change the name of the key to key.pem

export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer2/assets/ca/org2-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org2:peer2pw@0.0.0.0:7055


export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer2/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org2:peer2pw@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-org2
#Go to path /tmp/hyperledger/org2/peer2/tls-msp/keystore and change the name of the key to key.pem


#At this point, you will have two MSP directories
#One MSP contains your enrollment certificate and the other has your TLS certificate
#However, there needs be one additional folder added in the enrollment MSP directory
#and this is the admincerts folder. This folder will contain certificates for the administrator of Org2
#The steps below will enroll the admin
#In the commands below, we will assume that they are being executed on Peer1’s host machine.
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/peer1/assets/ca/org2-ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org2:org2Adminpw@0.0.0.0:7055

#After enrollment, you should have an admin MSP
#You will copy the certificate from this MSP and move it to the peer MSP under the admincerts folder
#The commands below are only for Peer1
#the exchange of admin cert to peer2 will happen out-of-band.
#If the admincerts folder is missing from the peer’s local MSP, the peer will fail to start up.
mkdir /tmp/hyperledger/org2/peer1/msp/admincerts
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/peer1/msp/admincerts/org2-admin-cert.pem

#You will issue the commands below to get the orderer enrolled
#In the commands below, we will assume the trusted root certificates for Org0 is available in 
#/tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererpw@0.0.0.0:7053

#Next, you will get the TLS certificate. In the command below
#we will assume the certificate of the TLS CA has been copied to
#/tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem 
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererpw@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer1-org0
#Go to path /tmp/hyperledger/org0/orderer/tls-msp/keystore and change the name of the key to key.pem

#ENROLL ORG0'S ADMIN
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer-org0-admin:ordererAdminpw@0.0.0.0:7053

#After enrollment, you should have an msp folder at /tmp/hyperledger/org0/admin
#You will copy the certificate from this MSP and move it to the orderer’s MSP under the admincerts folder.
mkdir /tmp/hyperledger/org0/orderer/msp/admincerts
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/orderer/msp/admincerts/orderer-admin-cert.pem

