//
//  UpdateArticleRequest.swift
//  App
//
//  Created by AnLuoRidge on 26/5/19.
//

import Foundation
import Vapor

struct UpdateArticleRequest: Content {
    let sender: String
    let articleAddress: String
    let author: String
    let title: String
    let category: String
    let content: String
    let isHide: Bool
}
