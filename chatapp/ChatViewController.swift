//
//  ChatViewController.swift
//  chatapp
//
//  Created by Philipp Maluta on 26.01.2024.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var chatView: UICollectionView!
    @IBOutlet weak var inputComponentBottomConstraint: NSLayoutConstraint!

    private var chatViewModel = ChatViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForKeyboardNotifcations()
        chatView.dataSource = chatViewModel
        chatViewModel.delegate = self
        let chatFlowLayout = ChatFlowLayout()
        chatFlowLayout.messagePropertyProvider = chatViewModel
        chatFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        chatFlowLayout.minimumInteritemSpacing = 10
        chatFlowLayout.minimumLineSpacing = 10
        chatView.collectionViewLayout = chatFlowLayout
        chatView.contentInsetAdjustmentBehavior = .always
    }

    @IBAction func onSend(_ sender: Any) {
        guard let textToSend = messageField.text else { return }
        chatViewModel.send(text: textToSend)
    }

    private func subscribeForKeyboardNotifcations() {
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShow),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillHide),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
               let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.3, delay: 0) { [weak inputComponentBottomConstraint, messageField] in
                inputComponentBottomConstraint?.constant = keyboardHeight - (messageField?.bounds.height ?? 0)
            }
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        inputComponentBottomConstraint.constant = 0
    }
}

extension ChatViewController: ChatViewModelDelegate {
    func needToRefresh() {
        chatView.reloadData()
    }
}
