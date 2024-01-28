//
//  ChatViewModel.swift
//  chatapp
//
//  Created by Philipp Maluta on 26.01.2024.
//

import Foundation
import UIKit

protocol ChatViewModelDelegate: AnyObject {
    func needToRefresh()
}

protocol MessagePropertiesProvider {
    func messageDirection(index: Int) -> MessageDirection
    func messageWidth(index: Int, maxWidth: CGFloat) -> CGFloat
}

class ChatViewModel: NSObject {
    weak var delegate: ChatViewModelDelegate?
    private var channel: Channel
    private var user: Contact
    var messagesFlow = [Message]()

    override init() {
        let joker = ReverseJoker(name: "Reverse Joker", owner: false)
        user = Contact(name: "User", owner: true)
        channel = Channel.establishConnection(contact: user, withContact: joker)
        super.init()
        user.delegate = self
        joker.delegate = self
    }

    func send(text: String) {
        user.send(text: text)
    }
}

extension ChatViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messagesFlow.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageViewCell.identifier, for: indexPath) as? ChatMessageViewCell else {
            fatalError("Wrong cell identifier")
        }
        cell.setupCell(with: messagesFlow[indexPath.row])
        return cell
    }
}

extension ChatViewModel: ContactChatDelegate {
    func contact(contact: Contact, receivedText: String) {
        let message = Message(direction: contact.deviceOwner ? .output : .input, text: receivedText)
        messagesFlow.append(message)
        delegate?.needToRefresh()
    }
}
