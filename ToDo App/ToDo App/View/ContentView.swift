//
//  ContentView.swift
//  ToDo App
//
//  Created by Христиченко Александр on 2022-11-13.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingAddTodoView: Bool = false

    //MARK: - BODY
    var body: some View {
        NavigationView {
            List(0..<5) { item in
                Text("Hello world")
            } //List
            .navigationTitle("Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    //Show add todo view
                    showingAddTodoView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            } //Bar
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView()
                    .environment(\.managedObjectContext, managedObjectContext)
            }
        } //Navigation
    }
}


//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
