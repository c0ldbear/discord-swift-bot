import Sword

let bot = Sword(token: getBotToken())

bot.on(.messageCreate) { data in 

    func createEmbedXKCD(title: String, description: String, imgUrl: String) -> Embed {
             let testImg: Embed.Image = Embed.Image(height: 0, proxyUrl: "", url: imgUrl, width: 0)
            var testEm: Embed = Embed()
            testEm.image = testImg
            testEm.title = title + " (xkcd.com)"
            testEm.url = "https://www.xkcd.com/"
            testEm.description = "<spoiler>\n||" + description + "||\n</spoiler>"
        return testEm
    }
    
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
                msg.reply(with: await DagensNyheter().latestNews())
            }
        } else {
            // Fallback on earlier version
            msg.reply(with: "Sorry, cannot perform that command at this time.")
        }
    case .em?:
        msg.reply(with: createEmbedXKCD(title: "Or Whatever", description: "Oh yeah, I didn't even know they renamed it the Willis Tower in 2009, because I know a normal amount about skyscrapers.", imgUrl: "https://imgs.xkcd.com/comics/or_whatever.png"))
    default:
        break
    }
}

bot.connect()
