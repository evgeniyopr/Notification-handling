//
//  Notifications.swift
//  NotificationHandling
//
//  Created by Evgeniy Opryshko on 31.03.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
	
	let notificationCenter = UNUserNotificationCenter.current()
	
	func requestAuthorization() {
		
		notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { granted, error in
			
			print(granted)
			
			guard granted else { return }
			
			self.getNotificationSettings()
		})
	}
	
	func getNotificationSettings() {
		
		notificationCenter.getNotificationSettings(completionHandler: { settings in
			
			print(settings)
		})
	}
	
	func scheduleNotification(notificationType: String) {
		
		let identifier = "Local Notification"
		let userAction = "User Action"
		
		let content = UNMutableNotificationContent()
		content.title = notificationType
		content.body = "This is example how to create " + notificationType
		content.sound = UNNotificationSound.default
		content.badge = 1
		content.categoryIdentifier = userAction
		
		if let stringPath = Bundle.main.path(forResource: "cat", ofType: "png") {
			
			let url = URL(fileURLWithPath: stringPath)
			
			if let attachment = try? UNNotificationAttachment(identifier: "cat", url: url, options: nil) {
				content.attachments = [attachment]
			}
		}
		
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
		
		notificationCenter.add(request) { error in
			print(error.debugDescription)
		}
		
		let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
		let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
		
		let category = UNNotificationCategory(identifier: userAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
		
		notificationCenter.setNotificationCategories([category])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
		
		completionHandler([.alert, .sound])
	}
	
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		if response.notification.request.identifier == "Local Notification" {
			print("Local Notification")
		}
		
		switch response.actionIdentifier {
		case UNNotificationDismissActionIdentifier:
			print("Dismiss Action")
		case UNNotificationDefaultActionIdentifier:
			print("Default Action")
		case "Snooze":
			print("Snooze Action")
			scheduleNotification(notificationType: "Reminder")
		case "Delete":
			print("Delete Action")
		default:
			print("Default")
		}
		
		completionHandler()
	}
}
