import Foundation
import UIKit

protocol AddItemDelegate : class {
    func didCreate(_ item: ListItem)
}

class AddItemViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    weak var delegate: AddItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = ""
        let imgNumber = Int.random(in: 1..<5)
        if (imgNumber == 1) {
            imgView.image = UIImage(named: "tree")
        } else if (imgNumber == 2) {
            imgView.image = UIImage(named: "turtle")
        } else if (imgNumber == 3) {
            imgView.image = UIImage(named: "tree")
        } else if (imgNumber == 4) {
            imgView.image = UIImage(named: "coconut")
        }

    }

    @IBAction func cancel(_ sender: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIStoryboardSegue) {
        let listItem = createNewItem()
        if let newItem = listItem {
            self.delegate?.didCreate(newItem)
        } else {
            return
        }
    }
    
    func createNewItem() -> ListItem? {
        if titleField.text! == "" {
            messageLabel.text = "Please fill out at least a title"
            return nil
        } else {
            return ListItem(title: titleField.text!, description: descriptionField.text!, date: dateField.text!)
        }
    }
}
