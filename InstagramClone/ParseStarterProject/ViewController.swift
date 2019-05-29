
import UIKit
import Parse

// http:/ec2-18-218-58-210.us-east-2.compute.amazonaws.com/apps/My%20Bitnami%20Parse%20API/browser/Users - my web server link
// user - username of my web server
// NaKABUaUjlA2 - password of my web server

class ViewController: UIViewController {
    
    var signUpMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction (title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var signUpOrLogin: UIButton!
    
    @IBAction func signUpOrLogin(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error in form!", message: "Please, enter an email and password!")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signUpMode {
                
                // Sign up
                
                let user = PFUser()
                
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please, try again later."
                        
                        if let errorMessage = error?._userInfo?["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Sign up error!", message: displayErrorMessage)
                        
                    } else {
                        
                        print("User signed up!")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                })
                
            } else {
                
                // Log in mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please, try again later."
                        
                        if let errorMessage = error?._userInfo?["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Log in error!", message: displayErrorMessage)
                        
                    } else {
                        
                        print("Logged in!")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                    
                })
                
            }
            
        }
        
    }
    
    @IBOutlet weak var changeSingUpModeButton: UIButton!
    
    @IBAction func changeSignUpMode(_ sender: Any) {
        
        
        if signUpMode {
            
            // Change to login mode
            
            signUpOrLogin.setTitle("Log In", for: [])
            
            changeSingUpModeButton.setTitle("Sign Up", for: [])
            
            messageLabel.text = "Don't have an account?"
            
            signUpMode = false
            
        } else {
            
            // Change to signup mode
            
            signUpOrLogin.setTitle("Sign Up", for: [])
            
            changeSingUpModeButton.setTitle("Log In", for: [])
            
            messageLabel.text = "Already have an account?"
            
            signUpMode = true
            
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            self.performSegue(withIdentifier: "showUserTable", sender: self)
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
