import Foundation
import UIKit
import Firebase

class AddUserViewController: UIViewController {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = " "
        usernameField.text = ""
        passwordField.text = ""
        nameField.text = ""
        confirmPasswordField.text = ""
        ref = Database.database().reference()
    }
    
    @IBAction func addUser() {
        var unique = true
        if usernameField.text! == "" || passwordField.text! == "" || confirmPasswordField.text! == "" || nameField.text! == "" {
            errorLabel.text = "Please fill out all fields"
        } else {
            ref.child("users").observe(DataEventType.value, with: {
                (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    DispatchQueue.main.async {
                        for (key, _) in value {
                            if let stringkey = key as? String {
                                if (stringkey == self.usernameField.text!) {
                                    unique = false
                                }
                            }
                        }
                        if (unique) {
                            if (self.passwordField.text! == self.confirmPasswordField.text!) {
                                self.ref.child("users/\(self.usernameField.text!)").setValue(["password": self.passwordField.text!, "name": self.nameField.text!])
                                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                            }
                            else {
                                self.errorLabel.text = "Passwords do not match"
                            }
                        } else {
                            self.errorLabel.text = "Username already exists"
                        }
                    }
                }
            })
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToLogin" {
            if let destVC = segue.destination as? LoginViewController {
                destVC.accountMade = true
            }
        }
    }
}
