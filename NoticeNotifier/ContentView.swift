//
//  ContentView.swift
//  NoticeNotifier
//
//  Created by Sai Sharan Raj Parepalli on 07/02/21.
//

import SwiftUI

struct ContentView: View {
    var notices: [Notice]?
    init() {
        /// Network Service Call to fetch Notices from server.
        notices = NetworkService.sharedInstance.fetchLocalData()?.notices
    }
    
    var body: some View {
        if let noticesFetched = notices {
            NoticeListView(notices: noticesFetched)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
