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
    
    //Work with app icon
    @EnvironmentObject var iconSettings: IconNames
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton : Bool = false
    @State private var showingSettingsView: Bool = false
    
    //Theme
    @ObservedObject var theme = ThemeSettings.shared
    var themes = themeData
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay {
                                    Capsule()
                                        .stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                }
                        } //HStack
                        .padding(.vertical, 10)
                    } //Loop
                    .onDelete(perform: deleteTodo)
                } //List
                .navigationTitle("Todo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    EditButton()
                        .tint(themes[self.theme.themeSettings].themeColor)
                    
                    Button {
                        showingSettingsView.toggle()
                    } label: {
                        Image(systemName: "paintbrush")
                            .imageScale(.large)
                    } //Settings button
                    .tint(themes[self.theme.themeSettings].themeColor)
                } //Bar
                .sheet(isPresented: $showingSettingsView) {
                    SettingsView()
                        .environmentObject(iconSettings)
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
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.2 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                            .padding(.bottom, 15)
                            .padding(.trailing, 15)
                        
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
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
                    .tint(themes[self.theme.themeSettings].themeColor)
                    .onAppear {
                        animatingButton.toggle()
                    }
                } //ZStack
            }
        } //Navigation
        .navigationViewStyle(StackNavigationViewStyle())
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
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
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
