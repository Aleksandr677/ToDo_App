//
//  ThemeSettings.swift
//  ToDo App
//
//  Created by Христиченко Александр on 2022-11-14.
//

import SwiftUI

//MARK: - THEME CLASS

final public class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
    
    private init() {}
    public static let shared = ThemeSettings()
}
