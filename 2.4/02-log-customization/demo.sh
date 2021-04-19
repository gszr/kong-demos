#
make

docker run -ti --rm --name kong-log-customization -v $PWD:/demo \
  -e "KONG_DATABASE=off" \
  -e "KONG_DECLARATIVE_CONFIG=/demo/00-original-logs_config.yml" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
  -p 8000:8000 \
  kong-2.4-demo-log-customization

#
# Run Kong with first declarative config (for unsetting an existing log field)
#
docker run -ti --rm --name kong-log-customization -v $PWD:/demo \
  -e "KONG_DATABASE=off" \
  -e "KONG_DECLARATIVE_CONFIG=/demo/01-unset-field_config.yml" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
  -p 8000:8000 \
  kong-2.4-demo-log-customization

# Issue a request!
http :8000/anything

# check logged request
docker exec kong-log-customization tail -f /var/log/kong/proxy.log | jq .route

#
# Run Kong with second declarative config (for adding a new log field)
#
docker run -ti --rm --name kong-log-customization -v $PWD:/demo \
  -e "KONG_DATABASE=off" \
  -e "KONG_DECLARATIVE_CONFIG=/demo/02-log-version_config.yml" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
  -e "KONG_UNTRUSTED_LUA_SANDBOX_REQUIRES=kong.meta" \
  -p 8000:8000 \
  kong-2.4-demo-log-customization

# check logged request
docker exec kong-log-customization tail -f /var/log/kong/proxy.log | jq .kong_version
