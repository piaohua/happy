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

TODO
-----
    tcp连接池
    与其它节点通信方式选择和协议定义
