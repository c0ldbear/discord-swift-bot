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
                let msgEmbed: Embed = await XKCD().msg() // Since there are two functions with different returns, we need to specify the data type?
                msg.reply(with: msgEmbed)
            }
        } else {
            // Fallback on earlier versions
            print("Using 'completion' to fetch XKCD comic.")
            XKCD().msg() { inMsg in
                msg.reply(with: inMsg)
            }
        }
    case .dn?:
        if #available(macOS 12, *) {
            Task.init {
                msg.reply(with: await DagensNyheter().latestNews())
            }
        } else {
            // Fallback on earlier version
            msg.reply(with: "Sorry, cannot perform that command at this time.")
        }
    default:
        break
    }
}

bot.on(.ready) { data in
    let user = data as! User
    print("\n\t\(user.username ?? "Bot") says 'Hello there!'\n")
}

bot.connect()
