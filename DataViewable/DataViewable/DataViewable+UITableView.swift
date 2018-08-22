//
//  DataViewable+UITableView.swift
//  DataViewable
//
//  Created by Ian MacCallum on 7/31/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import UIKit

private var kShouldDisplayOverHeader = "shouldDisplayOverHeader"

public extension DataViewable where Self: UITableView {

    public var shouldDisplayDataViewableOverHeader: Bool {
        get {
            return objc_getAssociatedObject(self, &kShouldDisplayOverHeader) as? Bool ?? true
        }
        set {
            if shouldDisplayDataViewableOverHeader != newValue {
                objc_setAssociatedObject(self, &kShouldDisplayOverHeader, newValue, .OBJC_ASSOCIATION_RETAIN)
                reloadEmptyDataSet()
            }
        }
    }

    public var hasData: Bool {
        // Get the item count
        let itemCount = (0..<numberOfSections).reduce(0) {
            $0 + numberOfRows(inSection: $1)
        }
        
        return itemCount > 0
    }

    public func addEmptyView(_ emptyView: UIView, to containerView: UIView) {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false

        if emptyView.superview == nil {
            containerView.addSubview(emptyView)
        } else {
            emptyView.removeConstraints(emptyView.constraints)
        }

        let topConstraint: NSLayoutConstraint

        if let headerView = tableHeaderView, !shouldDisplayDataViewableOverHeader {
            topConstraint = headerView.bottomAnchor.constraint(equalTo: emptyView.topAnchor)
        } else {
            topConstraint = frameLayoutGuide.topAnchor.constraint(equalTo: emptyView.topAnchor)
        }

        let viewSideConstraints = [
            topConstraint,
            frameLayoutGuide.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor),
            frameLayoutGuide.leftAnchor.constraint(equalTo: emptyView.leftAnchor),
            frameLayoutGuide.rightAnchor.constraint(equalTo: emptyView.rightAnchor)
        ]

        containerView.addConstraints(viewSideConstraints)
        containerView.layoutIfNeeded()
    }
}
