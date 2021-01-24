import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var detail: String?
    @NSManaged public var title: String?
    @NSManaged public var color: String?

}

extension Note : Identifiable {

}
