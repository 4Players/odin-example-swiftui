import OdinKit
import SwiftUI

struct RoomView: View {
    @EnvironmentObject var room: OdinRoom

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(room.peers.values), id: \.self) { peer in
                    PeerView(peer)
                }
            }
            .navigationTitle(room.id)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: leaveRoom) {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: toggleInput) {
                        Image(systemName: room.localMedias.count != 0 ? "mic" : "mic.slash")
                    }
                }
            }
        }
#if os(iOS)
        .navigationViewStyle(.stack)
#endif
    }
    
    private func toggleInput() {
        var userData: PeerUserData! = OdinCustomData.decode(room.ownPeer.userData)
        
        if room.localMedias.count != 0 {
            for (handle, _) in room.localMedias {
                try? room.removeMedia(streamHandle: handle)
            }
            
            userData.inputMuted = 1
        } else {
            _ = try? room.addMedia(audioConfig: OdinAudioStreamConfig(
                sample_rate: UInt32(OdinAudio.sharedInstance().engine.inputNode.inputFormat(forBus: 0).sampleRate),
                channel_count: 1
            ))
            
            userData.inputMuted = 0
        }
        
        try? room.updatePeerUserData(userData: OdinCustomData.encode(userData))
    }
    
    private func leaveRoom() {
        try? room.leave()
    }
}
