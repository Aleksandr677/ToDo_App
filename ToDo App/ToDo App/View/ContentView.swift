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
    
    //Fetch Todo items
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton : Bool = false
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(todos, id: \.self) { todo in
                        HStack {
                            Text(todo.name ?? "Unknown")
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Unknown")
                        }
                    } //Loop
                    .onDelete(perform: deleteTodo)
                } //List
                .navigationTitle("Todo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    EditButton()
                    
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
                
                //MARK: - NO TODO ITEMS
                if todos.count == 0 {
                    EmptyListView()
                }
            } //ZStack
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView()
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .overlay(alignment: .bottomTrailing) {
                ZStack {
                    
                    Group {
                        Circle()
                            .fill(Color.blue)
                            .opacity(animatingButton ? 0.2 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                            .padding(.bottom, 15)
                            .padding(.trailing, 15)
                        
                        Circle()
                            .fill(Color.blue)
                            .opacity(animatingButton ? 0.15 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                            .padding(.bottom, 15)
                            .padding(.trailing, 15)
                    }
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animatingButton)
                    
                    Button {
                        showingAddTodoView.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                            .padding(.bottom, 15)
                            .padding(.trailing, 15)
                    } //Button
                    .onAppear {
                        animatingButton.toggle()
                    }
                } //ZStack
            }
        } //Navigation
    }
    
    //MARK: - FUNCTIONS
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
