happy
=====

An OTP application

Build
-----

    $ rebar3 compile
    $ rebar3 shell --apps=happy --config=./config/sys.config
    $ rebar3 shell --apps=gate --config=./config/sys.gate.config

## Document
-----
    gate
    happy
    mongodb
    protobuf
    websocket

TODO
-----
    tcp连接池
    与其它节点通信方式选择和协议定义
