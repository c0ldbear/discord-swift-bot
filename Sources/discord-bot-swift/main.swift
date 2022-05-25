import Sword

let bot = Sword(token: getBotToken())

bot.on(.messageCreate) { data in 
    let msg = data as! Message
    print(msg)
    
    switch Commands(rawValue: msg.content) {
    case .marco?, .marko?:
        msg.reply(with: "polo!")
    case .xkcd?:
        // replace with solution from 'xkcd command async-await' branch
        xkcd() { inMsg in
            msg.reply(with: inMsg)
        }
    default:
        break
    }
}

bot.connect()
