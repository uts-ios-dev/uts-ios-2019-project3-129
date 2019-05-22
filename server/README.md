# Server

A simple blockchain server build with Vapor.

## Run

You can run server on different servers to make it decentralize.

```shell
vapor build
```

```shell
vapor run --port=8080
```

## API

### Get Blog

Get [http://localhost:8080/blockchain](http://localhost:8080/blockchain)

Return the total blocks in this blockchain:

```json
{
  "blocks": [
    {
      "nonce": 317,
      "previousHash": "0000000000000000",
      "hash": "0073c9bf671f34aa448c27a8e6ed3f662d1bb1cf",
      "transactions": [],
      "index": 0
    }
  ]
}
```

### Mine Blog

Post [http://localhost:8080/mine](http://localhost:8080/mine) with `Content-Type: application/json`

Post body: 

```json
{
    "title": "first blog",
    "category": "iOS",
    "content": "this is my first blog!"
}
```

Return the block:

```json
{
  "nonce": 25,
  "previousHash": "0073c9bf671f34aa448c27a8e6ed3f662d1bb1cf",
  "hash": "00295c184251ffc617034ed0dc92befa1b38e4ba",
  "transactions": [
    {
      "title": "first blog",
      "category": "iOS",
      "content": "this is my first blog!"
    }
  ],
  "index": 1
}
```

### Resolving Conflicts

Register server IPs to one blockchain, if you have set up two or more servers. In this way, we can let each blockchain know others well.

Post [http://localhost:8080/nodes/register](http://localhost:8080/nodes/register)

Post body:

```json
[
    {
        "address": "http:\/\/localhost:8080"
    },
    {
        "address": "http:\/\/localhost:8090"
    }
]
```

Get [http://localhost:8080/nodes](http://localhost:8080/nodes) to know other blockchain IPs.

```json
[
  {
    "address": "http:\/\/localhost:8080"
  },
  {
    "address": "http:\/\/localhost:8090"
  }
]
```

Get [http://localhost:8080/resolve](http://localhost:8080/resolve) on one server to transfer information between each blockchain. Thus we can ensure the newest blogs are stored in other blockchains.


