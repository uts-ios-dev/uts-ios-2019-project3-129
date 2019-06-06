//
//  dataController.swift
//  blogchain
//
//  Created by 李宇沛 on 21/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import CoreData

// MARK: - Core Data Saving support

class ArticleInstance {

    private static var _instance: ArticleInstance?

    // single instance
    static func instance() -> ArticleInstance {
        if (_instance == nil) {
            _instance = ArticleInstance()
        }
        return _instance!
    }

    private var articles: [LocalArticle]?
    public var allArticles: [LocalArticle]? {
        get {
            if (articles != nil) {
                return articles
            } else {
                return fetchAllArticle()
            }
        }
    }

    func saveArticle(title: String?, content: String?) {
        let now = Date()
        let entity = NSEntityDescription.entity(forEntityName: "LocalArticle", in: persistentContainer.viewContext)!
        let newArticle = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? LocalArticle
        newArticle?.title = title
        newArticle?.content = content
        newArticle?.created = now
        newArticle?.modified = now
        saveContext()
        self.articles = fetchAllArticle()
    }

    func searchArticles(keyword: String) -> [LocalArticle] {
        let fetch: NSFetchRequest<LocalArticle> = LocalArticle.fetchRequest()
        let predicate = NSPredicate(format: "(%K contains [c] %@) OR (%K contains [c] %@)",
            #keyPath(LocalArticle.title),
            keyword,
            #keyPath(LocalArticle.content),
            keyword)

        fetch.predicate = predicate
        let context = persistentContainer.viewContext
        var articles = [LocalArticle]()
        do {
            articles = try context.fetch(fetch)
        } catch {
            print("search with error: \(error)")
        }
        return articles
    }

    func saveArticle(instance: LocalArticle, title: String?, content: String?) {
        let now = Date()
        instance.modified = now
        instance.title = title
        instance.content = content
        if (instance.addressKey != nil) {
            instance.dirty = true
        }
        saveContext()
    }

    func saveArticle(instance: LocalArticle, title: String?, content: String?, modified: Date?) {
        instance.modified = modified
        instance.title = title
        instance.content = content
        instance.dirty = false
        saveContext()
    }

    func saveArticle(instance: LocalArticle, addressKey: String, modified: Date?) {
        instance.modified = modified
        instance.dirty = false
        instance.addressKey = addressKey
        saveContext()
    }

    func saveArticle(instance: LocalArticle, modified: Date?) {
        instance.modified = modified
        instance.dirty = false
        saveContext()
    }

    func saveArticle(title: String?, content: String?, modified: Date?, keyaddress: String?) {
        let entity = NSEntityDescription.entity(forEntityName: "LocalArticle", in: persistentContainer.viewContext)!
        let newArticle = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? LocalArticle
        newArticle?.title = title
        newArticle?.content = content
        newArticle?.created = modified
        newArticle?.modified = modified
        newArticle?.addressKey = keyaddress
        newArticle?.dirty = false
        saveContext()
        self.articles = fetchAllArticle()
    }

    private func saveContext() {
        let context = persistentContainer.viewContext
        do {
            try context.save()

        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

//    private func resetInstance() {
//        let entity = NSEntityDescription.entity(forEntityName: "LocalArticle", in: persistentContainer.viewContext)!
//        self.article = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? LocalArticle
//    }

    func fetchAllArticle() -> [LocalArticle]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalArticle")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "modified", ascending: false)]

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            print(result)

            print("fetch success")
            return result as? [LocalArticle]
        } catch {
            print("Failed")
            return nil
        }
    }

    func deleteArticle(article: LocalArticle) {
        persistentContainer.viewContext.delete(article)
        saveContext()
        articles = fetchAllArticle()
    }

    func deleteArticle(articles: [LocalArticle]) {
        for article in articles {
            persistentContainer.viewContext.delete(article)
        }
        saveContext()
        self.articles = fetchAllArticle()
    }

    func deleteAllArticle() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "LocalArticle"))
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
}
