import OdinKit
import SwiftUI

struct PeerView: View {
    @EnvironmentObject var room: OdinRoom

    var peer: OdinPeer
    var data: PeerUserData
    
    init(_ peer: OdinPeer) {
        self.peer = peer
        self.data = OdinCustomData.decode(peer.userData) ?? PeerUserData(name: "")
    }

    var body: some View {
        HStack {
            Image(systemName: statusIcon)
                .font(.system(size: 32))
                .foregroundColor(.accentColor)

            VStack(alignment: .leading) {
                Text(displayName)
                    .font(.system(size: 16))
                    .fontWeight(room.ownPeer == peer ? .semibold : .none)

                Text(versionNumber)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    var statusIcon: String {
        if peer.medias.count == 0 {
            return "mic.slash"
        }

        if data.inputMuted != nil, data.inputMuted != 0 {
            return "mic.slash"
        }

        return peer.activeMedias.count != 0 ? "mic.fill" : "mic"
    }

    var displayName: String {
        guard data.name.count != 0 else {
            return "Unknown"
        }
        
        return data.name
    }

    var versionNumber: String {
        guard data.platform != nil, data.platform?.count != 0, data.version != nil, data.version?.count != 0 else {
            return "Unknown"
        }

        return "v\(data.version!) on \(data.platform!)"
    }
}
