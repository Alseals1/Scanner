//
//  AppViewModel.swift
//  ScanMe
//
//  Created by Alandis Seals on 7/21/23.
//

import AVKit
import Foundation
import SwiftUI
import VisionKit

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case ScannerNotAvailable
}


@MainActor
final class AppViewModel: ObservableObject {
    
    @Published var dataScannerAccerStatus: DataScannerAccessStatusType = .notDetermined
    
    private var isScannerAvalable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccerStatus = .cameraNotAvailable
            return
        }
        
        // Asking Permission To Camera Access
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                dataScannerAccerStatus = isScannerAvalable ? .scannerAvailable : .ScannerNotAvailable
                
            case .restricted, .denied:
                dataScannerAccerStatus = .cameraAccessNotGranted
                
            case .notDetermined:
                let granted = await AVCaptureDevice.requestAccess(for: .video)
                if granted {
                    dataScannerAccerStatus = isScannerAvalable ? .scannerAvailable : .ScannerNotAvailable
                } else {
                    dataScannerAccerStatus = .cameraAccessNotGranted
                }
                
            default: break
                
        }
    }
    
    
    
}
