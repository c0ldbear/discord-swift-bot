import Sword

let bot = Sword(token: getBotToken())

bot.on(.messageCreate) { data in 
    let msg = data as! Message

    switch Commands(rawValue: msg.content) {
    case .marco?, .marko?:
        msg.reply(with: "polo!")
    case .xkcd?:
        // replace with solution from 'xkcd command async-await' branch
        if #available(macOS 12, *) {
            print("Using 'async-await' to fetch XKCD comic.")
            Task.init {
                msg.reply(with: await xkcd())
            }
        } else {
            // Fallback on earlier versions
            print("Using 'completion' to fetch XKCD comic.")
            xkcd() { inMsg in
                msg.reply(with: inMsg)
            }
        }
    case .dn?:
        if #available(macOS 12, *) {
            Task.init {
                msg.reply(with: await dn())
            }
        } else {
            // Fallback on earlier version
            msg.reply(with: "Sorry, cannot perform that command at this time.")
        }
    default:
        break
    }
}

bot.connect()
