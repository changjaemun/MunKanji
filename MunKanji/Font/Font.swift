//
//  Font.swift
//  MunKanji
//
//  Created by 문창재 on 6/22/25.
//
import SwiftUI

extension Font {
    
    // Weight 100
    static func pretendardThin(size: CGFloat) -> Font {
        return .custom("Pretendard-Thin", size: size)
    }
    
    // Weight 200
    static func pretendardExtraLight(size: CGFloat) -> Font {
        return .custom("Pretendard-ExtraLight", size: size)
    }
    
    // Weight 300
    static func pretendardLight(size: CGFloat) -> Font {
        return .custom("Pretendard-Light", size: size)
    }
    
    // Weight 400
    static func pretendardRegular(size: CGFloat) -> Font {
        return .custom("Pretendard-Regular", size: size)
    }
    
    // Weight 500
    static func pretendardMedium(size: CGFloat) -> Font {
        return .custom("Pretendard-Medium", size: size)
    }
    
    // Weight 600
    static func pretendardSemiBold(size: CGFloat) -> Font {
        return .custom("Pretendard-SemiBold", size: size)
    }
    
    // Weight 700
    static func pretendardBold(size: CGFloat) -> Font {
        return .custom("Pretendard-Bold", size: size)
    }
    
    // Weight 800
    static func pretendardExtraBold(size: CGFloat) -> Font {
        return .custom("Pretendard-ExtraBold", size: size)
    }
    
    // Weight 900
    static func pretendardBlack(size: CGFloat) -> Font {
        return .custom("Pretendard-Black", size: size)
    }
}
