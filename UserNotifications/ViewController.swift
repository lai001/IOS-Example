//
//  ViewController.swift
//  UserNotifications
//
//  Created by lai001 on 2019/9/17.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            
            
            let content = UNMutableNotificationContent()
            content.title = "title"
            content.subtitle = "subtitle"
            content.body = "body"
            content.badge = 2
            
            UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (userNotifications) in
                
            })
            
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (userNotificationsRequest) in
                
            })
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 61, repeats: true)
            
            let request = UNNotificationRequest(identifier: "test UserNotifications", content: content, trigger: trigger)
            
            
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    
                }
            }
            
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                
                switch settings.authorizationStatus {
                case .authorized:
                    break
                case .notDetermined:
                    break
                case .denied:
                    break
                case .provisional:
                    break
                    
                default:
                    break
                }
                
                switch settings.soundSetting{
                case .enabled:
                    break
                case .disabled:
                    break
                case .notSupported:
                    break
                default:
                    break
                }
                
                switch settings.badgeSetting{
                case .enabled:
                    break
                case .disabled:
                    break
                case .notSupported:
                    break
                default:
                    break
                }
                
                switch settings.lockScreenSetting{
                case .enabled:
                    break
                case .disabled:
                    break
                case .notSupported:
                    break
                default:
                    break
                }
                
                switch settings.notificationCenterSetting{
                case .enabled:
                    break
                case .disabled:
                    break
                case .notSupported:
                    break
                default:
                    break
                }
                
                switch settings.alertSetting{
                case .enabled:
                    break
                case .disabled:
                    break
                case .notSupported:
                    break
                default:
                    break
                }
                
                switch settings.showPreviewsSetting{
                case .always:
                    break
                case .whenAuthenticated:
                    break
                case .never:
                    break
                default:
                    break
                }
                
            }
            
        }
        
    }
    
}
