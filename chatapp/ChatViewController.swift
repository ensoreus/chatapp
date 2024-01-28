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
        chatView.delegate = self
        chatViewModel.delegate = self
        chatView.collectionViewLayout = configLayout()
        chatView.contentInsetAdjustmentBehavior = .always
    }

    @IBAction func onSend(_ sender: Any) {
        guard let textToSend = messageField.text else { return }
        chatViewModel.send(text: textToSend)
        messageField.text = ""
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

    private func configLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.headerMode = .firstItemInSection

        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
}


extension ChatViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        true
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        let menuItem = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        menuItem.text = "menu item"
        let preview = UITargetedPreview(view: menuItem)
        return preview
    }
}


extension ChatViewController: ChatViewModelDelegate {
    func needToRefresh() {
        chatView.reloadData()
        chatView.scrollToItem(at: IndexPath(row: chatViewModel.messagesFlow.count - 1, section: 0), at: .bottom, animated: true)
    }
}
