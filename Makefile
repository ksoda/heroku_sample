.PONY: help serve_client client run_server server database

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

serve_client: client ## Serve client
	cd client/dist && python3 -m http.server

client:
	cd client/ && npm install && env SERVICE_URL=http://localhost:3000/ npm run build

run_server: server ## Run server
	cd server-next/ && docker run --rm --net=host -e RESOURCE_SHARING_URL=http://localhost:8000/ todo

server:
	cd server-next/ && docker build -t todo .
