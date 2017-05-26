//
//  VideoModel.swift
//  VideoSearchDemo
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import Foundation

struct VideoModel {
    let posterURL : String?
    let isAdult : Bool?
    let overview : String?
    let title : String?
    let originalTitle : String?
    let backdropURL: String?
    let releaseDate : String?
    let popularity : Float?
    let voteAverage : Float?
    let voteCount : Int?
    let genres : [Int]?
}
