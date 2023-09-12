//
//  EnumUtils.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 02/06/2023.
//

import Foundation

enum Colors: String {
    case primary    = "#17CE92"
    case secondary  = "#E8FAF4"
    case divider    = "#EEEEEE"
    case labelDark  = "#212121"
    case labelLight = "#9E9E9E"
    case labelGray  = "#616161"
    case chatBG     = "#F5F5F5"
}

enum FontFamily: String {
    case bold        = "Urbanist-Bold"
    case semiBold    = "Urbanist-SemiBold"
    case regular     = "Urbanist-Regular"
    case medium     = "Urbanist-Medium"
}

enum DummyData: String {
    case dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
}

enum TextFieldType {
    case secure
    case normal
}

enum AppImages: String {
    case logo = "ic_app_logo"
    case loginIntro = "ic_loginintro"
}
