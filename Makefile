ARG := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
$(eval $(ARG):;@true)

up:
	docker compose up


enter: 
	docker exec -it $(ARG) bash

seed: 
	docker compose run --rm web bin/rails db:seed