import WidgetKit
import SwiftUI
import ActivityKit

struct AuraPlayerWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MusicLiveActivityAttributes.self) { context in
            // Экран блокировки
            LockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "music.note")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.isPlaying ? "Играет" : "Пауза")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 4) {
                        Text(context.attributes.title)
                            .font(.headline)
                            .lineLimit(1)
                        ProgressView(value: context.state.elapsed, total: max(context.state.duration, 1))
                            .tint(.white)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                    }
                }
            } compactLeading: {
                Image(systemName: context.state.isPlaying ? "waveform" : "pause.fill")
                    .foregroundStyle(.white)
            } compactTrailing: {
                Text(timeString(context.state.elapsed))
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.7))
            } minimal: {
                Image(systemName: "music.note")
                    .foregroundStyle(.white)
            }
            .keylineTint(.accentColor)
        }
    }
    
    private func timeString(_ t: TimeInterval) -> String {
        let m = Int(t) / 60
        let s = Int(t) % 60
        return String(format: "%d:%02d", m, s)
    }
}

struct LockScreenView: View {
    let context: ActivityViewContext<MusicLiveActivityAttributes>
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "music.note")
                    .font(.title2)
                Text(context.attributes.title)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
            }
            ProgressView(value: context.state.elapsed, total: max(context.state.duration, 1))
                .tint(.white)
            HStack {
                Text(timeString(context.state.elapsed))
                Spacer()
                Text(timeString(context.state.duration))
            }
            .font(.caption2.monospacedDigit())
            .foregroundStyle(.secondary)
        }
        .padding()
        .activityBackgroundTint(Color.black.opacity(0.7))
        .activitySystemActionForegroundColor(.white)
    }
    
    private func timeString(_ t: TimeInterval) -> String {
        let m = Int(t) / 60
        let s = Int(t) % 60
        return String(format: "%d:%02d", m, s)
    }
}
