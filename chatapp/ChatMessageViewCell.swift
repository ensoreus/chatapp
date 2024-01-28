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
    }

    private func styleAsOutput() {
        messageTextView.textColor = .white
        messageTextView.backgroundColor = .black
    }

    private func styleAsInput() {
        messageTextView.textColor = .black
        messageTextView.backgroundColor = .white
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)

        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)

        return layoutAttributes
     }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let model = messageModel else {
            return
        }

        messageTextView.layer.maskedCorners = model.direction == .output ?
        [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner] :
        [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]

    }
}
