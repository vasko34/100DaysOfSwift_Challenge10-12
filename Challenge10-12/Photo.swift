import UIKit

class Photo: NSObject, Codable {
    var photoID: String
    var photoName: String
    
    init(photoID: String, photoName: String) {
        self.photoID = photoID
        self.photoName = photoName
    }
}
