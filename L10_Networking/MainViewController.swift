//
//  L10_Networking
//
//  Created by Vitaly Zubenko on 18.06.2022.
//

import UIKit

// api
enum URLExamples: String {
    case imageURL = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    case exampleOne = "https://swiftbook.ru//wp-content/uploads/api/api_course"
    case exampleTwo = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    case exampleThree = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    case exampleFour = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
}

// возможные экшены для пользователя
enum UserActions: String, CaseIterable {
    case downloadImage = "Download Image"
    case exampleOne = "Example One"
    case exampleTwo = "Example Two"
    case exampleThree = "Example Three"
    case exampleFour = "Example Four"
    case ourCourses = "Our Courses"
}

class MainViewController: UICollectionViewController {
    
    let userActions = UserActions.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // кастим
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        
        // нам нужно понять какой заголовок подставлять для текущей ячейки
        // и у collectionView нет, в отличии от таблицы, лейбла (базовые стили), поэтому мы создали ячейку UserActionCell и присвоили ей лейбл userActionLabel
        // создаем переменную и вытягивает туда 1 элемент из массива юзер экшенов
        // и внутри у нас не row или section, а у него это просто item
        let userAction = userActions[indexPath.item]
        
        // теперь в лейбл который создан в нашей ячейке надо зафигачить текст
        // берем ячейку, берем у нее ее созданный лейбл, и подставляем туда userAction
        cell.userActionLabel.text = userAction.rawValue
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .downloadImage:
            performSegue(withIdentifier: "showImage", sender: nil)
        case .exampleOne:
            exampleOneButtonPressed()
        case .exampleTwo:
            exampleTwoButtonPressed()
        case .exampleThree:
            exampleThreeButtonPressed()
        case .exampleFour:
            exampleFourButtonPressed()
        case .ourCourses:
            performSegue(withIdentifier: "showCourses", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCourses" {
            let coursesVC = segue.destination as! CoursesViewController
            coursesVC.fetchCourses()
        }
    }

    // MARK: - Private Methods
    
    private func successAlert() {
        let alert = UIAlertController(title: "Success",
                                      message: "You can see the results in the Debug area", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okey", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func failedAlert() {
        let alert = UIAlertController(title: "Failed",
                                      message: "You can see the error in the Debug area", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okey", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}

// MARK: - Networking
extension MainViewController {
    
    // пишем методы под каждую кнопку
    // и для этого создадим еще вверху метод didSelectItemAt, чтобы понять какой у нас экшен был нажат
    
    private func exampleOneButtonPressed() {
        guard let url = URL(string: URLExamples.exampleOne.rawValue) else {
            return }
        
        // нам нужно теперь сделать запросы чтобы получить данные
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
        
        // дальше нам надо задекодить полученные данные
            do {
                let course = try JSONDecoder().decode(Course.self, from: data)
                
                // распечатаем теперь и добавим два соданных метода и покажем алерты
                print(course)
                
                // ставим в main поток, потому что это UI элемент, а мы показываем его не в main потоке
                DispatchQueue.main.async {
                    self.successAlert()
                }
            } catch let error {
                
                // распечатаем теперь и добавим два соданных метода и покажем алерты
                print(error)
                
                // ставим в main поток, потому что это UI элемент, а мы показываем его не в main потоке
                DispatchQueue.main.async {
                    self.failedAlert()
                }
            }
        }.resume()
    }
    
    private func exampleTwoButtonPressed() {
        guard let url = URL(string: URLExamples.exampleTwo.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                return
            }
            
            do {
                let course = try JSONDecoder().decode([Course].self, from: data)
                print(course)
                DispatchQueue.main.async {
                    self.successAlert()
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.failedAlert()
                }
            }
        }.resume()
    }
    
    private func exampleThreeButtonPressed() {
        guard let url = URL(string: URLExamples.exampleThree.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                return
            }

            do {
                let course = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                print(course)
                DispatchQueue.main.async {
                    self.successAlert()
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.failedAlert()
                }
            }
        }.resume()
    }
    
    private func exampleFourButtonPressed() {
        guard let url = URL(string: URLExamples.exampleFour.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                return
            }
            
            do {
                let course = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                print(course)
                DispatchQueue.main.async {
                    self.successAlert()
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.failedAlert()
                }
            }
        }.resume()
    }
    // теперь займемся segue последнего экрана
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // зададим через UIScreen метод
        // - 48 это отступы по 24 слева и справа
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}
