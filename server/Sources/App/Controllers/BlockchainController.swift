//
//  BlockchainController.swift
//  App
//
//  Created by 庄鸣真 on 2019/5/22.
//

import Foundation
import Vapor

class BlockchainController {
    
    func getBlockchain(req: Request) throws -> Blockchain {
        return try req.make(BlockchainService.self).getBlockchain()
    }
    
    func greet(req: Request) -> Future<String> {
        return Future.map(on: req){ () -> String in
            return "Welcome to Blockchain"
        }
    }
    
    func registerNodes(req:Request, nodes:[BlockchainNode]) throws -> [BlockchainNode] {
        return try req.make(BlockchainService.self).registerNodes(nodes: nodes)
    }
    
    func getNodes(req: Request) throws -> [BlockchainNode] {
        return try req.make(BlockchainService.self).getNodes()
    }
    
    func getArticlesFromUser(req: Request) throws -> Future<[Transaction]> {
        let userHash = try req.parameters.next(String.self)
        return Future.map(on: req){ () -> [Transaction] in
            return try req.make(BlockchainService.self).getLatestTransactionsByUser(hash: userHash)
        }
    }
    
    func newArticle(req: Request) throws -> Future<HTTPResponse> {
        return try req.content.decode(NewArticleRequest.self).map(to: HTTPResponse.self) { newArticleRequest in
            guard let sender = newArticleRequest.sender.sha256() else { return HTTPResponse(status: .notAcceptable, body: "Missing sender's key") } // TODO: -> const
            if newArticleRequest.content.isEmpty { return HTTPResponse(status: .notAcceptable, body: "Missing content") }
            let category = newArticleRequest.category.isEmpty ? "default" : newArticleRequest.category
            let transaction = Transaction(sender: sender,
                                          author: newArticleRequest.author,
                                          title: newArticleRequest.title,
                                          category: category,
                                          content: newArticleRequest.content,
                                          isHide: newArticleRequest.isHide)
            
            let service = try req.make(BlockchainService.self)
            let articleAddress = service.addNewBlockWith(transaction: transaction)
            return HTTPResponse(status: .ok, body: "{ \"articleAddress\": \"\(articleAddress)\" }")
        }
    }

    func updateArticle(req: Request) throws -> Future<HTTPResponse> {
        var updateDate: Double = 0
        return try req.content.decode(UpdateArticleRequest.self).map(to: HTTPResponse.self) { updateArticleRequest in
            guard let sender = updateArticleRequest.sender.sha256() else { return HTTPResponse(status: .notAcceptable, body: "Missing sender's key") }
            if updateArticleRequest.content.isEmpty { return HTTPResponse(status: .notAcceptable, body: "Missing content") }
            let category = updateArticleRequest.category.isEmpty ? "default" : updateArticleRequest.category
            let transaction = Transaction(sender: sender,
                                          author: updateArticleRequest.author,
                                          title: updateArticleRequest.title,
                                          category: category,
                                          content: updateArticleRequest.content,
                                          isHide: updateArticleRequest.isHide)
            updateDate = transaction.dateCreated
            let service = try req.make(BlockchainService.self)
            do {
                try service.appendTransactionToBlock(hash: updateArticleRequest.articleAddress, transaction: transaction)
            } catch BlockError.blockHashNotExist {
                return HTTPResponse(status: .badRequest, body: "Article not existed")
            }
            return HTTPResponse(status: .ok, body: String(updateDate))
        }
    }
    
    func searchArticle(req: Request) throws -> Future<[Transaction]> {
        let keywords = try req.parameters.next(String.self)
        return Future.map(on: req){ () -> [Transaction] in
            return try req.make(BlockchainService.self).searchArticle(keywords: keywords)
        }
    }
    
    func resolve(req: Request) throws -> Future<Blockchain> {
        let promise: EventLoopPromise<Blockchain> = req.eventLoop.newPromise()
        try req.make(BlockchainService.self).resolve {
            promise.succeed(result: $0)
        }
        return promise.futureResult
    }
}
