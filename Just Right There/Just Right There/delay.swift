//
//  delay.swift
//  Often
//
//  Created by Often on 10/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

//func delay(delay: Double, closure:()->()) {
//    dispatch_after(
//        dispatch_time(
//            dispatch_time_t(DispatchTime.now),
//            Int64(delay * Double(NSEC_PER_SEC))
//        ),
//        dispatch_get_main_queue(), closure)
//}

func delay(delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}
