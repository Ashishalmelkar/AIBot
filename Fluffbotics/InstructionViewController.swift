//
//  InstructionViewController.swift
//  Fluffbotics
//
//  Created by Equipp on 16/12/25.
//

import UIKit

class InstructionViewController: UIViewController {

    @IBOutlet weak var talkTxtRef: UITextField!
    @IBOutlet weak var avoidTxtRef: UITextField!
    @IBOutlet weak var talkCollectionRef: UICollectionView!
    @IBOutlet weak var avoidCollectionRef: UICollectionView!
    @IBOutlet weak var contentViewRef: UIView!
    
    
    private let talkKey = "SavedTalkList"
    private let avoidKey = "SavedAvoidList"
    private let defaultTalkArr = [
        "+ Family Treditions",
        "+ Favorite books",
        "+ Nature and animals",
        "+ Science experiments",
        "+ Art and creativity",
        "+ Music and songs",
        "+ Healthy habits",
        "+ Friendship values",
        "+ Cultural celebrations",
        "+ Problem-solving skills"
    ]

    private let defaultAvoidArr = [
        "+ Scary or violent content",
        "+ Adult topics",
        "+ Inappropriate language",
        "+ Religious discussions",
        "+ Political topics",
        "+ Commercial advertising",
        "+ Personal family information",
        "+ Stranger danger topics"
    ]
    var talkArr : [String] = []
    var avoidArr : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.talkCollectionRef.delegate = self
        self.talkCollectionRef.dataSource = self
        self.talkCollectionRef.allowsMultipleSelection = true
        
        self.avoidCollectionRef.delegate = self
        self.avoidCollectionRef.dataSource = self
        self.avoidCollectionRef.allowsMultipleSelection = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        loadSavedData()
    }
    
    @IBAction func talkBtnAtn(_ sender: Any) {
        guard let text = trimmedText(from: talkTxtRef) else { return }
        let formattedText = "+ " + text
        talkArr.append(formattedText)

        talkCollectionRef.reloadData()
        talkTxtRef.text = ""
        talkTxtRef.resignFirstResponder()
    }
    
    @IBAction func avoidBtnAtn(_ sender: Any) {
        guard let text = trimmedText(from: avoidTxtRef) else { return }
        let formattedText = "+ " + text
        avoidArr.append(formattedText)

        avoidCollectionRef.reloadData()
        avoidTxtRef.text = ""
        avoidTxtRef.resignFirstResponder()
    }
    
    @IBAction func saveBtnAtn(_ sender: Any) {
        print("Talk List:", talkArr)
        print("Avoid List:", avoidArr)
        saveData()
    }
    
    private func saveData() {
        UserDefaults.standard.set(talkArr, forKey: talkKey)
        UserDefaults.standard.set(avoidArr, forKey: avoidKey)
        print("✅ Defaults + User data saved")
    }
    
    private func loadSavedData() {
        let savedTalk = UserDefaults.standard.stringArray(forKey: talkKey)
        let savedAvoid = UserDefaults.standard.stringArray(forKey: avoidKey)
        
        if let savedTalk = savedTalk {
            talkArr = savedTalk
        } else {
            talkArr = defaultTalkArr
        }
        if let savedAvoid = savedAvoid {
            avoidArr = savedAvoid
        } else {
            avoidArr = defaultAvoidArr
        }
        
        talkCollectionRef.reloadData()
        avoidCollectionRef.reloadData()
    }
    
    
    private func trimmedText(from textField: UITextField) -> String? {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (text?.isEmpty == false) ? text : nil
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backBtnAtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension InstructionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.talkCollectionRef{
            return self.talkArr.count
        }else{
            return self.avoidArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.talkCollectionRef {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ThingsToTalkCell
            let talk = self.talkArr[indexPath.row]
            cell.titleLblRef.text = talk
            cell.titleLblRef.layer.borderWidth = 1
            cell.titleLblRef.backgroundColor = .white
            cell.titleLblRef.textColor = .black
            return cell
            
        }else if collectionView == self.avoidCollectionRef{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ThingsToAvoidCell
            let avoid = self.avoidArr[indexPath.row]
            cell.titleLblref.text = avoid
            cell.titleLblref.layer.borderWidth = 1
            cell.titleLblref.backgroundColor = .white
            cell.titleLblref.textColor = .black
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == talkCollectionRef {
            let cell = collectionView.cellForItem(at: indexPath) as! ThingsToTalkCell
            cell.titleLblRef.backgroundColor = UIColor.instructionSelected
            cell.titleLblRef.textColor = .white
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! ThingsToAvoidCell
            cell.titleLblref.backgroundColor = UIColor.instructionSelected
            cell.titleLblref.textColor = .white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == talkCollectionRef {
            let cell = collectionView.cellForItem(at: indexPath) as! ThingsToTalkCell
            cell.titleLblRef.backgroundColor = .white
            cell.titleLblRef.textColor = .black
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! ThingsToAvoidCell
            cell.titleLblref.backgroundColor = .white
            cell.titleLblref.textColor = .black
        }
    }
}

extension UIColor {
    static let instructionSelected = UIColor(
        red: 103/255,
        green: 95/255,
        blue: 170/255,
        alpha: 1
    )
}
