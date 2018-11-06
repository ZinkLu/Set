////
////  card2.swift
////  Set
////
////  Created by zinklu on 2018/7/28.
////  Copyright © 2018年 ShuYang Lu. All rights reserved.
////
//
////卡牌：每张卡牌都有4个属性：颜色、数量、形状、透明度(实际上是内部花纹，但是这个不好实现)，每一个属性下还有三个小属性
//
//import Foundation
//
//// 定义卡牌属性
//// 由于这属于Model，在定义属性的时候不能指定关于属性的描述，这里只用枚举和其原始值来表示每个属性有3个小属性
//
//// 颜色属性
//enum Color:Int {
//    case one = 0, two, three
//}
//// 形状属性
//enum Shape:Int {
//    case one = 0, two, three
//}
//// 数量属性
//enum Number: Int{
//    case one = 0, two , three
//}
//// 透明度属性
//enum Shade:Int {
//    case one = 0, two, three
//}
//
//
//// 定义卡牌结构体(每一张卡牌生成了属性就不能改变了，所以用结构体)
//struct Card: Equatable, Hashable{
//    static func == (lhs: Card, rhs: Card) -> Bool {
//        return (lhs.color == rhs.color) && (lhs.shape == rhs.shape) && (lhs.number == rhs.number) && (lhs.shade == rhs.shade)
//    }
//
//    // 四种属性，每一张卡牌都要用四个不一样的属性哦
//    var color:Color
//    var shape:Shape
//    var number:Number
//    var shade:Shade
//
//    // 卡牌在游戏中的状态
//    // 是否被选中了
//    var isSelected = false
//    var isHint = false
//    // 是否set了(如果set了则不会显示在牌面上)
//    var isSet = false
//    // 是否在桌面上
//    var isOnTable = false
//
//    // 初始化方法，每种属性有三个，4个参数的值不能大于3
//    init(color: Int, shape: Int, number: Int, shade: Int) {
//        self.color = Color(rawValue: color)!
//        self.shape = Shape(rawValue: shape)!
//        self.number = Number(rawValue: number)!
//        self.shade = Shade(rawValue: shade)!
//    }
//}
