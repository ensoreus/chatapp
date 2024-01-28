//
//  ViewController.swift
//  chatapp
//
//  Created by Philipp Maluta on 26.01.2024.
//

import Foundation

class ReverseJoker: Contact {
    let messagesToLoad: [String] = [
        "lorem ipsum dolor sit amet aliquid proident fuga.",
        "amet possimus fuga, propter ut. passim quam quo",
        "orem ipsum dolor sit amet enim velit laudantium.",
        "maximas vel quo satellitibus accusantium. quibusdam voluptatum dominatrix eveniet non. eos minima est corporis repellat. vero mollit odit",
        "dolore commodo. id quasi ea, tempora corporis. laborum nobis non, consequuntur humani. labore videlicet do officia",
        "lorem ipsum dolor sit amet fugit adipisicing in velit congregavit. aspernatur eius rationem, inducens utilem. unde sit libero rerum inventore",
        "lorem ipsum dolor sit amet esset reclamantes esse."
    ]

    override init(name: String, owner: Bool) {
        super.init(name: name, owner: owner)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.messagesToLoad.forEach { message in
                self?.send(text: message)
            }
        }
    }
    override func send(text: String) {
        channel?.broadcast(text: text, sender: self)
    }

    override func receive(text: String, sender: Contact) {
        send(text: String(text.reversed()))
    }


}
