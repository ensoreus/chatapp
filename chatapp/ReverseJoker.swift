//
//  ViewController.swift
//  chatapp
//
//  Created by Philipp Maluta on 26.01.2024.
//

import Foundation

class ReverseJoker: Contact {
    override func send(text: String) {
        channel?.broadcast(text: text, sender: self)
    }

    override func receive(text: String, sender: Contact) {
        send(text: String(text.reversed()))
    }
}
