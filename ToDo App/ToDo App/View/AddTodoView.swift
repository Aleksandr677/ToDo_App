//
//  AddTodoView.swift
//  ToDo App
//
//  Created by Христиченко Александр on 2022-11-13.
//

import SwiftUI

struct AddTodoView: View {
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    
    let priorities = ["High", "Normal", "Low"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    //MARK: - TODO NAME
                    TextField("Todo", text: $name)
                        .padding()
                        .background(
                            Color(UIColor.tertiarySystemFill)
                        )
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    //MARK: - TODO PRIORITY
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                    
                    //MARK: - SAVE BUTTON
                    Button {
                        if name != "" {
                            let todo = Todo(context: managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            
                            do {
                                try self.managedObjectContext.save()
                                //print("New todo: \(todo.name ?? ""), priority: \(todo.priority ?? "")")
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            errorShowing = true
                            errorTitle = "Invalid name"
                            errorMessage = "Make sure to enter something for\nthe new todo item."
                            return
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    } //Save Button
                } //VStack
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Spacer()
                
            } //VStack
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            } //Bar
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        } //Navigation
    }
}

//MARK: - PREVIEW
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
