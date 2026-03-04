//
//  StoryViewController.swift
//  Fluffbotics
//
//  Created by Equipp on 15/12/25.
//

import UIKit
class StoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var storycollRef: UICollectionView!
    
    var imgArr = ["map.png","lion.png","dinosaur.png","fairytale.png","magnifying-glass.png","ocean.png","microscope.png","rocket.png"]
    
    var titleArr = ["Adventure Quest","Animal Kingdom","Dinosaur Wolrd ","Fairy Tale Magic","Mystery Detective","Ocean Adventures","Science Lab","Space Explorer"]
    
    var descriptionArr = ["Embark on exciting adventures with brave heroes, magical creatures, and epic quests!",
                          "Learn about amazing animals, their habitats, and the importance of nature!",
                          "Travel back in time to learn about dinosaurs and prehistoric adventures!",
                          "Enter enchanted forests, meet magical beings, and experience classic fairy tale wonder!",
                          "Solve puzzles, find clues, and become a detective solving exciting mysteries!",
                          "Dive deep into the ocean to meet sea creatures and explore underwater wonders!",
                          "Conduct fun experiments, discover how things work, and become a junior scientist!",
                          "Discover distant planets, meet alien friends, and learn about the wonders of space!"]
    
    var tag1Arr = ["Exploration","Nature","History","Magic","Problem Solving","Marine Life","STEM","Science"]
    var tag2Arr = ["Bravery","Animals","Paleontology","Fantasy","Logic","Exploration","Experiments","Discovery"]
    var tag3Arr = ["Friendship","Conservation","Adventure","Good vs Evil","Adventure","Environment","Learning","Imagination"]
    
    var recommendArr = ["Recommended for ages 5-10",
                        "Recommended for ages 4-10",
                        "Recommended for ages 5-10",
                        "Recommended for ages 4-9",
                        "Recommended for ages 7-12",
                        "Recommended for ages 5-10",
                        "Recommended for ages 7-12",
                        "Recommended for ages 7-12"]
    
    var selectedIndexPath: IndexPath?
    let selectedStoryKey = "SelectedStoryIndex"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedIndex = UserDefaults.standard.integer(forKey: selectedStoryKey)
        if savedIndex >= 0 && savedIndex < imgArr.count {
            selectedIndexPath = IndexPath(row: savedIndex, section: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoryCell
        cell.titleimgRef.image = UIImage(named: imgArr[indexPath.row])
        cell.titleLblRef.text = titleArr[indexPath.row]
        cell.desctitleLblRef.text = descriptionArr[indexPath.row]
        cell.tagLbl1Ref.text = tag1Arr[indexPath.row]
        cell.tabLbl2Ref.text = tag2Arr[indexPath.row]
        cell.tagLbl3Ref.text = tag3Arr[indexPath.row]
        cell.ageLblRef.text = recommendArr[indexPath.row]
        cell.cellViewRef.layer.borderWidth = 1.0
        cell.cellViewRef.layer.cornerRadius = 10
        cell.cellViewRef.clipsToBounds = true
        
        let isSelected = indexPath == selectedIndexPath
        cell.activeLblRef.isHidden = !isSelected
        cell.selectimg1Ref.isHidden = !isSelected
        cell.selectImgRef.isHidden = !isSelected
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        
        UserDefaults.standard.set(indexPath.row, forKey: selectedStoryKey)
        
        var reloadIndexPaths = [indexPath]
        if let previous = previousIndexPath {
            reloadIndexPaths.append(previous)
        }
        
        collectionView.reloadItems(at: reloadIndexPaths)
        
    }

}
