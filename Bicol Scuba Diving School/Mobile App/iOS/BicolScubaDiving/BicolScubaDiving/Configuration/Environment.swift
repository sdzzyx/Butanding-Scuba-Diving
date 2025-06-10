//
//  Environment.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import Foundation

enum EnvironmentType: Int {
    case dev 
    case prod
}

final class Environment {
    let current: EnvironmentType
    
    public required init(code: EnvironmentType) {
        self.current = code
    }    
}

final class Configuration {
    static let environment: Environment = {
        guard let value = Bundle.main.infoDictionary?[AppConstant.Configuration.appEnvironment] as? String else {
            return Environment(code: .prod)
        }
        
        switch value {
        case AppConstant.Configuration.dev: return Environment(code: .dev)
        case AppConstant.Configuration.prod: return Environment(code: .prod)
            
        default:
            return Environment(code: .prod)
        }
    }()
}
