import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var img: UIImageView!
    var accountMade = false
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.image = UIImage(named: "beachcolor")
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (accountMade) {
            messageLabel.text = "Account created, try logging in!"
            accountMade = false
        } else {
            messageLabel.text = ""
        }
    }
    
    @IBAction func login(_ sender: UIStoryboardSegue) {
        if usernameField.text! == "" || passwordField.text! == "" {
            // Make error message for empty field
            messageLabel.text = "Please fill out all fields"
        } else {
            ref.child("users").observe(DataEventType.value, with: {
                (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    DispatchQueue.main.async {
                        var found = true
                        if (self.usernameField.text! != "") {
                            found = false
                        }
                        for (key, value) in value {
                            if let stringkey = key as? String {
                                if (stringkey == self.usernameField.text!) {
                                    found = true
                                    if let valuedict = value as? NSDictionary, let password = valuedict["password"] as? String {
                                        if (password == self.passwordField.text!) {
                                            self.performSegue(withIdentifier: "LoginToTable", sender: sender)
                                        } else {
                                            // Error: incorrect password
                                            self.messageLabel.text = "Incorrect password"
                                        }
                                    }
                                }
                            }
                        }
                        if (!found) {
                            self.messageLabel.text = "Incorrect username"
                        }
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToTable" {
            if let destVC = segue.destination as? ListViewController {
                destVC.user = usernameField.text!
            }
        }
        self.usernameField.text! = ""
        self.passwordField.text! = ""
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {

    }
}
