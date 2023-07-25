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


enum ScanType: String {
    case text, barcode
}

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case ScannerNotAvailable
}


@MainActor
final class AppViewModel: ObservableObject {
    
    var dataScannerViewId: Int {
        var hasher = Hasher()
        hasher.combine(scanType)
        hasher.combine(recognizesMultipleItem)
        if let textContentType {
            hasher.combine(textContentType)
        }
        return hasher.finalize()
    }
    
    @Published var dataScannerAccerStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItem: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItem = true
    
     var recognizedDataType: DataScannerViewController.RecognizedDataType {
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    
    var headerText: String {
        if recognizedItem.isEmpty {
            return "Scanning \(scanType.rawValue)"
        }else{
            return "Recogized \(recognizedItem.count) item(s)"
        }
    }
    
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
