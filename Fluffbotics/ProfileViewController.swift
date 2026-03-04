//
//  ProfileViewController.swift
//  Fluffbotics
//
//  Created by Equipp on 17/12/25.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImgRef: UIImageView!
    @IBOutlet weak var nameLblRef: UILabel!
    @IBOutlet weak var emailLblRef: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadProfileData()
        nameLblRef.layer.borderWidth = 1.0
        nameLblRef.layer.borderColor = UIColor.white.cgColor
        emailLblRef.layer.borderWidth = 1.0
        emailLblRef.layer.borderColor = UIColor.white.cgColor
    }
    private func setupUI() {
        profileImgRef.layer.cornerRadius = profileImgRef.frame.size.width / 2
        profileImgRef.clipsToBounds = true
        profileImgRef.contentMode = .scaleAspectFill
    }
    
    private func loadProfileData() {
        nameLblRef.text = UserDefaults.standard.string(forKey: "userName")
        emailLblRef.text = UserDefaults.standard.string(forKey: "userEmail")
        if let imageData = UserDefaults.standard.data(forKey: "localProfileImage") {
            profileImgRef.image = UIImage(data: imageData)
            return
        }
        if let imageURLString = UserDefaults.standard.string(forKey: "userProfilePic"),
           let url = URL(string: imageURLString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.profileImgRef.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    
    @IBAction func logoutBtnAtn(_ sender: Any) {
        showLogoutAlert()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Logout",message: "Are you sure you want to logout?",preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.performLogout()
        }
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        present(alert, animated: true)
    }
    
    private func performLogout() {
        GIDSignIn.sharedInstance.signOut()
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userProfilePic")
        UserDefaults.standard.removeObject(forKey: "localProfileImage")
        
        (UIApplication.shared.delegate as? AppDelegate)?.showLogin()
    }

    @IBAction func cameraBtnAtn(_ sender: Any) {
        let alert = UIAlertController(title: "Profile Picture",message: "Choose an option",preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                self.openImagePicker(sourceType: .camera)
            })
        }
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            profileImgRef.image = image
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(imageData, forKey: "localProfileImage")
            }
        }
        picker.dismiss(animated: true)
    }

    
}

