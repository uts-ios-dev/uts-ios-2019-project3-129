//
//  NewArticleRequest.swift
//  App
//
//  Created by AnLuoRidge on 26/5/19.
//

import Foundation
import Vapor

struct NewArticleRequest: Content {
    let sender: String
    let author: String
    let title: String
    let category: String
    let content: String
    let isHide: Bool
}
