//
//  NoticeListView.swift
//  NoticeNotifier
//
//  Created by Sai Sharan Raj Parepalli on 11/02/21.
//

import SwiftUI

struct NoticeListView: View {
    
    @State var navigateToDetailView: Bool = true
    var notices: [Notice]
    let dateFormatter = DateFormatter()
    let dateFormatterDate = DateFormatter()
    let dateFormatterTime = DateFormatter()
    let noticeID = UserDefaults.standard.object(forKey: "SELECTED_NOTICE_ID") as? String
    init(notices: [Notice]) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatterDate.dateFormat = "MMM dd, yyyy"
        dateFormatterTime.dateFormat = "HH:mm"
        self.notices = notices.sorted(by: { $0.noticeSentTimestamp > $1.noticeSentTimestamp })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if let selectedNoticeId = noticeID, let selectedNotice = notices.first(where: { $0.noticeId == selectedNoticeId }) {
                    NavigationLink(destination: NoticeDetailsView(notice: selectedNotice), isActive: $navigateToDetailView) {
                        
                    }
                }
                List {
                    ForEach(notices.indices, id:\.self) { index in
                        ZStack {
                            NavigationLink(destination: NoticeDetailsView(notice: notices[index])) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(verbatim: notices[index].noticeHeading)
                                        .font(.custom("AvenirNext-Bold", size: 20))
                                    HStack {
                                        Text(verbatim: "\(dateFormatterDate.string(from: dateFormatter.date(from: notices[index].noticeSentTimestamp)!)),")
                                            .font(.custom("AvenirNext-Demibold", size: 10))
                                            .foregroundColor(.gray)
                                        Text(verbatim: "\(dateFormatterTime.string(from: dateFormatter.date(from: notices[index].noticeSentTimestamp)!))")
                                            .font(.custom("AvenirNext-Demibold", size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }.navigationBarTitle(Text("Notices"))
                .navigationViewStyle(StackNavigationViewStyle())
                
            }
        }
    }
}
