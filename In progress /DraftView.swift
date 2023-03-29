//
//  DraftView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/28/23.
//

import SwiftUI

struct DraftView: View {
    
    
    let draft: Draft
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView(draft: .defaultDraft(in: PersistenceController.preview.container.viewContext))
    }
}
