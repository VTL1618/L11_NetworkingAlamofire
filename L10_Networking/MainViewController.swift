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

    // MARK: - Private Methods
    
    private func successAlert() {
        let alert = UIAlertController(title: "Success",
                                      message: "You can see results in the Debug area", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okey", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func failedAlert() {
        let alert = UIAlertController(title: "Failed",
                                      message: "You can see error in the Debug area", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okey", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // зададим через UIScreen метод
        // - 48 это отступы по 24 слева и справа
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}
