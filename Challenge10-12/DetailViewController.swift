import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentPhoto: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentPhoto = self.currentPhoto {
            let path = getDocumentsDirectory().appendingPathComponent(currentPhoto)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
