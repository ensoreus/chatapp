//
//  ChatCollectionViewFlowLayout.swift
//  pheon_challenge
//
//  Created by Philipp Maluta on 23.01.2024.
//

import Foundation
import UIKit

final class ChatFlowLayout : UICollectionViewFlowLayout {
    let maxBubbleWidth = 330.0
    var messagePropertyProvider: MessagePropertiesProvider?


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        return layoutAttributesObjects
    }

    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                         withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        return true
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes,
              let messagePropertyProvider = messagePropertyProvider,
              let collectionView = self.collectionView else {
            fatalError("Wrong layout attributes class")
        }

        let messageDirection = messagePropertyProvider.messageDirection(index: indexPath.row)
        let demandedWidth = messagePropertyProvider.messageWidth(index: indexPath.row, maxWidth: maxBubbleWidth)

        let actualWidth = min(demandedWidth, maxBubbleWidth) - sectionInset.left - sectionInset.right
        layoutAttributes.frame.size.width = actualWidth
        if messageDirection == .output {
            layoutAttributes.frame.origin.x = collectionView.safeAreaLayoutGuide.layoutFrame.width - actualWidth - sectionInset.right
        } else {
            layoutAttributes.frame.origin.x = 0
        }

        return layoutAttributes
    }

    

}


