happy
=====

An OTP application

Build
-----

    $ rebar3 compile
    $ rebar3 shell --apps=happy --config=./config/sys.config
    $ rebar3 shell --apps=gate --config=./config/sys.gate.config
    $ rebar3 as prod release -n happy
    $ rebar3 as prod tar

## Document
-----
    gate
    happy
    mongodb
    protobuf
    websocket

```

> rebar3 --version
rebar 3.5.0 on Erlang/OTP 20 Erts 9.0.5

```

## Usage

```
get session
curl http://127.0.0.1:8090/get?echo=session

get session by js_code
curl http://127.0.0.1:8090/get?echo=js_code&js_code=xxx

post request
curl -d "echo=session" http://127.0.0.1:8090/post

post request by js_code
curl -d "echo=js_code&js_code=xxx" http://127.0.0.1:8090/post

websocket connection by session
http://127.0.0.1:8090/websocket/login?3rd_session=xxx

```

TODO
-----
    tcp连接池
    与其它节点通信方式选择和协议定义
