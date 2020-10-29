//
//  AddNewItemView.swift
//  PassLite
//
//  Created by Oleksandr Yakubchyk on 16.10.2020.
//

import SwiftUI
import PassphraseGenerator
import KeychainSwift

struct AddNewItemView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var editItemId: String?
    
    @State var name: String
    @State var username: String
    @State var password: String = ""
    @Binding var isPresented: Bool

    let generator = PassphraseGenerator()
    
    init(itemId: String?, item: SecuredEntity?, presenting: Binding<Bool>) {
        self._isPresented = presenting
        self.editItemId = itemId
        
        self._name = State(initialValue: "")
        self._username = State(initialValue: "")

        if let item = item {
            self._name = State(initialValue: item.name)
            self._username = State(initialValue: item.username)
            if let pass = KeychainSwift().get(item.id) {
                self._password = State(initialValue: pass)
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .trailing, spacing: 10) {
                    Text("Name").foregroundColor(.gray)
                    Text("Username").foregroundColor(.gray)
                    Text("Password").foregroundColor(.gray)
                }
                VStack(alignment: .leading, spacing: 5) {
                    TextField("Item name", text: $name)
                    TextField("Usernname", text: $username)
                    HStack {
                        TextField("Password", text: $password)
                        Button(action: {
                            password = generator.randomPhrase(lenght: 3)
                        }) {
                            Text("↺")
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    isPresented = false
                }) {
                    Text("Cancel")
                }

                Button(action: {
                    
                    if let id = editItemId {
                        if let entities = try? context.fetch(SecuredEntity.getItem(id: id)) as [SecuredEntity], let item = entities.first {
                            
                            item.date = Date()
                            item.name = name
                            item.username = username
                            
                            let keychain = KeychainSwift()
                            keychain.set(password, forKey: id)
                            
                            try? context.save()
                        }
                    }
                    else {
                        if name.isEmpty == false {
                            let newItem = SecuredEntity(context: context)
                            newItem.date = Date()
                            newItem.id = UUID().uuidString
                            newItem.name = name
                            newItem.username = username
                            
                            try? context.save()
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                    isPresented = false
                }) {
                    Text("Save")
                }
            }
        }.frame(width: 300, height: 100).padding()
    }
    
    func copy(phrase: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(phrase, forType: NSPasteboard.PasteboardType.string)
    }
}

//struct AddNewItemView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        AddNewItemView()
//    }
//}
