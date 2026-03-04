//
//  conversationTableCell.swift
//  Fluffbotics
//
//  Created by Equipp on 16/12/25.
//

import UIKit

class conversationTableCell: UITableViewCell {
    
    @IBOutlet weak var bubbleViewRef: UIView!
    @IBOutlet weak var messageLblRef: UILabel!
    @IBOutlet weak var moreBtnRef: UIButton!
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    var moreButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        bubbleViewRef.layer.cornerRadius = 16
        bubbleViewRef.clipsToBounds = true
        messageLblRef.numberOfLines = 0
        moreBtnRef.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        bubbleViewRef.translatesAutoresizingMaskIntoConstraints = false
        messageLblRef.translatesAutoresizingMaskIntoConstraints = false
        moreBtnRef.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = bubbleViewRef.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16)
        trailingConstraint = bubbleViewRef.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16)
        
        NSLayoutConstraint.activate([
            bubbleViewRef.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleViewRef.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleViewRef.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor,multiplier: 0.75)
        ])
        
        // Message label
        NSLayoutConstraint.activate([
            messageLblRef.topAnchor.constraint(equalTo: bubbleViewRef.topAnchor, constant: 12),
            messageLblRef.leadingAnchor.constraint(equalTo: bubbleViewRef.leadingAnchor, constant: 12),
            messageLblRef.trailingAnchor.constraint(equalTo: bubbleViewRef.trailingAnchor, constant: -12),
            messageLblRef.bottomAnchor.constraint(lessThanOrEqualTo: moreBtnRef.topAnchor,constant: -4)
        ])
        
        // More button
        NSLayoutConstraint.activate([
            moreBtnRef.trailingAnchor.constraint(equalTo: bubbleViewRef.trailingAnchor, constant: -12),
            moreBtnRef.bottomAnchor.constraint(equalTo: bubbleViewRef.bottomAnchor, constant: -8),
            moreBtnRef.topAnchor.constraint(greaterThanOrEqualTo: messageLblRef.bottomAnchor,constant: 4),
            moreBtnRef.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func configure(with message: Message) {

            leadingConstraint.isActive = false
            trailingConstraint.isActive = false

            messageLblRef.text = message.text
            messageLblRef.numberOfLines = message.isExpanded ? 0 : 5

            if message.shouldShowMore {
                moreBtnRef.isHidden = false
                moreBtnRef.setTitle(message.isExpanded ? "Less" : "More", for: .normal)
            } else {
                moreBtnRef.isHidden = true
            }

            if message.sender == .user {
                trailingConstraint.isActive = true
                bubbleViewRef.backgroundColor = .systemBlue
                messageLblRef.textColor = .white
                moreBtnRef.setTitleColor(.white, for: .normal)
            } else {
                leadingConstraint.isActive = true
                bubbleViewRef.backgroundColor = .systemGray5
                messageLblRef.textColor = .black
                moreBtnRef.setTitleColor(.systemBlue, for: .normal)
            }
        }
    
    @objc func moreTapped() {
        moreButtonAction?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        messageLblRef.text = nil
        moreBtnRef.isHidden = true
        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
