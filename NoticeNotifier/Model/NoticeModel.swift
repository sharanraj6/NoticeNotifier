//
//  NoticeModel.swift
//  NoticeNotifier
//
//  Created by Sai Sharan Raj Parepalli on 11/02/21.
//

import Foundation
// MARK: - NoticeModel
struct NoticeModel: Codable {
    let notices: [Notice]

    enum CodingKeys: String, CodingKey {
        case notices = "Notices"
    }
}

// MARK: - Notice
struct Notice: Codable {
    let noticeHeading, noticeSentTimestamp, noticeSentBy, noticeDescription,noticeId: String
    let noticeAttachments: [String]

    enum CodingKeys: String, CodingKey {
        case noticeHeading = "notice_heading"
        case noticeSentTimestamp = "notice_sent_timestamp"
        case noticeSentBy = "notice_sent_by"
        case noticeDescription = "notice_description"
        case noticeAttachments = "notice_attachments"
        case noticeId = "notice_id"
    }
}
