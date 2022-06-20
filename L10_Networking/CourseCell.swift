
import UIKit

class CourseCell: UITableViewCell {
    @IBOutlet var courseImage: UIImageView!
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var numberOfLessons: UILabel!
    @IBOutlet var numberOfTests: UILabel!
    
    func configure(with course: Course) {
        courseNameLabel.text = course.name
        numberOfTests.text = "Number Of Tests \(course.number_of_tests ?? 0)"
        numberOfLessons.text = "Number Of Lessons \(course.number_of_lessons ?? 0)"
        
        DispatchQueue.global().async {
            guard let stringUrl = course.imageUrl,
                  let imageURL = URL(string: stringUrl),
                  let imageData = try? Data(contentsOf: imageURL) else {
                return
            }
            
            DispatchQueue.main.async {
                self.courseImage.image = UIImage(data: imageData)
            }
        }
        
    }
}
