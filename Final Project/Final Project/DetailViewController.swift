import Foundation
import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var listItem: ListItem?
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descriptionView: UITextView!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    var index = 0
    var user = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = ""
        titleField.text = listItem!.title
        descriptionView.text = listItem!.description
        dateField.text = listItem!.date
        descriptionView.layer.borderWidth = 0.2
        descriptionView.layer.borderColor = UIColor.systemGray.cgColor
        descriptionView.layer.cornerRadius = 5
        ref = Database.database().reference()
    }
    
    @IBAction func save() {
        if titleField.text! == "" {
            messageLabel.text = "Please fill in at least a title"
        } else {
            self.ref.child("items/\(user)/\(index)").setValue(["title": titleField.text!, "description": descriptionView.text!, "date": dateField.text!])
        }
    }


}
