
import CoreData
import UIKit
class CoreManager: NSObject {
    static let shared = CoreManager()
    
    // Fetch Data From User Entity
    func fetchData(entityName:String,completion: @escaping ([NSManagedObject]) -> Void) {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)

        let managedObject = appDelegate!.persistentContainer.viewContext

        do {
            let data = try! managedObject.fetch(fetchReq)
            completion((data as? [NSManagedObject])!)
        }
    }

    // Save Record
    func saveUserData(isSaveDetail:Bool? = false,company:String? = "",follower:String?="",following:String?="",blog:String?="",id: Int, name: String,avtarURL:String, avtar: UIImage?,entityName:String,  completion: @escaping (_ success: Bool) -> Void) {
        let managedContext = appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)

        let user = NSManagedObject(entity: entity!, insertInto: managedContext)
        user.setValue(name, forKey: "name")
        user.setValue(id, forKey: "id")
        user.setValue(avtarURL, forKey: "avtarURL")
        print("CHECMATE - \(user)")
        if isSaveDetail!{
            user.setValue(company, forKey: "company")
            user.setValue(follower, forKey: "follower")
            user.setValue(blog, forKey: "blog")
            user.setValue(following, forKey: "following")
        }
     //   user.setValue(avtarImage?.pngData(), forKey: "name")

        do {
            try! managedContext.save()

            completion(true)
        } catch _ {
            completion(false)
        }
    }

    func updateDataByName(entityName:String,noteText:String,searchText: String, note: Bool, lastName: String, completion: @escaping (_ success: Bool) -> Void) {
        let managedObject = appDelegate!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        fetchReq.predicate = NSPredicate(format: "name = %@", searchText)

        do {
            let data = try! managedObject.fetch(fetchReq)
            if data.count == 0 {
                print("Not found")
                completion(false)
                return
            }
            let obj = data[0] as! NSManagedObject

            if noteText.count>0{
                obj.setValue(noteText, forKey: "note")
            }
            if entityName == "Users"{
                obj.setValue(note, forKey: "isNoteAvailable")

            }
            try? managedObject.save()
            completion(true)
        }
    }

    func searchRecord(entityName:String,searchText: String, completion: @escaping (_ success: Bool, _ managedObj: [NSManagedObject?]) -> Void) {
        let managedObject = appDelegate!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        fetchReq.predicate = NSPredicate(format: "name = %@", searchText)
        do {
            let data = try! managedObject.fetch(fetchReq)
            if data.count == 0 {
                completion(false, [])
                return
            } else {
                completion(true, (data as? [NSManagedObject])!)
            }
        }
    }

    func deleteDataByName(searchText: String, completion: @escaping (_ success: Bool) -> Void) {
        let managedObject = appDelegate!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        fetchReq.predicate = NSPredicate(format: "firstname = %@", searchText)
        do {
            let data = try! managedObject.fetch(fetchReq)
            if data.count > 0 {
                managedObject.delete(data[0] as! NSManagedObject)
                try? managedObject.save()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
