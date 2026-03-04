//
//  MemoryViewController.swift
//  Fluffbotics
//
//  Created by Equipp on 17/12/25.
//

import UIKit

class MemoryViewController: UIViewController {

    @IBOutlet weak var memoryTlbRef: UITableView!
    @IBOutlet weak var fliterTxtRef: UITextField!
    @IBOutlet weak var sortTxtRef: UITextField!
    @IBOutlet weak var totalmemoryLblRef: UILabel!
    @IBOutlet weak var perferenceLblRef: UILabel!
    @IBOutlet weak var xperienceLblRef: UILabel!
    @IBOutlet weak var importantLblRef: UILabel!
    @IBOutlet weak var nomemoryLblRef: UILabel!
    @IBOutlet weak var descLblRef: UILabel!
    
    var filterArr = ["All Types",
                     "Preferences",
                     "Facts",
                     "Experiences",
                     "Relationship",
                     "Skills",
                     "Others"]
    
    var sortArr = ["Most Recent",
                   "Important",
                   "Recent Used"]
    
    let pickerView = UIPickerView()
    weak var activeTextField: UITextField?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.memoryTlbRef.isHidden = true
        self.nomemoryLblRef.isHidden = false
        self.descLblRef.isHidden = false
        self.memoryTlbRef.dataSource = self
        self.memoryTlbRef.delegate = self
        
        setupPicker(for: fliterTxtRef)
        setupPicker(for: sortTxtRef)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        addDoneToolbar()
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
        
        fliterTxtRef.inputAccessoryView = toolbar
        sortTxtRef.inputAccessoryView = toolbar
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
    }
    
    
    
    @IBAction func backBtnAtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension MemoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {

        if activeTextField == fliterTxtRef {
            return filterArr.count
        } else if activeTextField == sortTxtRef {
            return sortArr.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {

        if activeTextField == fliterTxtRef {
            return "\(filterArr[row])"
        } else if activeTextField == sortTxtRef {
            return sortArr[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {

        if activeTextField == fliterTxtRef {
            fliterTxtRef.text = "\(filterArr[row])"
            
            if fliterTxtRef.text == "All Types" {
                self.nomemoryLblRef.text = "No Memories Yet"
                self.descLblRef.text = "Fluffbotics will create memories as it learns about your child through conversations."
            }else if fliterTxtRef.text == "Preferences" {
                self.nomemoryLblRef.text = "No preference memories found"
                self.descLblRef.text = "Try changing the filter to see other types of memories."
            }else if fliterTxtRef.text == "Facts" {
                self.nomemoryLblRef.text = "No fact memories found"
                self.descLblRef.text = "Try changing the filter to see other types of memories."
            }else if fliterTxtRef.text == "Experiences" {
                self.nomemoryLblRef.text = "No experience memories found"
                self.descLblRef.text = "Try changing the filter to see other types of memories."
            }else if fliterTxtRef.text == "Relationship" {
                self.nomemoryLblRef.text = "No relationship memories found"
                self.descLblRef.text = "Try changing the filter to see other types of memories."
            }else if fliterTxtRef.text == "Skills" {
                self.nomemoryLblRef.text = "No skill memories found"
                self.descLblRef.text = "Try changing the filter to see other types of memories."
            }else if fliterTxtRef.text == "Others" {
                self.nomemoryLblRef.text = "No other memories found"
                self.descLblRef.text = "Try changing the filter to see other types of memories."
            }
            
        } else if activeTextField == sortTxtRef {
            sortTxtRef.text = sortArr[row]
        }
    }
    
}

extension MemoryViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        pickerView.reloadAllComponents()
    }
}

extension MemoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemoryCell
        return cell
        
    }
}
