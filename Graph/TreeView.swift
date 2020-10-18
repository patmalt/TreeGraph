//
//  TreeView.swift
//  Graph
//
//  Created by Patrick Maltagliati on 10/17/20.
//

import SwiftUI
import CoreData

struct TreeView: View {
    @ObservedObject var root: Node
    let viewContext: NSManagedObjectContext
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NodeView(node: root, viewContext: viewContext)
            if let childrenSet = root.children, let children = Array(childrenSet) as? [Node], !children.isEmpty {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 0.5, height: 20)
                HStack(alignment: .top, spacing: 5) {
                    ForEach(children.sorted(by: { $0.name ?? "" < $1.name ?? "" }), id: \.id) { child in
                            TreeView(root: child, viewContext: viewContext)
                                .anchorPreference(key: TopPreferenceKey.self, value: .top) { anchor in
                                    guard let id = root.id else { return [] }
                                    return [TopPreference(id: id, top: anchor)]
                                }
                    }
                }
                .backgroundPreferenceValue(TopPreferenceKey.self) { (tops: [TopPreference]) in
                    GeometryReader { geo in
                        ForEach(tops.indices, id: \.self) { index in
                            if index < tops.count - 1 {
                                Line(from: geo[tops[index].top], to: geo[tops[index + 1].top]).stroke(lineWidth: 0.5).foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .drawingGroup()
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let root = Node(context: viewContext)
        root.id = UUID()
        root.name = "Root"
        root.isRoot = true
        
        let child1 = Node(context: viewContext)
        child1.id = UUID()
        child1.name = "1"
        child1.parent = root
        
        let child2 = Node(context: viewContext)
        child2.id = UUID()
        child2.name = "2"
        child2.parent = root
        
        let child3 = Node(context: viewContext)
        child3.id = UUID()
        child3.name = "3"
        child3.parent = root
        
        return TreeView(root: root, viewContext: viewContext)
    }
}
