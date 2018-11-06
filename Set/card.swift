//
//  card.swift
//  Set
//
//  Created by zinklu on 2018/7/22.
//  Copyright © 2018年 ShuYang Lu. All rights reserved.
//


//卡牌：每张卡牌都有4个属性：颜色、数量、形状、透明度(实际上是内部花纹，但是这个不好实现)，每一个属性下还有三个小属性

import Foundation

// 定义卡牌属性
// 由于这属于Model，在定义属性的时候不能指定关于属性的描述，这里只用枚举和其原始值来表示每个属性有3个小属性

// 颜色属性
enum Color:Int {
    case one = 0, two, three
}
// 形状属性
enum Shape:Int {
    case one = 0, two, three
}
// 数量属性
enum Number: Int{
    case one = 0, two , three
}
// 透明度属性
enum Shade:Int {
    case one = 0, two, three
}


// 定义卡牌类(由于在model里面使用了比较奇特的处理方式，因此必须要类)
class Card: Equatable, Hashable{
    var hashValue: Int { return self.cardId }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return (lhs.color == rhs.color) && (lhs.shape == rhs.shape) && (lhs.number == rhs.number) && (lhs.shade == rhs.shade)
    }
    
    // 四种属性，每一张卡牌都要用四个不一样的属性哦
    var color:Color
    var shape:Shape
    var number:Number
    var shade:Shade
    
    // 卡牌在游戏中的状态
    // 是否被选中了
    var isSelected = false
    var isHint = false
    // 是否set了(如果set了则不会显示在牌面上)
    var isSet = false
    // 是否在桌面上
    var isOnTable = false
    
    var cardId: Int {
        return color.rawValue*1000 + shape.rawValue*100 + number.rawValue*10 + shade.rawValue
    }

    // 初始化方法，每种属性有三个，4个参数的值不能大于3
    init(color: Int, shape: Int, number: Int, shade: Int) {
        self.color = Color(rawValue: color)!
        self.shape = Shape(rawValue: shape)!
        self.number = Number(rawValue: number)!
        self.shade = Shade(rawValue: shade)!
    }
}













