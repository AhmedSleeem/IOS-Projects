	
import Foundation
import CoreData


extension LeagueCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LeagueCoreData> {
        return NSFetchRequest<LeagueCoreData>(entityName: "LeagueCoreData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var bagde: String?

}
