//
//  CoursesViewController.swift
//  L10_Networking
//
//  Created by Vitaly Zubenko on 19.06.2022.
//

import UIKit

class CoursesViewController: UITableViewController {
    
    var courses: [Course] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //зададим фиксированную высоту ячеек
        tableView.rowHeight = 100
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCourses", for: indexPath) as! CourseCell
        // для ячейки мы тоже соответственно создали свой тип CourseCell
        // и мы сейчас ее реализуем
        let course = courses[indexPath.row]
        // теперь надо в ячейке сделать конфигурацию не забыть. В файле CourseCell
        // есть структура и мы должны применить ее поля на ячейку
        // готово, теперь конфигурируем ячейку
        cell.configure(with: course)
        return cell
    }

}

// MARK: - Networking
extension CoursesViewController {
    func fetchCourses() {
        guard let url = URL(string: URLExamples.exampleTwo.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                return
            }
            
            do {
                // получаем курсы в переменную
                self.courses = try JSONDecoder().decode([Course].self, from: data)
                // и мы должны перезагрузить таблицу
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
