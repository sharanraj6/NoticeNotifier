//
//  NoticeDetailsView.swift
//  NoticeNotifier
//
//  Created by Sai Sharan Raj Parepalli on 11/02/21.
//

import SwiftUI

struct NoticeDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    var notice: Notice
    let dateFormatter = DateFormatter()
    let dateFormatterDate = DateFormatter()
    let dateFormatterTime = DateFormatter()
    init(notice: Notice) {
        self.notice = notice
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatterDate.dateFormat = "MMM dd, yyyy"
        dateFormatterTime.dateFormat = "HH:mm"
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: "Description")
                    .font(.custom("AvenirNext-Bold", size: 18))
                    .padding(.top, 10)
                TextView(text: notice.noticeDescription)
                    .frame(minHeight: 80, maxHeight: 600)
                
                Text(verbatim: "Sent By")
                    .font(.custom("AvenirNext-Bold", size: 18))
                Text(verbatim: notice.noticeSentBy)
                    .font(.custom("AvenirNext-Regular", size: 14))
                
                Text(verbatim: "Date & Time")
                    .font(.custom("AvenirNext-Bold", size: 18))
                    .padding(.top,10)
                Text(verbatim: "\(dateFormatterDate.string(from: dateFormatter.date(from: notice.noticeSentTimestamp)!)),")
                    .font(.custom("AvenirNext-Regular", size: 14))
                Text(verbatim: "\(dateFormatterTime.string(from: dateFormatter.date(from: notice.noticeSentTimestamp)!))")
                    .font(.custom("AvenirNext-Regular", size: 14))
                
                Text(verbatim: "Attachments")
                    .font(.custom("AvenirNext-Bold", size: 18))
                    .padding(.top,10)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(notice.noticeAttachments.indices, id:\.self) { index in
                            AttachmentView(attachmentPath: notice.noticeAttachments[index])
                        }
                    }
                }
            }.padding(.leading, 10)
            .onAppear() {
                UserDefaults.standard.setValue(notice.noticeId, forKey: "SELECTED_NOTICE_ID")
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action:{
                UserDefaults.standard.setValue(nil, forKey: "SELECTED_NOTICE_ID")
                self.presentationMode.wrappedValue.dismiss()
            },label:{
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
                    HStack(spacing: 1) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(.title3)
                    }.frame(height: 25)
                }
            }))
        }.navigationBarTitle(Text(verbatim: notice.noticeHeading), displayMode: .inline)
    }
}

struct AttachmentView: View {
    var attachmentPath: String
    @State var attachmentImage: UIImage?
    @State var showLoading: Bool = true
    @State private var showingDetail = false
    var body: some View {
        ZStack{
            if let image = self.attachmentImage {
                Button(action: {
                    showingDetail = true
                }, label: {
                    Image(uiImage: image).resizable().renderingMode(.original)
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .cornerRadius(5)
                }).sheet(isPresented: $showingDetail, content: {
                    ImageView(image: image)
                })
            } else {
                ZStack {
                    ActivityIndicator(animate: $showLoading, activityIndicatorStyle: .medium)
                }.frame(width: 120, height: 120)
                .cornerRadius(5)
            }
        }.onAppear(perform: {
            if let imageURL = URL(string: attachmentPath) {
                fetchImage(from: imageURL, closure: {(image) in
                    withAnimation(Animation.easeIn.speed(1.15).delay(1)){
                        self.attachmentImage = image
                        self.showLoading = false
                    }
                })
            }
        })
        
    }
}

struct ImageView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: UIImage
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray
                Image(uiImage: image).resizable().renderingMode(.original)
                    .scaledToFit()
            }.navigationBarItems(trailing: Button(action:{
                self.presentationMode.wrappedValue.dismiss()
            },label:{
                Text("Done")
            }))
        }
    }
}

