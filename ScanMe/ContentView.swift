import SwiftUI
import VisionKit


struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel
    
    private let textContenTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", .fullStreetAddress)
    ]
    
    var body: some View {
        switch vm.dataScannerAccerStatus {
            case .scannerAvailable:
               mainView
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
    
    private var mainView: some View {
    
        DataScannerView(recognizedItems: $vm.recognizedItem, reconizedDataType: vm.recognizedDataType, reconizesMultipleItem: vm.recognizesMultipleItem)
            .background(Color.black.opacity(0.5))
            .ignoresSafeArea()
            .id(vm.dataScannerViewId)
            .sheet(isPresented: .constant(true)) {
                buttonContainerView
                    .background(.ultraThinMaterial)
                    .presentationDetents([.medium, .fraction(0.25)])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled()
                    .onAppear {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let controller = windowScene.windows.first?.rootViewController?.presentedViewController else { return }
                        
                        controller.view.backgroundColor = .clear
                    }
                
            }
        .onChange(of: vm.scanType) { _ in vm.recognizedItem = [] }
        .onChange(of: vm.textContentType) { _ in vm.recognizedItem = [] }
        .onChange(of: vm.recognizesMultipleItem) { _ in vm.recognizedItem = [] }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }.pickerStyle(.segmented)
                
                Toggle("Scan multiple", isOn: $vm.recognizesMultipleItem)
            }
            
            if vm.scanType == .text {
                Picker("Text conten Type", selection: $vm.textContentType) {
                    ForEach(textContenTypes, id: \.self.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                }.pickerStyle(.segmented)
            }
            
            Text(vm.headerText)
                .padding(.top)
        }
        .padding(.horizontal)
    }
    
    private var buttonContainerView: some View {
                VStack {
                    headerView
                        .padding(.top)
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(vm.recognizedItem) { item in
                                switch item {
                                    case .barcode(let barcode):
                                        Text(barcode.payloadStringValue ?? "Unknown Barcode")
                                    case .text(let text):
                                        Text(text.transcript)
                                        
                                    @unknown default:
                                Text("Unknown")
                                }
                            }
                        }
                        .padding()
                    }
                }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
