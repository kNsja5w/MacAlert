import SwiftUI
import IOKit.ps
import AVFoundation
import Combine

class PowerStateViewModel: ObservableObject {
    @Published var isPowerConnected = true
    @Published var isPowerAdapterConnected = true
    var audioPlayer: AVAudioPlayer!
    @Published var showUnplugConfirmation = false
    var unpluggedIntentionally = false

    private var cancellables: Set<AnyCancellable> = []

    init() {
        setupAudioPlayer()
        registerForPowerNotifications()
        startPowerCheckTimer()
        updatePowerState()
    }

    func setupAudioPlayer() {
        if let soundURL = Bundle.main.url(forResource: "Alarm", withExtension: "aiff") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer.prepareToPlay()
                audioPlayer.numberOfLoops = -1 // Continuous looping
            } catch {
                print("Failed to load the sound file: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found.")
        }
    }

    func registerForPowerNotifications() {
        NotificationCenter.default.publisher(for: NSWorkspace.didWakeNotification)
            .merge(with: NotificationCenter.default.publisher(for: NSWorkspace.willSleepNotification))
            .sink(receiveValue: { _ in
                DispatchQueue.main.async {
                    self.updatePowerState()
                }
            })
            .store(in: &cancellables)
    }

    func startPowerCheckTimer() {
        Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { _ in
                DispatchQueue.main.async {
                    self.updatePowerState()
                }
            })
            .store(in: &cancellables)
    }

    func updatePowerState() {
        DispatchQueue.main.async {
            self.isPowerConnected = self.isPowerCableConnected()
            self.isPowerAdapterConnected = self.checkPowerAdapterConnection()

            if !self.isPowerAdapterConnected && !self.unpluggedIntentionally {
                self.showUnplugConfirmation = true

                let soundDelay: TimeInterval = 10.0

                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + soundDelay) {
                    if self.showUnplugConfirmation && !self.unpluggedIntentionally {
                        self.playSound()
                        self.hideUnplugConfirmation()
                    }
                }
            } else {
                self.hideUnplugConfirmation()
                self.stopSound()
            }
        }
    }

    func isPowerCableConnected() -> Bool {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

        for source in sources {
            let description = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as NSDictionary?
            if let isCharging = description?[kIOPSIsChargingKey] as? Bool {
                if isCharging {
                    return true
                }
            }
        }
        return false
    }

    func checkPowerAdapterConnection() -> Bool {
        let adapterBlob = IOPSCopyExternalPowerAdapterDetails()?.takeRetainedValue()
        return adapterBlob != nil
    }

    func playSound() {
        if !audioPlayer.isPlaying {
            audioPlayer.play()
        }
    }

    func stopSound() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }

    func hideUnplugConfirmation() {
        showUnplugConfirmation = false
    }

    func confirmUnpluggedIntentionally() {
        hideUnplugConfirmation()
        unpluggedIntentionally = true
    }
}

struct ContentView: View {
    @StateObject private var viewModel = PowerStateViewModel()
    @State private var isSoundPlaying = false

    var body: some View {
        VStack {
            if viewModel.isPowerAdapterConnected {
                Text("Power Adapter Connected")
                    .font(.title)
                    .padding()
            } else {
                Text("Power Adapter Disconnected")
                    .font(.title)
                    .padding()
            }

            Button(action: {
                if viewModel.isPowerAdapterConnected {
                    viewModel.confirmUnpluggedIntentionally()
                } else {
                    isSoundPlaying.toggle()

                    if isSoundPlaying {
                        viewModel.playSound()
                    } else {
                        viewModel.stopSound()
                    }
                }
            }) {
                Text(isSoundPlaying ? "Stop Sound" : "Play Sound")
                    .font(.title2)
            }
        }
        .alert(isPresented: $viewModel.showUnplugConfirmation) {
            Alert(
                title: Text("Power Unplugged"),
                message: Text("Did you unplug the power intentionally?"),
                primaryButton: .default(Text("Yes"), action: {
                    viewModel.confirmUnpluggedIntentionally()
                }),
                secondaryButton: .cancel()
            )
        }
    }
}
