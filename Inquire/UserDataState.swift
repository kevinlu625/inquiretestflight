//
//  Calling Things.swift
//  Inquire
//
//  Created by Kevin Lu on 8/7/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import Foundation

class UserData
{
    static var currentUser: String = ""
    static var currentChannel: String = "General"
    static var currentAdmin: String = ""
    static var currentQuestion: String = ""
    static var currentAnswer: String = ""
    static var currentError: String = ""
    static var currentReply: String = ""
    static var currentRegistrationToken = ""
    static var currentPFP: String = ""
    static var justChangedPFP:Bool = false
    static var returnKeyboard = false
    static var channelDeleted = false
    
    static var returningToViewQuestion = false
    
 }
