//
//  NotificationReceiver.swift
//  GBEmu
//
//  Created by Maurus Kühne on 04/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

protocol NotificationReceiverBase : Any {
  
}

protocol NotificationReceiver : NotificationReceiverBase {
  
  typealias NotificationType : Notification
  
  func receiveNotification(notification : NotificationType)
}