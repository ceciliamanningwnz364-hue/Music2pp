// PlayerView.swift
import SwiftUI

struct PlayerView: View {
    @ObservedObject var player = AudioPlayerManager.shared
    
    var body: some View {
        VStack(spacing: 24) {
            // «Стеклянная» карточка
            VStack(spacing: 20) {
                Image(systemName: "music.note")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                    .padding(30)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
                
                Text(player.trackTitle)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                // Прогресс
                VStack(spacing: 6) {
                    Slider(value: Binding(
                        get: { player.currentTime },
                        set: { player.seek(to: $0) }
                    ), in: 0...max(player.duration, 1))
                    .tint(.white)
                    
                    HStack {
                        Text(timeString(player.currentTime))
                        Spacer()
                        Text(timeString(player.duration))
                    }
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.6))
                }
                
                // Управление
                HStack(spacing: 40) {
                    Button { player.seek(to: max(0, player.currentTime - 15)) } label: {
                        Image(systemName: "gobackward.15").font(.title)
                    }
                    Button { player.togglePlayPause() } label: {
                        Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 64))
                    }
                    Button { player.seek(to: min(player.duration, player.currentTime + 15)) } label: {
                        Image(systemName: "goforward.15").font(.title)
                    }
                }
                .foregroundStyle(.white)
                .buttonStyle(.plain)
            }
            .padding(28)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32))
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(
                        LinearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
        }
    }
    
    private func timeString(_ t: TimeInterval) -> String {
        let m = Int(t) / 60
        let s = Int(t) % 60
        return String(format: "%d:%02d", m, s)
    }
}
