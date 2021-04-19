#
make

docker run -ti --rm --name kong-js-plugins -v $PWD:/demo \
  -e "KONG_DATABASE=off" \
  -e "KONG_DECLARATIVE_CONFIG=/demo/config.yml" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
  -p 8000:8000 \
  kong-2.4-demo-js-plugins kong start -v -c /demo/kong.conf

# issue a request!
http :8000/anything
