import Sword

let bot = Sword(token: getBotToken())

bot.on(.messageCreate) { data in 
    let msg = data as! Message

    if msg.content == "!marko" || msg.content == "!marco" {
        msg.reply(with: "polo!")
    } else if msg.content == "!xkcd" {
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
    }
}

bot.connect()
