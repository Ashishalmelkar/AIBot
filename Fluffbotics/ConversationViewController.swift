//
//  ConversationViewController.swift
//  Fluffbotics
//
//  Created by Equipp on 15/12/25.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet weak var conversationTlbRef: UITableView!
    
    var messages: [Message] = [
            Message(text: "Hello! How are you?", sender: .user),
            Message(
                text: "I'm good! " + String(repeating: "Lorem ipsum ", count: 200),
                sender: .bot
            ),
            Message(text: "Short reply.", sender: .user)
        ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversationTlbRef.delegate = self
        conversationTlbRef.dataSource = self
        conversationTlbRef.separatorStyle = .none
        conversationTlbRef.estimatedRowHeight = 100
        conversationTlbRef.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func memoryBtnAtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MemoryVC") as! MemoryViewController
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! conversationTableCell
        let message = messages[indexPath.row]
        cell.configure(with: message)
        cell.moreButtonAction = { [weak self] in
            guard let self = self else { return }
            self.messages[indexPath.row].isExpanded.toggle()
            UIView.animate(withDuration: 0.25) {
                self.conversationTlbRef.beginUpdates()
                self.conversationTlbRef.reloadRows(at: [indexPath], with: .automatic)
                self.conversationTlbRef.endUpdates()
            }
        }
        return cell
    }
}
