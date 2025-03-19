//
//  With.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 19/3/25.
//

import Foundation

public protocol With {}

public extension With where Self: Any {
    @discardableResult
    func with(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: With {}
