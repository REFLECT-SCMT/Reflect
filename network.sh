
(cd ./backend/Scripts/ && chmod u+x * && ./create-ledger.sh && ./cc.sh)
(cd ./backend/docker && docker-compose up -d)