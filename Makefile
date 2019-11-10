nix-routes: ## Display the routes declared in the router in pure Nix environment
	@nix-shell --pure --run "mix phx.routes"

nix-build:  ## Build the project in a pure Nix environment
	@nix-shell --pure --run "make build"

nix-start: ## Start the web application in a pure Nix environment
	@nix-shell --pure --run "make start"

nix-reset: ## Reset the database to a clean state while in a pure Nix environment
	@nix-shell --pure --run "make reset"

nix-test: ## Run the test suite in a pure Nix environment
	@nix-shell --pure --run "mix test"

nix-bootstrap: ## Bootstrap the project's dependencies in a pure Nix environment
	@nix-shell --pure --run "make bootstrap"

routes: ## Display the routes declared in the router
	mix phx.routes

bootstrap: ## Bootstrap the project's dependencies
	mix do deps.get, ecto.setup
	cd assets && npm install

build: ## Install dependencies and build the project
	mix deps.get
	mix compile

start: ## Start the web application
	iex -S mix phx.server

reset: ## Reset the database to a clean state
	mix ecto.drop
	mix ecto.create
	mix ecto.migrate

test: ## Run the test suite
	mix test

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY := help bootstrap routes reset start build test nix-build nix-start nix-reset nix-test nix-routes nix-bootstrap

.DEFAULT_GOAL := help
