//
//  MSU_WidgetsLiveActivity.swift
//  MSU Widgets
//
//  Created by Benjamin Shabowski on 10/3/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MSU_WidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MSU_WidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MSU_WidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MSU_WidgetsAttributes {
    fileprivate static var preview: MSU_WidgetsAttributes {
        MSU_WidgetsAttributes(name: "World")
    }
}

extension MSU_WidgetsAttributes.ContentState {
    fileprivate static var smiley: MSU_WidgetsAttributes.ContentState {
        MSU_WidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MSU_WidgetsAttributes.ContentState {
         MSU_WidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MSU_WidgetsAttributes.preview) {
   MSU_WidgetsLiveActivity()
} contentStates: {
    MSU_WidgetsAttributes.ContentState.smiley
    MSU_WidgetsAttributes.ContentState.starEyes
}
