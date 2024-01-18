build:
	docker buildx build --no-cache \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t bugfire/lego:0.7 \
		.
