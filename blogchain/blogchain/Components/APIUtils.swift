//
//  APIUtils.swift
//  blogchain
//
//  Created by 庄鸣真 on 2019/5/28.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

//import Foundation

import Alamofire
import CodableFirebase

class APIUtils {
    static let hostAddr = "http://localhost:8080/"
    
    static func getBlockchain(completion: @escaping (_ blockchain: Blockchain) -> Void) {
        Alamofire.request("\(hostAddr)api/blockchain", method: .get).responseData { response in
            do {
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(Blockchain.self, from: value)
                    completion(jsonData)
                case .failure(let error):
                    print(error)
                }
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    static func getArticlesFromUser(hash: String, completion: @escaping (_ blockchain: [TransactionWithAddr]) -> Void) {
        Alamofire.request("\(hostAddr)api/articlesFrom/\(hash)", method: .get).responseData { response in
            do {
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode([TransactionWithAddr].self, from: value)
                    completion(jsonData)
                case .failure(let error):
                    print(error)
                }
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    static func searchArticle(keywords: String, completion: @escaping (_ blockchain: [Transaction]) -> Void) {
        Alamofire.request("\(hostAddr)api/search/\(keywords)", method: .get).responseData { response in
            do {
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode([Transaction].self, from: value)
                    completion(jsonData)
                case .failure(let error):
                    print(error)
                }
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    static func postArticle(article: Article, completion: @escaping (_ result: PostArticleResult) -> Void) {
        let parameters: Parameters = try! FirestoreEncoder().encode(article)
        Alamofire.request("\(hostAddr)api/newArticle", method: .post, parameters: parameters).responseData { response in
            do {
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(PostArticleResult.self, from: value)
                    completion(jsonData)
                case .failure(let error):
                    print(error)
                }
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    static func updateArticle(article: UpdateArticle, completion: @escaping (_ date: String) -> Void) {
        let parameters: Parameters = try! FirestoreEncoder().encode(article)
        
        Alamofire.request("\(hostAddr)api/updateArticle", method: .post, parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let value):
                    let date = String(data: value, encoding: .utf8)!
                    completion(date)
                case .failure(let error):
                    print("Error: \(error)")
                }
        }
    }
}
