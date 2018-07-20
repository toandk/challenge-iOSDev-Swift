//
//  ReactiveView.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ReactiveView {
    func bindViewModel(viewModel: AnyObject)
    @objc optional func cellHeight() -> CGFloat
    @objc optional static func cellHeight(viewModel: AnyObject?) -> CGFloat
}
