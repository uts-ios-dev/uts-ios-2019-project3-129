//
//  dataController.swift
//  blogchain
//
//  Created by 李宇沛 on 21/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import CoreData

// MARK: - Core Data Saving support

class ArticalInstance {
    
    private static var _instance: ArticalInstance?;
    // single instance
    static func instance() -> ArticalInstance {
        if(_instance == nil){
            _instance = ArticalInstance();
        }
        return _instance!;
    };
    
    private var articals: [Artical]?;
    public var allArticals: [Artical]?{
        get {
            if ( articals != nil ){ return articals; }
            else { return fetchAllArtical() }
        }
    }
    
    func saveArtical(title: String?, content: String?) {
        let now = Date();
        let entity = NSEntityDescription.entity(forEntityName: "Artical", in: persistentContainer.viewContext)!;
        let newArtical = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Artical;
        newArtical?.title = title;
        newArtical?.content = content;
        newArtical?.created = now;
        newArtical?.modified = now;
        saveContext();
        self.articals = fetchAllArtical();
    }
    
    func saveArtical(instance: Artical, title:String?, content: String?) {
        let now = Date();
        instance.modified = now;
        instance.title = title;
        instance.content = content;
        if(instance.addressKey != nil){ instance.dirty = true; }
        saveContext();
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        do {
            try context.save();
            
        } catch {
            let nserror = error as NSError;
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)");
        }
    }
    
//    private func resetInstance() {
//        let entity = NSEntityDescription.entity(forEntityName: "Artical", in: persistentContainer.viewContext)!;
//        self.artical = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Artical;
//    }
    
    func fetchAllArtical() -> [Artical]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Artical");
        request.returnsObjectsAsFaults = false;
        request.sortDescriptors = [NSSortDescriptor(key: "modified", ascending: false)];
        
        do {
            let result = try persistentContainer.viewContext.fetch(request);
            print(result);
            
            print("fetch success");
            return result as? [Artical];
        } catch {
            print("Failed");
            return nil;
        }
    }
    
    func deleteArtical(artical: Artical) {
        persistentContainer.viewContext.delete(artical);
        saveContext();
        articals = fetchAllArtical();
    }
    
    func deleteArtical(articals: [Artical]) {
        for artical in articals{
            persistentContainer.viewContext.delete(artical);
        }
        saveContext();
        self.articals = fetchAllArtical();
    }
    
    func deleteAllArtical() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Artical"));
        do {
            try persistentContainer.viewContext.execute(deleteRequest);
        } catch {
            print(error);
            
        }
    }
    
}
