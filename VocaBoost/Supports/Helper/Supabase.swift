//
//  Supabase.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 27/2/25.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://mqgbouveuxemqhvpbdeu.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1xZ2JvdXZldXhlbXFodnBiZGV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA2NDExOTQsImV4cCI6MjA1NjIxNzE5NH0.L4jvjafIK8UdCHVyW-QcDXGCbPLelT5wtrSiscjAZcE"
)
