//
//  SignInController.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 4/2/21.
//

import Foundation
import UIKit

class SignInController: UIViewController {
    
    @IBOutlet weak var signInScrollView: UIScrollView!
    @IBOutlet weak var signInStackView: UIStackView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    weak var applicationDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var signInPresenter: SignInPresenter!
    
    var authToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        loadingIndicator.color = UIColor.white
        
        passwordTextField.isSecureTextEntry = true
        
        signInScrollView.isScrollEnabled = false
    
        loadingIndicator.isHidden = true
        
        logInButton.isEnabled = false
        
        setupPresenter()
        
        setupUI()
        
        if let appDelegate = applicationDelegate{
            appDelegate.connectionDelegate = self
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        registerNotifications()
//        retrieveToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        signInScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+150)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        unregisterNotifications()
    }
    
    func setupPresenter() {
        signInPresenter = SignInPresenter(tmdbService: TmdbService())
        signInPresenter.attachView(view: self)
    }
    
    func setupUI() {
        logInButton.backgroundColor = UIColor.systemGreen
        logInButton.tintColor = UIColor.white
        logInButton.layer.cornerRadius = 5
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "username",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "tmdbText")!])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "tmdbText")!])
        
        userNameTextField.textColor = UIColor.black
        passwordTextField.textColor = UIColor.black
    }
    
    func checkForPreviousSession() {
        if Utility.sessionToken.count != 0 {
            
            navigateToHome()
            
        }
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
    
    func createSignInModel() -> SignInDetails {
        var signInDetails = SignInDetails()
        signInDetails.userName = userNameTextField.text!
        signInDetails.password = passwordTextField.text!
        signInDetails.token = authToken
        return signInDetails
    }
    
    @IBAction func logInAction(_ sender: Any) {
        
        validateSignIn()
        
    }
    
    func showAlert(withTitle title: String, withMessage message:String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alert.addAction(ok)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
    }
    
}

extension SignInController: SignInView {
    
    func loadTokenFromServer(token: String) {
        authToken = token
    }
    
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    func showLoadingIndicator() {
        
        logInButton.isHidden = true
        loadingIndicator.isHidden = false
        
    }
    
    func hideLoadingIndicator() {
        
        self.loadingIndicator.isHidden = true
        self.logInButton.isHidden = false
        
    }
    
    func validateSignIn() {
                
        signInPresenter.fetchAuthTokenfromApi(completion: { success in
            if success {
                self.signInPresenter.checkLogInCredentials(model: self.createSignInModel())
            }
        })
        
    }
    
    func signInFailed(messageApi: String) {
        
        showAlert(withTitle: "Login Failed", withMessage: messageApi)
                
    }
    
}

extension SignInController: CoreConnectionDelegate {
    func didInternetConnect() {
        setupPresenter()
    }
    
    func didInternetDisconnect() {
        guard let presenter = signInPresenter else{ return }
        presenter.destroy()
        presenter.detachView()
    }
}

extension SignInController: UITextFieldDelegate {
    
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
