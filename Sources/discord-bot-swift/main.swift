import Sword

let bot = Sword(token: getBotToken())

bot.on(.messageCreate) { data in 
    let msg = data as! Message

    if msg.content == "!marko" || msg.content == "!marco" {
        msg.reply(with: "polo!")
    } else if msg.content == "!xkcd" {
        xkcd() { inMsg in
            msg.reply(with: inMsg)
        }
    }
}

bot.connect()
