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
    
    @EnvironmentObject var iconSettings: IconNames
    
    //THEME
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                //MARK: - FORM
                Form {
                    //MARK: - Section 1
                    Section {
                        Picker(selection: $iconSettings.currentIndex) {
                            ForEach(0..<iconSettings.iconNames.count) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    
                                    Spacer().frame(width: 8)
                                    
                                    Text(self.iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                } //HStack
                                .padding(3)
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                                        .strokeBorder(Color.primary, lineWidth: 2)
                                    
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 28, weight: .regular, design: .default))
                                    .foregroundColor(.primary)
                                }
                                .frame(width: 44, height: 44)
                                
                                Text("App Icons".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                            } //Label
                        } //Picker
                        .pickerStyle(.inline)
                        .onReceive([self.iconSettings.currentIndex].publisher.first()) { (value) in
                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("Success! You have changed the app icon.")
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Choose the app icon")
                    } //Section 1
                    .padding(.vertical, 3)
                    
                    //MARK: - Section 2
                    Section {
                        List {
                            ForEach(themes, id: \.id) { theme in
                                Button {
                                    self.theme.themeSettings = theme.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                } label: {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(theme.themeColor)
                                        Text(theme.themeName)
                                    } //Hstack
                                } //Button
                                .tint(Color.primary)
                            } //Loop
                        } //List
                    } header: {
                        HStack {
                            Text("Choose the app theme")
                            
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(themes[theme.themeSettings].themeColor)
                        } //Hstack
                    } //Section 2
                    .padding(.vertical, 3)
                    
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
        .tint(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconNames())
    }
}
