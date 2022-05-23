import Sword
import token.swift

let bot = Sword(token: getBotToken())

bot.on(.messageCreate) { data in 
    let msg = data as! Message

    if msg.content == "!ping" {
        msg.reply(with: "pong!")
    }
}

bot.connect()
