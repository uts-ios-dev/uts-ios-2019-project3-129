# Server

A simple blockchain server build with Vapor.

## Run

```shell
vapor build
```

```shell
vapor run --port 8080
```

You can run it on more than one servers to make it decentralize.
## API

### Get whole blogchain

Get [http://localhost:8080/api/blockchain](http://localhost:8080/api/blockchain)

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

### Post an article

Post [http://localhost:8080/api/newArticle](http://localhost:8080/api/newArticle) with `Content-Type: application/json`

`curl -d "title=bad&author= Naniel&sender=Tester&category=IT&content=mama&isHide=false" -X POST http://localhost:8080/api/newArticle`

### Update an article
Post [http://localhost:8080/api/updateArticle](http://localhost:8080/api/updateArticle) with `Content-Type: application/json`

`curl -d "height=1&title=bad&author= Naniel&sender=Tester&category=IT&content=mama&isHide=false" -X POST http://localhost:8080/api/updateArticle`

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
