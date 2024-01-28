//
//  Contact.swift
//  chatapp
//
//  Created by Philipp Maluta on 26.01.2024.
//

import Foundation

class Channel {
    class func establishConnection(contact: Contact, withContact: Contact) -> Channel {
        let channel = Channel()
        contact.channel = channel
        withContact.channel = channel
        channel.contacts = [contact, withContact]
        return channel
    }

    private var contacts = [Contact]()
    func broadcast(text: String, sender: Contact) {
        contacts.forEach { contact in
            if contact.name != sender.name {
                contact.receive(text: text, sender: sender)
            }
        }
    }
}

protocol ContactChatDelegate {
    func contact(contact:Contact, receivedText: String)
}

class Contact {
    var name: String
    var delegate: ContactChatDelegate?
    let deviceOwner: Bool
    weak var channel: Channel?

    init(name: String, owner: Bool) {
        self.name = name
        self.deviceOwner = owner
    }

    func send(text: String) {
        delegate?.contact(contact: self, receivedText: text)
        channel?.broadcast(text: text, sender: self)
    }

    func receive(text: String, sender: Contact) {
        delegate?.contact(contact: sender, receivedText: text)
    }
}
