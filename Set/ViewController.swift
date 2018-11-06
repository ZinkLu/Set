//
//  ViewController.swift
//  Set
//
//  Created by zinklu on 2018/7/22.
//  Copyright © 2018年 ShuYang Lu. All rights reserved.
//

import UIKit

extension String {
    // Swift不支持乘法来重复字符串，该方法能够返回经过`times`次重复的`self`
    func mutiple(times: Int) -> String {
        var mutipleString = ""
        if times <= 0 {
            return self
        }
        for _ in 1...times {
            mutipleString += self
        }
        return mutipleString
    }
}

class ViewController: UIViewController {
    
    let colors: [UIColor] = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    let shapes: [String] = ["▲", "●", "◼︎"]
    let numbers: [Int] = [1, 2, 3]
    let shades: [CGFloat] = [0, 0.2, 1]   // 这里简单处理，将原游戏的图案填充做成了透明度.
    
    var setgame:SetGame = SetGame()
    
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var scoreCounter: UILabel!
    
    @IBAction func chooseCard(_ sender: UIButton) {
        let index = buttons.index(of: sender)!
        setgame.chooseCard(at: index)
        updateFromModel()
    }
    
    @IBAction func restart(_ sender: UIButton) {
        viewDidLoad()
    }
    
    @IBAction func addThreeCards(_ sender: UIButton) {
        if setgame.cardsOnTable.count == buttons.count {
            return
        }
        setgame.addThreeCards()
        updateFromModel()
    }
    
    @IBAction func goHint(_ sender: UIButton) {
        setgame.hit()
        updateFromModel()
    }
    
    @IBOutlet weak var HitButon: UIButton!
    
    
    @IBAction func getHelp(_ sender: UIButton) {
        let alert = UIAlertController(title: "简介", message: "玩法简介：\n 每张牌都有自己的四个属性， \n 选择三张牌，\n 当他们的四个属性都相同或者都不同时\n配对成功", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "Try Hint", style: .default, handler: {_ in self.goHint(self.HitButon)})
        alert.addAction(action2)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
}
    
    func updateFromModel() {
        // 每次更新都会先重置一遍按钮
        for index in buttons.indices {
            buttons[index].backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            buttons[index].isEnabled = false
            buttons[index].setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            buttons[index].layer.borderWidth = 0
        }
        
        for index in setgame.cardsOnTable.indices {
            // 更新每一张牌的牌面
            let button = buttons[index]
            let card = setgame.cardsOnTable[index]
            let color = colors[card.color.rawValue]
            let shape = shapes[card.shape.rawValue]
            let number = numbers[card.number.rawValue]
            let shade = shades[card.shade.rawValue]
            let attribute:[NSAttributedStringKey: Any] = [ .foregroundColor: color.withAlphaComponent(shade),
                                                           .strokeColor: color,
                                                           .strokeWidth: -4.0,
                                                           .font: UIFont(name: "PingFangSC-Regular", size: 18.0) as Any]
            let attributeTitle = NSAttributedString(string: shape.mutiple(times: number), attributes: attribute)
            button.setAttributedTitle(attributeTitle, for: .normal)
            // 更新牌面结束
            
            // 更新enable
            button.isEnabled = true
            // 更新enable结束
        
            // 更新牌的背景.在桌上的牌都要变成白色背景
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            // 更新背景结束
        
            // 更新卡牌被选中状态
            if card.isSelected == true || card.isHint == true{
                button.layer.borderWidth = 5.0
                button.layer.borderColor = #colorLiteral(red: 0.002251280103, green: 0.1067579593, blue: 0.6980462192, alpha: 1)
            } else {
                button.layer.borderWidth = 0
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            // 更新卡牌被选中状态结束

        }
    }
    
    override func viewDidLoad() {
        self.setgame = SetGame()
        updateFromModel()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

