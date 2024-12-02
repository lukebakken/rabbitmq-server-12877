## Hosts

```
127.0.0.1	rmq0.local rmq1.local rmq2.local
```

## Setup

```
git submodule update --init
make -C rabbitmq-server
```

## Bring up a cluster

* Open four terminals in this directory
* In one terminal, run `make start-rmq0`
* In another terminal, run `make start-rmq1`
* In the third terminal, run `make start-rmq2`
* In the fourth terminal, run `make form-cluster status` to see your cluster.
