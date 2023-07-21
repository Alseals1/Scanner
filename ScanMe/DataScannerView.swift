import Foundation
import SwiftUI
import VisionKit

struct DataScannerView: UIViewControllerRepresentable {
    @Binding var recognizedItems: [RecognizedItem]
    let reconizedDataType: DataScannerViewController.RecognizedDataType
    let reconizesMultipleItem: Bool
    
    //DataScannerViewController is an object that scans the camera live video for text, data in text and machine- readable codes
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
        let vc = DataScannerViewController(
            recognizedDataTypes: [reconizedDataType],
            qualityLevel: .accurate,
            recognizesMultipleItems: reconizesMultipleItem,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return vc
        
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        
        //This will start scanning for the view controller
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems)
    }
    
    
    /*
     Creating this class to make sure we conforming
     to delegate of this DataScannerViewController
     so we can recieve the callback when the item
     are being reconized or removed from the frame
     or updated
     
     Or when the user click on the reconizedItem
     */
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var recognizedItems: [RecognizedItem]
        init(recognizedItems: Binding<[RecognizedItem]>) {
            self._recognizedItems = recognizedItems
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            print("Did Tap on \(item)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            recognizedItems.append(contentsOf: addedItems)
            
            print("Did add Item \(addedItems)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            
            //Where only filtering the item thats not contain within this remove item array
            // If it is contain in this remove item array where going to remove it from this recognized item array
            self.recognizedItems = recognizedItems.filter { item in
                !removedItems.contains(where: { $0.id == item.id })
            }
            
            print("Did remove Item \(removedItems)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("Became unavailable with error \(error)")
        }
    }
    
}
