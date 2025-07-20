//
//  DexWidgetExtension.swift
//  DexWidgetExtension
//
//  Created by Muhammed Rezk Rajab on 20/07/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry.placeholder
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        for hourOffset in 0 ..< 5 {
            let entry =  SimpleEntry.placeholder
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name:String
    let sprite: Image
    let types: [String]
    static var placeholder: SimpleEntry {
        SimpleEntry(date: .now, name: "balbasaur", sprite: Image(.bulbasaur), types: ["fire", "grass"])
    }
    static var placeholder2: SimpleEntry {
        SimpleEntry(date: .now, name: "firedragon", sprite: Image(.firedragon), types: ["fire"])
    }
}

struct DexWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var types: some View {
        HStack {
            ForEach(entry.types, id: \.self) { element in
                Text(element)
                    .padding(.horizontal,20)
                    .padding(.vertical,4)
                    .background(Color(element.capitalized))
                    .clipShape(Capsule())
                    .shadow(radius: 10)
            }
        }
    }
    var body: some View {
        if family == .systemLarge {
            Text(entry.name.capitalized)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        HStack {
            entry.sprite
                .resizable()
                .scaledToFit()
            if family == .systemMedium {
                VStack {
                    Text(entry.name.capitalized)
                        .font(.title3)
                    types
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        if family == .systemLarge {
            types
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct DexWidgetExtension: Widget {
    let kind: String = "DexWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DexWidgetExtensionEntryView(entry: entry)
                    .foregroundStyle(.black )
                    .containerBackground(Color(entry.types[0].capitalized), for: .widget)
            } else {
                DexWidgetExtensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Pokemon")
        .description("See a random pokemon")
    }
}

#Preview(as: .systemSmall) {
    DexWidgetExtension()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}

#Preview(as: .systemMedium) {
    DexWidgetExtension()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}

#Preview(as: .systemLarge) {
    DexWidgetExtension()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}

