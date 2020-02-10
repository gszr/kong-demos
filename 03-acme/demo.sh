# start kong with
# KONG_NGINX_PROXY_LUA_SSL_TRUSTED_CERTIFICATE=/etc/ssl/cert.pem
# 

http :8001/services name=acme-demo url=http://mockbin.org -f
http :8001/routes service.name=acme-demo hosts=$NGROK_HOST -f
http :8001/plugins name=acme config.account_email=test@test.com config.tos_accepted=true config.domains=$NGROK_HOST -f

curl https://$NGROK_HOST:8443 --resolve $NGROK_HOST:8443:127.0.0.1 -vk
curl https://$NGROK_HOST:8443 --resolve $NGROK_HOST:8443:127.0.0.1 -v
