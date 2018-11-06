//
//  setGameModel.swift
//  Set
//
//  Created by zinklu on 2018/7/22.
//  Copyright © 2018年 ShuYang Lu. All rights reserved.
//
// 2018年7月22日，又看了一遍lecutre3和lecture4，得到了不少收获，在这里重新写一个API，希望能够改进之前的版本
// ps 游戏规则不变
/*  这是一个叫做set的卡牌游戏
 卡牌：
 每张卡牌都有4个属性：颜色、数量、形状、透明度(实际上是内部花纹，但是这个不好实现)，每一个属性下还有三个小属性
 
 规则：
 选择3张牌，三张牌的4个属性每一个属性要么都相同，要么都不同，则这三张卡牌set(不知道规则的可以运行一下游戏)
 
 开始游戏：
 牌库：一共有81张牌 = 3*3*3*3
 桌面：在游戏初始化阶段有12张牌出现在桌面上
 有一个发三张牌的按钮，桌面最多呈现24张牌
 游戏结束：
 所有的卡牌都set(或者没有耐心完了)
 提示：
 将自动显示3张set的卡牌在桌面上*/
// 7月29号，这个数据模型貌似也不简单，虽然高级了一点点点...

import Foundation

extension Array {
    // 随机获取`self`中的一个`元素`
    var randomElment: Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
    
    // 将`self`中`元素`随机打乱
    mutating func shuffle() {
        self.forEach { _ in self.insert(remove(at: 0), at: Int(arc4random_uniform(UInt32(count)))) }
    }
}

struct SetGame {
    
    // 数据准备
    var deckOfCards = [Card]()
    
    var cardsOnTable: [Card] {
        get {return deckOfCards.filter {$0.isOnTable == true}}
        set {}
    }
    
    var cardsCanBeUse: Int {
        return deckOfCards.filter({ $0.isSet == false && $0.isOnTable == false}).count
    }
    
    // 初始化游戏
    init() {
        // deck -- 81张卡
        for countOfColor in 0...2 {
            for countOfShape in 0...2 {
                for countOfnumber in 0...2 {
                    for countOfShade in 0...2 {
                        deckOfCards.append(Card(color: countOfColor, shape: countOfShape, number: countOfnumber, shade: countOfShade))
                    }
                }
            }
        }
        // 打乱顺序
        deckOfCards.shuffle()
        // table -- 12张牌
        for cardOnTable in 0 ..< 12 {
            deckOfCards[cardOnTable].isOnTable = true
        }
    }
    
    // 已选择卡牌的数量
    var choosenCards:Int = 0{
        // 如果卡牌到达3张，则将牌都翻转过来
        didSet {
            if oldValue == 2 {
                for index in cardsOnTable.indices {
                    cardsOnTable[index].isSelected = false
                }
            }
        }
    }
    
    
    // 处理数据
    // 选卡
    mutating func chooseCard(at index: Int) {
        // 选择一张牌，将他反过来，如果是已经反过来的卡牌则会翻回去
        // 当牌到3张的时候先判断是否set，再讲牌翻回来
        cardsOnTable[index].isSelected = (cardsOnTable[index].isSelected == false ? true : false)
        
        // 将即将需要被判断是否set的卡牌拿到新的数组中
        let selectedCards:[Card] = cardsOnTable.filter { $0.isSelected }
        
        // 当三个的时候判断内部的卡牌是否set
        if selectedCards.count == 3 {
            let isSet = Set(selectedCards.map({$0.color})).count != 2 &&
                Set(selectedCards.map({$0.shape})).count != 2 &&
                Set(selectedCards.map({$0.number})).count != 2 &&
                Set(selectedCards.map({$0.shade})).count != 2
            if isSet {
                // 如果没有可用的卡牌了
                // 设置三张牌 isSet = true
                for setCard in selectedCards.indices {
                    selectedCards[setCard].isSet = true
                    selectedCards[setCard].isOnTable = false
                    selectedCards[setCard].isSelected = false
                    
                    // 判断牌库中是否有可用的牌了
                    if cardsCanBeUse != 0 {
                        // 设置新的牌到桌面顺序还不能变，只能把后面的三张牌和这三张牌调换顺序了.
                        // 调换过来的牌需要满足 1. 不能已经set过了 2. 不能是桌面上的牌 3. 完全随机
                        var newCardIndex:Int = 0
                        let index = deckOfCards.index(of: selectedCards[setCard])!
                        while true {
                            let newCard = deckOfCards.randomElment
                            if newCard.isSet == false && newCard.isOnTable == false {
                                newCardIndex = deckOfCards.index(of: newCard)!
                                deckOfCards[newCardIndex].isOnTable = true
                                break
                            }
                        }
                        deckOfCards.swapAt(index, newCardIndex)
                    }
                }
            }
        }
        choosenCards = selectedCards.count
    }
    
    
    
    // 发三张卡
    mutating func addThreeCards() {
        if cardsCanBeUse != 0 {
            var addCards: Set<Card> = []
            var indexOfCard = cardsOnTable.endIndex
            while addCards.count != 3 {
                let card = deckOfCards[indexOfCard]
                indexOfCard += 1
                if card.isSet == true {
                    continue
                }
                addCards.insert(card)
            }
            addCards.forEach({$0.isOnTable = true})
        }
    }
    
    // 提示
    mutating func hit() {
        for index in cardsOnTable.indices {
            cardsOnTable[index].isHint = false
        }
        var hitCards:Set<Card> = []
        var indexOfHints:Set<Int> = []
        var doNotTrap = 0
        while true {
            doNotTrap += 1
            if doNotTrap == 10000 {
                break
            }
            while hitCards.count != 3 {
                let hitCard = cardsOnTable.randomElment
                hitCards.insert(hitCard)
                indexOfHints.insert(cardsOnTable.index(of: hitCard)!)
            }
            let isSet = Set(hitCards.map({$0.color})).count != 2 &&
                Set(hitCards.map({$0.shape})).count != 2 &&
                Set(hitCards.map({$0.number})).count != 2 &&
                Set(hitCards.map({$0.shade})).count != 2
            if isSet {
                for index in indexOfHints {
                    cardsOnTable[index].isHint = true
                }
                break
            } else {
                hitCards = []
                indexOfHints = []
            }
        }
    }
}









