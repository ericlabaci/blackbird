//
//  BaseViewController.swift
//  Blackbird
//
//  Created by Eric Labaci on 2/22/18.
//  Copyright © 2018 Blackbird. All rights reserved.
//

import UIKit
import AVKit
import Photos
import RxCocoa
import RxSwift

class BaseViewController: UIViewController {
    //MARK: - Variables
    internal let disposeBag = DisposeBag()
    
    //MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ConsoleLogger.log("Current controller: \(self)")
    }
    
    deinit {
        ConsoleLogger.log("Deinit controller: \(self)")
    }
    
    func openCamera(completion: @escaping () -> ()) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorizationStatus {
        case .authorized:
            completion()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    completion()
                }
            })
        case .restricted:
            self.present(AlertControllerUtils.getOKAlertController(code: .CameraAccessRestricted, okCompletion: nil), animated: true, completion: nil)
        case .denied:
            self.present(AlertControllerUtils.getSettingsAlertController(code: .NoCameraAccessPermission), animated: true, completion: nil)
        }
    }
    
    func openGallery(completion: @escaping () -> ()) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            completion()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    completion()
                }
            })
        case .restricted:
            self.present(AlertControllerUtils.getOKAlertController(code: .GalleryAccessRestricted, okCompletion: nil), animated: true, completion: nil)
        case .denied:
            self.present(AlertControllerUtils.getSettingsAlertController(code: .NoGalleryAccessPermission), animated: true, completion: nil)
        }
    }
}
