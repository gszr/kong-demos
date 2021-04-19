

docker network create kong-demo

docker run -d --name kong-database \
  --network kong-demo -p 5432:5432 \
  -e POSTGRES_USER=kong \
  -e POSTGRES_DB=kong \
  postgres:10

docker run --rm -ti --network kong-demo \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  kong kong migrations bootstrap

docker run --rm -ti --name kong-cp --network kong-demo \
  -e "KONG_ROLE=control_plane" \
  -e "KONG_CLUSTER_CERT=/certs/cluster.crt" \
  -e "KONG_CLUSTER_CERT_KEY=/certs/cluster.key" \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
  -p 8001:8001 \
  -v "$PWD:/certs" \
  kong

docker run --rm -ti --name kong-dp --network kong-demo \
  -e "KONG_ROLE=data_plane" \
  -e "KONG_DATABASE=off" \
  -e "KONG_CLUSTER_CONTROL_PLANE=kong-cp:8005" \
  -e "KONG_CLUSTER_CERT=/certs/cluster.crt" \
  -e "KONG_CLUSTER_CERT_KEY=/certs/cluster.key" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000 http2" \
  -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=/certs/cluster.crt" \
  -p 8000:8000 \
  -v "$PWD:/certs" \
  kong

http :8001/clustering/status

docker run -d --name grpcbin-upstream --network kong-demo moul/grpcbin

http :8001/services name=grpc url=grpc://grpcbin-upstream:9000 -f
http :8001/services/grpc/routes protocols=grpc paths=/ -f

# grpcurl!
grpcurl -v -d '{"greeting": "Kong!"}' -plaintext localhost:8000 hello.HelloService.SayHello

# kill control plane!

# restart data plane

