//
//  CollectionViewCell.swift
//  chatapp
//
//  Created by Philipp Maluta on 26.01.2024.
//

import UIKit

enum MessageDirection {
    case input
    case output
}

struct Message {
    let direction: MessageDirection
    let text: String
}

class ChatMessageViewCell: UICollectionViewCell {
    static let identifier = "outputMessageCell"
    private var messageModel: Message?
    
    @IBOutlet weak var leadingInset: NSLayoutConstraint!
    @IBOutlet weak var trailingInset: NSLayoutConstraint!

    @IBOutlet private weak var messageTextView: UITextView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupCell(with model: Message) {
        messageModel = model
        messageTextView.text = model.text
        messageTextView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        if model.direction == .output {
            styleAsOutput()
        } else {
            styleAsInput()
        }

        messageTextView.layer.maskedCorners = model.direction == .output ?
        [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner] :
        [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func styleAsOutput() {
        messageTextView.textColor = .white
        messageTextView.backgroundColor = .black
        leadingInset.constant = bounds.width * 0.3
        trailingInset.constant = 0
    }

    private func styleAsInput() {
        messageTextView.textColor = .black
        messageTextView.backgroundColor = .white
        leadingInset.constant = 0
        trailingInset.constant = bounds.width * 0.3
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: bounds.width * 0.7, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize,
                                                                          withHorizontalFittingPriority: .required,
                                                                          verticalFittingPriority: .defaultLow)
        return layoutAttributes
     }
}
