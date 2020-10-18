//
//  ContentView.swift
//  Graph
//
//  Created by Patrick Maltagliati on 10/16/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Node.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isRoot == YES"),
        animation: .default
    )
    private var nodes: FetchedResults<Node>
    
    var body: some View {
        NavigationView {
            if let root = nodes.first {
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    TreeView(root: root, viewContext: viewContext)
                }
                .navigationBarItems(
                    leading: Button(action: restart) { Label("Restart", systemImage: "restart.circle") }
                )
            } else {
                VStack {
                    Button(
                        action: newRoot,
                        label: {
                            Label("New", systemImage: "plus")
                        }
                    )
                }
                .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
            }
        }
    }
    
    private func newRoot() {
        let root = Node(context: viewContext)
        root.id = UUID()
        root.name = "Root"
        root.isRoot = true
        try? viewContext.save()
    }
    
    private func restart() {
        let request = NSBatchDeleteRequest(fetchRequest: Node.fetchRequest())
        request.resultType = .resultTypeObjectIDs
        guard
            let result = try? viewContext.execute(request),
            let deleteResult = result as? NSBatchDeleteResult,
            let ids = deleteResult.result as? [NSManagedObjectID]
        else { return }
        let changes = [NSDeletedObjectsKey: ids]
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: changes,
            into: [viewContext]
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
