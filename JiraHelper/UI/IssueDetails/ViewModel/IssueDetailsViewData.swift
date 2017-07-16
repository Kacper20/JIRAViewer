//
//  IssueDetailsViewData.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 05/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation


struct IssueDetailsCommentData {
    let date: String
    let author: String
    let avatarUrl: String
    let body: String

    init(comment: IssueComment) {
        self.date = DateFormatterHelper.commentFormat(date: comment.created)
        self.author = comment.author.name
        self.avatarUrl = comment.author.avatarUrl
        self.body = comment.body
    }
}

struct IssueDetailsViewData {

    let keyName: String
    let title: String
    let peopleInvolved: [PersonData]
    let creationTime: String
    let lastViewTime: String?
    let descriptionHtml: String
    let comments: [IssueDetailsCommentData]
}

extension IssueDetailsViewData {
    init(issue: DetailedIssue) {
        self.keyName = issue.key
        self.title = issue.summary
        var people = [PersonData(role: "Creator", person: issue.creator)]
        if let assignee = issue.assignee {
            people.append(PersonData(role: "Assignee", person: assignee))
        }
        self.peopleInvolved = people
        self.creationTime = DateFormatterHelper.issueDetailsFormat(date: issue.created)
        self.lastViewTime = issue.lastViewed.map(DateFormatterHelper.issueDetailsFormat(date: ))
        self.descriptionHtml = issue.description
        self.comments = issue.comments.map(IssueDetailsCommentData.init(comment:))
    }
}
