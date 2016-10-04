//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

#if os(OSX)
    import AppKit
    public typealias ALView = NSView
#elseif os(iOS)
    import UIKit
    public typealias ALView = UIView
#endif

public struct ALLayoutItem {
    public let view: ALView
    public let attribute: NSLayoutAttribute
    public let multiplier: CGFloat
    public let constant: CGFloat
    
    init(view: ALView, attribute: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
        self.view = view
        self.attribute = attribute
        self.multiplier = multiplier
        self.constant = constant
    }
    
    // relateTo(), equalTo(), greaterThanOrEqualTo(), and lessThanOrEqualTo() used to be overloaded functions
    // instead of having two separately named functions (e.g. relateTo() and relateToConstant()) but they had
    // to be renamed due to a compiler bug where the compiler chose the wrong function to call.
    //
    // Repro case: http://cl.ly/3S0a1T0Q0S1D
    // rdar://17412596, OpenRadar: http://www.openradar.me/radar?id=5275533159956480
    
    /// Builds a constraint by relating the item to another item.
    public func relateTo(_ right: ALLayoutItem, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
    }
    
    /// Builds a constraint by relating the item to a constant value.
    public func relateToConstant(_ right: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: right)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    public func equalTo(_ right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .equal)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    public func equalToConstant(_ right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .equal)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    public func greaterThanOrEqualTo(_ right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .greaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    public func greaterThanOrEqualToConstant(_ right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .greaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    public func lessThanOrEqualTo(_ right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .lessThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    public func lessThanOrEqualToConstant(_ right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .lessThanOrEqual)
    }
}

/// Multiplies the operand's multiplier by the RHS value
public func * (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier * right, constant: left.constant)
}

/// Divides the operand's multiplier by the RHS value
public func / (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier / right, constant: left.constant)
}

/// Adds the RHS value to the operand's constant
public func + (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant + right)
}

/// Subtracts the RHS value from the operand's constant
public func - (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant - right)
}

/// Equivalent to NSLayoutRelation.Equal
public func == (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.equalTo(right)
}

/// Equivalent to NSLayoutRelation.Equal
public func == (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.equalToConstant(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
public func >= (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.greaterThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
public func >= (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.greaterThanOrEqualToConstant(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
public func <= (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.lessThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
public func <= (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.lessThanOrEqualToConstant(right)
}

public extension ALView {
    func al_operand(_ attribute: NSLayoutAttribute) -> ALLayoutItem {
        return ALLayoutItem(view: self, attribute: attribute)
    }
    
    /// Equivalent to NSLayoutAttribute.Left
    var al_left: ALLayoutItem {
        return al_operand(.left)
    }
    
    /// Equivalent to NSLayoutAttribute.Right
    var al_right: ALLayoutItem {
        return al_operand(.right)
    }
    
    /// Equivalent to NSLayoutAttribute.Top
    var al_top: ALLayoutItem {
        return al_operand(.top)
    }
    
    /// Equivalent to NSLayoutAttribute.Bottom
    var al_bottom: ALLayoutItem {
        return al_operand(.bottom)
    }
    
    /// Equivalent to NSLayoutAttribute.Leading
    var al_leading: ALLayoutItem {
        return al_operand(.leading)
    }
    
    /// Equivalent to NSLayoutAttribute.Trailing
    var al_trailing: ALLayoutItem {
        return al_operand(.trailing)
    }
    
    /// Equivalent to NSLayoutAttribute.Width
    var al_width: ALLayoutItem {
        return al_operand(.width)
    }
    
    /// Equivalent to NSLayoutAttribute.Height
    var al_height: ALLayoutItem {
        return al_operand(.height)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterX
    var al_centerX: ALLayoutItem {
        return al_operand(.centerX)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterY
    var al_centerY: ALLayoutItem {
        return al_operand(.centerY)
    }
    
    /// Equivalent to NSLayoutAttribute.Baseline
    var al_baseline: ALLayoutItem {
        return al_operand(.lastBaseline)
    }
}
