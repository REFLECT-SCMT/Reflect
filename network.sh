
(cd ./backend/Scripts/ && chmod u+x * && cc.sh)
(cd ./backend/docker/ && create-ledger.sh)
(cd ./backend/docker && docker-compose up -d)