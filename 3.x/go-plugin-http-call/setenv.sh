if [ -n "$ZSH_VERSION" ]; then
    cwd=$(dirname $(readlink -f ${(%):-%N}))
else
    cwd=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
fi

export KONG_DATABASE=off
export KONG_DECLARATIVE_CONFIG="$cwd/kong.yml"
export KONG_PLUGINS="bundled,go-hello"
export KONG_PLUGINSERVER_NAMES="go-hello"
export KONG_PLUGINSERVER_GO_HELLO_SOCKET=$KONG_PREFIX/go-hello.socket
export KONG_PLUGINSERVER_GO_HELLO_QUERY_CMD="$cwd/go-hello -dump"
export KONG_PLUGINSERVER_GO_HELLO_START_CMD="$cwd/go-hello -kong-prefix $KONG_PREFIX"

