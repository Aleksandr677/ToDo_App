//
//  SettingsView.swift
//  ToDo App
//
//  Created by Христиченко Александр on 2022-11-14.
//

import SwiftUI

struct SettingsView: View {
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                //MARK: - FORM
                Form {
                    //MARK: - Section 3
                    Section {
                        FormRowLinkView(icon: "globe", color: Color.pink, text: "Website", link: "https://swiftuimasterclass.com")
                        
                        FormRowLinkView(icon: "link", color: Color.blue, text: "Twitter", link: "https://twitter.com/robertpetras")
                        
                        FormRowLinkView(icon: "play.rectangle", color: Color.blue, text: "Courses", link: "https://www.udemy.com/user/robert-petras")
                        
                    } header: {
                        Text("Follow us on social media")
                    } //Section 3
                    .padding(.vertical, 3)
                    
                    //MARK: - Section 4
                    Section {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone / iPad")
                        
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Alex / Diana")
                        
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Alex Kh.")
                        
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    } header: {
                        Text("About the application")
                    } //Section 4
                    .padding(.vertical, 3)
                } //Form
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                //MARK: - FOOTER
                Text("Copyright © All rights reserved.\nBetter Apps ♡ Less Code.")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
            } //VStack
            .toolbar(content: {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            })
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
        } //Navigation
    }
}

//MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
