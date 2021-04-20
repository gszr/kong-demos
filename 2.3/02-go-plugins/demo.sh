
#
docker build -t kong-demo .

docker run -ti --rm --name kong-go-plugins \
  -e "KONG_DATABASE=off" \
  -e "KONG_DECLARATIVE_CONFIG=/tmp/config.yml" \
  -e "KONG_PLUGINS=go-hello" \
  -e "KONG_PLUGINSERVER_NAMES=go-hello" \
  -e "KONG_PLUGINSERVER_GO_HELLO_QUERY_CMD=go-hello -dump" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
  -p 8000:8000 \
  kong-demo

# issue a request!
http :8000/anything
