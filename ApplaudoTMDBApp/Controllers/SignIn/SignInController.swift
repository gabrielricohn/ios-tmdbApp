//
//  SignInController.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 4/2/21.
//

import Foundation
import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInScrollView: UIScrollView!
    @IBOutlet weak var signInStackView: UIStackView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        logInButton.backgroundColor = UIColor.systemGreen
        logInButton.tintColor = UIColor.white
        logInButton.layer.cornerRadius = 5
        
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "username",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "tmdbText")!])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "tmdbText")!])
        
        userNameTextField.textColor = UIColor.black
        passwordTextField.textColor = UIColor.black
        
        passwordTextField.isSecureTextEntry = true
        
        signInScrollView.isScrollEnabled = false
        
        loadingIndicator.color = UIColor.white
        loadingIndicator.isHidden = true
        
//        if userNameTextField.text!.isEmpty && passwordTextField.text!.isEmpty {
            logInButton.isEnabled = false
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        signInScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+150)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        signInScrollView.isScrollEnabled = true
        
    }
    
    @objc func keyboardWillHide() {
        
        resetScrollView()

        signInScrollView.isScrollEnabled = false
        
    }
    
    func resetScrollView() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1) {
            self.signInScrollView.setContentOffset(.zero, animated: false)
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        logInButton.isEnabled = !(userNameTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        validateSignIn()
    }
    
}

extension SignInViewController: SignInView {
    func validateSignIn() {
        logInButton.isHidden = true
        loadingIndicator.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            print("Funciona!")
            self.loadingIndicator.isHidden = true
            self.logInButton.isHidden = false
        })
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTextField:
            UIView.animate(withDuration: 0.1) {
                self.signInScrollView.contentOffset = CGPoint(x: 0, y: 100)
            }
            break
        default:
            break
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        textField.text = textField.text?.replacingOccurrences(of: " ", with: "")
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
//        if !userNameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
//            logInButton.isEnabled = true
//        } else {
//            logInButton.isEnabled = false
//        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return false
    }
}