//
//  CreateListLayout.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import UIKit

#warning("TODO: replace made up dimensions with better estimates")
func createListLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(100)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(300)
    )
    let group = NSCollectionLayoutGroup.vertical(
        layoutSize: groupSize,
        subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)

    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
}
