//
//  UIScrollView+Ext.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 9/14/20.
//

import UIKit

extension UIScrollView {
	func scrollToBottom(animated: Bool) {
		if self.contentSize.height < self.bounds.height { return }
		let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height + self.contentInset.bottom)
		self.setContentOffset(bottomOffset, animated: animated)
	}
}
