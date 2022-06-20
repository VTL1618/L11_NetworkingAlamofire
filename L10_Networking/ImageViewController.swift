import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true // прячем его, когда анимация индикатора остановится
        fetchImage()
    }
    
    private func fetchImage() {
        guard let url = URL(string: URLExamples.imageURL.rawValue) else { return }
        // и нам нужно его раскрыть, потому что url'а может и не быть, потому что строка может быть не валидна. Поэтому обязательно проверим через guard
        // будем использовать базовый фреймфорк
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }.resume()
    }
}
