//
//  ViewController.swift
//  NotificationHandling
//
//  Created by Evgeniy Opryshko on 31.03.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let notifications = Notifications()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		notifications.scheduleNotification(notificationType: "Test")
	}
}
