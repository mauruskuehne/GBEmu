//
//  NotificationService.swift
//  GBEmu
//
//  Created by Maurus Kühne on 04/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class Notification {
  
}

class NotificationService {

  var receiverGroups = [NotificationReceiverBase]()
  
  func registerForNotification<T : Notification>(receiver : NotificationReceiverBase) {
    receiverGroups.append(receiver)
  }
  
  func deregisterForNotification<T : Notification>(receiver : NotificationReceiverBase) {
    
  }
  
  func publishNotification(notification : Notification) {
    
  }
  
}