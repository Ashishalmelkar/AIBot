//
//  ChildProfileViewController.swift
//  Fluffbotics
//
//  Created by Equipp on 15/12/25.
//

import UIKit

class ChildProfileViewController: UIViewController {
    
    @IBOutlet weak var childnameTxtRef: UITextField!
    @IBOutlet weak var ageTxtRef: UITextField!
    @IBOutlet weak var genderTxtRef: UITextField!
    @IBOutlet weak var storyTxtRef: UITextField!
    @IBOutlet weak var saveBtnRef: UIButton!
    
    let ages = Array(3...15)
    let genders = ["Boy", "Girl", "Other", "Perfer not to say"]
    let stories = [
        "Adventure Quest",
        "Animal Kingdom",
        "Dinosaur World",
        "Fairy Tale Magic",
        "Mystery Detective",
        "Ocean Adventures",
        "Science Lab",
        "Space Explorer"
    ]
    
    let pickerView = UIPickerView()
    weak var activeTextField: UITextField?
    
    let childNameKey = "childName"
    let childAgeKey = "childAge"
    let childGenderKey = "childGender"
    let childStoryKey = "childStory"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPicker(for: ageTxtRef)
        setupPicker(for: genderTxtRef)
        setupPicker(for: storyTxtRef)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        addDoneToolbar()
        restoreSavedData()
        
        
    }
    
    func setupPicker(for textField: UITextField) {
        textField.delegate = self
        textField.inputView = pickerView
    }
    
    func addDoneToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        
        toolbar.items = [done]
        
        ageTxtRef.inputAccessoryView = toolbar
        genderTxtRef.inputAccessoryView = toolbar
        storyTxtRef.inputAccessoryView = toolbar
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
    }
    
    @IBAction func saveBtnAtn(_ sender: Any) {
        view.endEditing(true)
        guard
            let name = childnameTxtRef.text, !name.isEmpty,
            let age = ageTxtRef.text, !age.isEmpty,
            let gender = genderTxtRef.text, !gender.isEmpty,
            let story = storyTxtRef.text, !story.isEmpty
        else {
            showAlert(message: "Please fill all fields")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: childNameKey)
        defaults.set(age, forKey: childAgeKey)
        defaults.set(gender, forKey: childGenderKey)
        defaults.set(story, forKey: childStoryKey)
        
        showAlert(message: "Profile saved successfully!")
    }
    
    func restoreSavedData() {
        let defaults = UserDefaults.standard
        childnameTxtRef.text = defaults.string(forKey: childNameKey)
        ageTxtRef.text = defaults.string(forKey: childAgeKey)
        genderTxtRef.text = defaults.string(forKey: childGenderKey)
        storyTxtRef.text = defaults.string(forKey: childStoryKey)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Fluffbotics",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @IBAction func instructionBtnAtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionViewController
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}

extension ChildProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {

        if activeTextField == ageTxtRef {
            return ages.count
        } else if activeTextField == genderTxtRef {
            return genders.count
        } else if activeTextField == storyTxtRef {
            return stories.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {

        if activeTextField == ageTxtRef {
            return "\(ages[row])"
        } else if activeTextField == genderTxtRef {
            return genders[row]
        } else if activeTextField == storyTxtRef {
            return stories[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {

        if activeTextField == ageTxtRef {
            ageTxtRef.text = "\(ages[row])"
        } else if activeTextField == genderTxtRef {
            genderTxtRef.text = genders[row]
        } else if activeTextField == storyTxtRef {
            storyTxtRef.text = stories[row]
        }
    }
}

extension ChildProfileViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        pickerView.reloadAllComponents()
    }
}



