import Sword

let bot = Sword(token: getBotToken())

bot.on(.messageCreate) { data in 
    let msg = data as! Message

    if msg.content == "!marko" || msg.content == "!marco" {
        msg.reply(with: "polo!")
    }
}

bot.connect()
