//
//  Session.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 28/3/25.
//

import Supabase

class SessionCache {
    static let shared = SessionCache()
    
    var session: Auth.Session?
}
