import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
        
        let jsonDecoder = JSONDecoder()
        let defaults = UserDefaults.standard
        if let photosToLoad = defaults.object(forKey: "photos") as? Data {
            do {
                photos = try jsonDecoder.decode([Photo].self, from: photosToLoad)
            } catch {
                print("Failed to load photos.")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.originalImage] as? UIImage else { return }
        
        let photoID = UUID().uuidString
        let photoPath = getDocumentsDirectory().appendingPathComponent(photoID)
        if let jpegData = photo.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: photoPath)
        }
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Enter photo name:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak ac, weak self] _ in
            if let name = ac?.textFields?[0].text {
                let photo = Photo(photoID: photoID, photoName: name)
                self?.photos.append(photo)
                self?.savePhotos()
                self?.tableView.reloadData()
            }
        })
        present(ac, animated: true)
    }
    
    @objc func takePhoto() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        cell.textLabel?.text = photos[indexPath.row].photoName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.currentPhoto = photos[indexPath.row].photoID
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func savePhotos() {
        let jsonEncoder = JSONEncoder()
        if let savedPhotos = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedPhotos, forKey: "photos")
        } else {
            print("Failed to save photos.")
        }
    }
}

