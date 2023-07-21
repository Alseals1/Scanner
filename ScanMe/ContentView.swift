import SwiftUI


struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        switch vm.dataScannerAccerStatus {
            case .scannerAvailable:
                Text("Scanner is Available")
            case .cameraNotAvailable:
                Text("Your device dousen't support a camera")
            case .ScannerNotAvailable:
                Text("Your device dousen't support a barcode")
            case .cameraAccessNotGranted:
                Text("Please go to your Setting a access permission to use camera")
            case .notDetermined:
                Text("Request camera access")
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
