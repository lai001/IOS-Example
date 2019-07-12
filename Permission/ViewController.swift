import UIKit
import Foundation
import AVFoundation
import Photos
import CoreLocation
import Intents
import EventKit
import MediaPlayer
import Speech
import Contacts
import AddressBook
import CoreBluetooth
import CoreMotion

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Photos
        PHPhotoLibrary.requestAuthorization { _ in
            let status = PHPhotoLibrary.authorizationStatus()
            if case status = PHAuthorizationStatus.authorized {
                
            } else {
                
            }
        }
        
        // Microphone
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            let status = AVAudioSession.sharedInstance().recordPermission
            if case status = AVAudioSession.RecordPermission.granted {
                
            } else {
                
            }
        }
        
        // Camera
        AVCaptureDevice.requestAccess(for: .video) { _ in
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if case status = AVAuthorizationStatus.authorized {
                
            } else {
                
            }
        }
        
        // Siri
        if #available(iOS 10.0, *) {
            INPreferences.requestSiriAuthorization { _ in
                let status = INPreferences.siriAuthorizationStatus()
                if case status = INSiriAuthorizationStatus.authorized {
                    
                } else {
                    
                }
            }
        }
        
        // Reminders
        EKEventStore().requestAccess(to: .reminder) { (_, error) in
            let status = EKEventStore.authorizationStatus(for: .reminder)
        }
        
        // Calendars
        EKEventStore().requestAccess(to: .event) { (_, error) in
            let status = EKEventStore.authorizationStatus(for: .event)
        }
        
        // Apple Music
        if #available(iOS 9.3, *) {
            MPMediaLibrary.requestAuthorization { _ in
                let status = MPMediaLibrary.authorizationStatus()
                print(status)
                if case status = MPMediaLibraryAuthorizationStatus.authorized {
                    
                } else {
                    
                }
            }
        }
        
        // Location
        CLLocationManager.authorizationStatus()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        
        // SpeechRecognizer
        if #available(iOS 10.0, *) {
            SFSpeechRecognizer.requestAuthorization { _ in
                let status = SFSpeechRecognizer.authorizationStatus()
                if case status = SFSpeechRecognizer.authorizationStatus() {
                    
                } else {
                    
                }
                
            }
        }
        
        // Contacts
        if #available(iOS 9.0, *) {
            CNContactStore().requestAccess(for: .contacts) { (_, error) in
                let status = CNContactStore.authorizationStatus(for: .contacts)
                if case status = CNAuthorizationStatus.authorized {
                    
                } else {
                    
                }
            }
        } else {
            ABAddressBookRequestAccessWithCompletion(nil) { (_, error) in
                let status = ABAddressBookGetAuthorizationStatus()
                if case status = ABAuthorizationStatus.authorized {
                    
                } else {
                    
                }
            }
        }
        
        // Peripheral
        let peripheralManagerDispatchQueue = DispatchQueue(label: "CBPeripheralManager")
        let peripheral = CBPeripheralManager(delegate: self, queue: peripheralManagerDispatchQueue, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
        
        peripheral.startAdvertising(nil)
        peripheral.stopAdvertising()
        
        let status = CBPeripheralManager.authorizationStatus()
        
        switch peripheral.state {
        case .poweredOff:
            break
            
        case .poweredOn:
            break
            
        case .resetting:
            break
            
        case .unauthorized:
            break
            
        case .unsupported:
            break
            
        case .unknown:
            break
        }
        
        // Motion
        let motionManager = CMMotionActivityManager()
        let queue = OperationQueue()
        queue.name = "CMMotionActivityManager"
        queue.qualityOfService = .background
        let semaphore = DispatchSemaphore(value: 0)
        motionManager.queryActivityStarting(from: Date(), to: Date(), to: queue) { (motionActivities, error) in
            if let nsError = (error as NSError?) {
                let cmError = CMError(rawValue: UInt32(nsError.code))
                
                switch cmError {
                case CMErrorNULL:
                    break
                case CMErrorDeviceRequiresMovement:
                    break
                case CMErrorTrueNorthNotAvailable:
                    break
                case CMErrorUnknown:
                    break
                case CMErrorMotionActivityNotAvailable:
                    break
                case CMErrorMotionActivityNotAuthorized:
                    break
                case CMErrorMotionActivityNotEntitled:
                    break
                case CMErrorInvalidParameter:
                    break
                case CMErrorInvalidAction:
                    break
                case CMErrorNotEntitled:
                    break
                case CMErrorNotAvailable:
                    break
                case CMErrorNotAuthorized:
                    break
                    
                default:
                    break
                    
                }
            }
            motionManager.stopActivityUpdates()
            semaphore.signal()
        }
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
    }
    
}

extension ViewController {
    func setting() {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:  "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
            if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(settingURL)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Location
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}


// MARK: - Peripheral
extension ViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
}
