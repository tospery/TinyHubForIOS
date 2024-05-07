//
//  User+Ex.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import BonMot

extension User {

    var isOrganization: Bool { self.type == "Organization" }
    
    var milestone: String { "https://ghchart.rshah.org/1CA035/\(String(describing: username))" }
    
    var joinedOn: String? {
        guard let string = self.createdAt else { return nil }
        guard let date = Date.init(iso8601: string) else { return nil }
        let value = date.string(withFormat: "yyyy-MM-dd")
        return R.string.localizable.joinedOn(value, preferredLanguages: myLangs)
    }
    
    var fullname: String {
        let unknown = R.string.localizable.unknown(preferredLanguages: myLangs)
        return "\(self.nickname ?? unknown) (\(self.username ?? unknown))"
    }
    
    var infoAttributedText: NSAttributedString {
        .composed(of: [
            self.locationAttributedText
                .styled(with: .color(.title)),
            Special.nextLine,
            (self.joinedOn ?? R.string.localizable.unknown(
                preferredLanguages: myLangs
            ))
                .styled(with: .font(.normal(12)), .color(.body))
        ])
    }
    
    var locationAttributedText: NSAttributedString {
        .composed(of: [
            R.image.ic_location_head()!.template
                .styled(with: .baselineOffset(-2), .font(.normal(10))),
            Special.space,
            (self.location ?? R.string.localizable.noneLocation(
                preferredLanguages: myLangs
            ))
                .styled(with: .font(.normal(13)))
        ]).styled(with: .color(.foreground))
    }
    
    var repoAttributedText: NSAttributedString {
        .composed(of: [
            R.image.ic_repo_small()!
                .styled(with: .baselineOffset(-4)),
            Special.space,
            (self.repo?.name ?? R.string.localizable.noneRepo(
                preferredLanguages: myLangs
            ))
                .attributedString()
        ]).styled(with: .color(.primary), .font(.bold(14)))
    }
    
    var fullnameAttributedText: NSAttributedString {
        .composed(of: [
            (self.nickname ?? self.username ?? R.string.localizable.unknown(
                preferredLanguages: myLangs
            ))
                .styled(with: .color(.primary)),
            Special.space,
            "(\(self.username ?? R.string.localizable.unknown(preferredLanguages: myLangs)))"
                .styled(with: .color(.title))
        ]).styled(with: .font(.bold(16)))
    }
    
    var attrRepositories: NSAttributedString {
        self.attr(R.string.localizable.repositories(
            preferredLanguages: myLangs
        ), self.publicRepos)
    }
    
    var attrFollowers: NSAttributedString {
        self.attr(R.string.localizable.followers(
            preferredLanguages: myLangs
        ), self.followers)
    }
    
    var attrfollowing: NSAttributedString {
        self.attr(R.string.localizable.following(
            preferredLanguages: myLangs
        ), self.following)
    }
    
    func text(cellId: CellId) -> String? {
        var result: String?
        switch cellId {
        case .nickname: result = self.nickname?.isEmpty ?? true ? R.string.localizable.noneNickname(
            preferredLanguages: myLangs
        ) : self.nickname
        case .bio: result = self.bio?.isEmpty ?? true ? R.string.localizable.noneBio(
            preferredLanguages: myLangs
        ) : self.bio
        case .company: result = self.company?.isEmpty ?? true ? R.string.localizable.noneCompany(
            preferredLanguages: myLangs
        ) : self.company
        case .location: result = self.location?.isEmpty ?? true ? R.string.localizable.noneLocation(
            preferredLanguages: myLangs
        ) : self.location
        case .email: result = self.email?.isEmpty ?? true ? R.string.localizable.noneEmail(
            preferredLanguages: myLangs
        ) : self.email
        case .blog: result = self.blog?.isEmpty ?? true ? R.string.localizable.noneBlog(
            preferredLanguages: myLangs
        ) : self.blog
        default: result = nil
        }
        return result
    }
    
    func attr(_ text: String, _ count: Int) -> NSAttributedString {
        .composed(of: [
            count.string.styled(with: .color(.foreground), .font(.bold(22))),
            Special.nextLine,
            text.styled(with: .color(.body), .font(.normal(13)))
        ]).styled(with: .lineSpacing(4), .alignment(.center))
    }
    
}
