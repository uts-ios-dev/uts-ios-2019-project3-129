import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let blockchainController = BlockchainController()
    router.get("", use: blockchainController.greet)
    router.get("api/articlesFrom", String.parameter, use: blockchainController.getArticlesFromUser)
    router.post("api/newArticle", use: blockchainController.newArticle)
    router.post("api/updateArticle", use: blockchainController.updateArticle)
    router.get("api/blockchain", use: blockchainController.getBlockchain)
    router.post([BlockchainNode].self, at: "nodes/register", use: blockchainController.registerNodes)
    router.get("nodes", use: blockchainController.getNodes)
    router.get("resolve", use: blockchainController.resolve)
}
