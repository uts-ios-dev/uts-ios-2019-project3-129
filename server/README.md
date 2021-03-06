# Server

A simple blockchain server build with Vapor.

## Run

```shell
vapor build
```

```shell
vapor run --port=8080
```

You can run it on more than one servers to make it decentralize.
## API

### Get whole blogchain

Get [http://localhost:8080/api/blockchain](http://localhost:8080/api/blockchain)

Return all blocks in this blockchain:

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
### Get articles from an author
GET [http://localhost:8080/api/articlesFrom/](http://localhost:8080/api/articlesFrom/) with `Content-Type: application/json`

`curl -X GET http://localhost:8080/api/articlesFrom/sender-hash-tester`

Return all articles from this user:

```json
[
    {
        "author": "TESTER",
        "hash": "6b23c0d5f35d1b11f9b683f0b0a617355deb11277d91ae091d399c655b87940d",
        "sender": "sender-hash-tester",
        "category": "IT",
        "content": "C",
        "dateCreated": 1559186249.983808,
        "title": "Remembering",
        "isHide": false
    },
    {
        "author": "Daniel",
        "hash": "8545da324c45583d86d59dea575f60ffd8d9a594382d1c59df2a2d98740d173e",
        "sender": "sender-hash-tester2",
        "category": "Medecine",
        "content": "# Preview",
        "dateCreated": 1559186249.9843121,
        "title": "Tuition pumps",
        "isHide": true
    }
]
```


### Post an article

Post [http://localhost:8080/api/newArticle](http://localhost:8080/api/newArticle) with `Content-Type: application/json`

`curl -d "title=bad&author= Naniel&sender=Tester&category=IT&content=mama&isHide=false" -X POST http://localhost:8080/api/newArticle`


### Update an article
Post [http://localhost:8080/api/updateArticle](http://localhost:8080/api/updateArticle) with `Content-Type: application/json`

`curl -d "articleAddress=4f53289d5e7f59c04ae46d12c3ea079fa208a1f265bfbc5bfd30b25265e2119a&title=TITLE&author= Naniel&sender=Tester&category=IT&content=mama&isHide=false" -X POST http://localhost:8080/api/updateArticle`

### Delete an article

`curl -d "articleAddress=18dc984801871a7fda94d1919139749585e89ebab30441392ca418deba50bb1a&title=TITLE&author= Naniel&sender=Tester&category=IT&content=mama&isHide=true" -X POST http://localhost:8080/api/updateArticle`

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


