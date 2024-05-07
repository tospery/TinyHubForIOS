//
//  FileViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/17.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class FileViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        let lang = self.title?.fileExt?.fileLang
        return self.provider.file(urlString: self.url)
            .asObservable()
            .map { result -> Mutation in
                if let image = result as? UIImage {
                    return .initial([.init(header: nil, models: [
                        BaseModel.init(
                            SectionItemElement.imageView(image)
                        )
                    ])])
                }
                let code = result as? String
                return .initial([.init(header: nil, models: [
                    BaseModel.init(
                        SectionItemElement.codeView(lang: lang, code: code)
                    )
                ])])
            }
    }

}
