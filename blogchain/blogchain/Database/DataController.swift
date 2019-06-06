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

    private var articles: [Artical]?
    public var allArticles: [Artical]? {
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
        let entity = NSEntityDescription.entity(forEntityName: "Artical", in: persistentContainer.viewContext)!
        let newArticle = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Artical
        newArticle?.title = title
        newArticle?.content = content
        newArticle?.created = now
        newArticle?.modified = now
        saveContext()
        self.articles = fetchAllArticle()
    }

    func searchArticles(keyword: String) -> [Artical] {
        let fetch: NSFetchRequest<Artical> = Artical.fetchRequest()
        let predicate = NSPredicate(format: "(%K contains [c] %@) OR (%K contains [c] %@)",
            #keyPath(Artical.title),
            keyword,
            #keyPath(Artical.content),
            keyword)

        fetch.predicate = predicate
        let context = persistentContainer.viewContext
        var articles = [Artical]()
        do {
            articles = try context.fetch(fetch)
        } catch {
            print("search with error: \(error)")
        }
        return articles
    }

    func saveArticle(instance: Artical, title: String?, content: String?) {
        let now = Date()
        instance.modified = now
        instance.title = title
        instance.content = content
        if (instance.addressKey != nil) {
            instance.dirty = true
        }
        saveContext()
    }
    
    func saveArticle(instance: Artical, title: String?, content: String?, modified: Date?) {
        instance.modified = modified
        instance.title = title
        instance.content = content
        instance.dirty = false;
        if (instance.addressKey != nil) {
            instance.dirty = true
        }
        saveContext()
    }
    
    func saveArticle(title: String?, content: String?, modified: Date?, keyaddress: String?) {
        let entity = NSEntityDescription.entity(forEntityName: "Artical", in: persistentContainer.viewContext)!
        let newArticle = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Artical
        newArticle?.title = title
        newArticle?.content = content
        newArticle?.created = modified
        newArticle?.modified = modified
        newArticle?.addressKey = keyaddress
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
//        let entity = NSEntityDescription.entity(forEntityName: "Artical", in: persistentContainer.viewContext)!
//        self.article = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Artical
//    }

    func fetchAllArticle() -> [Artical]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Artical")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "modified", ascending: false)]

        do {
            let result = try persistentContainer.viewContext.fetch(request)
            print(result)

            print("fetch success")
            return result as? [Artical]
        } catch {
            print("Failed")
            return nil
        }
    }

    func deleteArtical(artical: Artical) {
        persistentContainer.viewContext.delete(artical)
        saveContext()
        articles = fetchAllArticle()
    }

    func deleteArticle(articles: [Artical]) {
        for article in articles {
            persistentContainer.viewContext.delete(article)
        }
        saveContext()
        self.articles = fetchAllArticle()
    }

    func deleteAllArticle() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Artical"))
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
}
