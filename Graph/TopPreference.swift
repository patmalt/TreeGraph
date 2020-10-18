//
//  TopPreference.swift
//  Graph
//
//  Created by Patrick Maltagliati on 10/17/20.
//

import SwiftUI

struct TopPreference {
    let id: UUID
    let top: Anchor<CGPoint>
}

struct TopPreferenceKey: PreferenceKey {
    typealias Value = [TopPreference]
    
    static var defaultValue: Value = []
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}
