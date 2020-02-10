
#
make

docker run -ti --rm --name kong-go-plugins \
  -e "KONG_DATABASE=off" \
  -e "KONG_GO_PLUGINS_DIR=/tmp/go-plugins" \
  -e "KONG_DECLARATIVE_CONFIG=/tmp/config.yml" \
  -e "KONG_PLUGINS=go-hello" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
  -p 8000:8000 \
  kong-demo

# issue a request!
http :8000/anything
