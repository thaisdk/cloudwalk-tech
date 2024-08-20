ARG := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
$(eval $(ARG):;@true)

build:
	docker compose build

up:
	docker compose up

enter: 
	docker exec -it $(ARG) bash

seed: 
	docker compose run --rm web ./scripts/seed.sh

perms:
	chmod +x ./scripts/seed.sh
