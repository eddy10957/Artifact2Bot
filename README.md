# Artifact2Bot

Artifact2 Bot it’s a telegram bot completely written in Swift using Vapor and telegram-vapor-bot frameworks deployed via Heroku. 
Artifact2 works exactly as a Magic 8 ball, whenever you have a doubt you can ask the bot what to do or you can just ask to Flip a Coin.
![Layer_1](/Artifact2-bot-images/bot.PNG)

>Hello I’m Artifact 2 
>Ask me any questions and I’ll help you make a decision. 🤖🤖🤖
![Layer_2](/Artifact2-bot-images/screen.png)

## Routes

Routing is the process of finding the appropriate request handler for an incoming request.
By creating different handlers the bot is configured to reply to different commands or keywords.
The code below shows how the default handler manage texts without command:
- If the message contains the question mark, the bot will answer with a random reply
- If the message contains Coinflip, the bot will randomly answer “Tail” or “Head”
- If neither of the two the bot welcomes the user and explains the different keywords.

```swift
private static func defaultHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGMessageHandler(filters: (.all && !.command.names(["/coinflip", "/show_buttons", "/info","/author"]))) { update, bot in
//            print("\(update.message!.text)")
            if update.message!.text!.contains("?"){
                let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "\(replies.randomElement()!)")
                try bot.sendMessage(params: params)
            }else if update.message!.text!.contains("Coinflip"){
                let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "\(coinFlip.randomElement()!)")
                try bot.sendMessage(params: params)
            }else{
                let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "Ask me a question (use question mark) or ask me to flip a coin with 'Coinflip' ")
                try bot.sendMessage(params: params)
            }
            
        }
        bot.connection.dispatcher.add(handler)
    }
```
Furthermore, the bot is triggered on certain commands, like:

- /info
- /author
- /coinflip

This behavior is established in a different handler:
```swift
private static func commandCoinFlipHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/coinflip"]) { update, bot in
            try update.message?.reply(text: "\(coinFlip.randomElement()!)", bot: bot)
        }
        bot.connection.dispatcher.add(handler)
    }
    
    private static func commandInfoHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/info"]) { update, bot in
            try update.message?.reply(text: "Hello I'm Artifact 2 an experimental bot made for Server Side Swift branch, completly written in Swift using vapor and telegram-vapor-bot frameworks", bot: bot)
        }
        bot.connection.dispatcher.add(handler)
    }
    
    private static func commandAuthorHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/author"]) { update, bot in
            try update.message?.reply(text: "https://www.linkedin.com/in/edoardotroianiello/", bot: bot)
        }
        bot.connection.dispatcher.add(handler)
    }
```
Commands make it easier to understand the capabilities of a bot. If you register a set of commands at the botFather on telegram, on the chat view will appear a menu button with all the different commands that were registered, so a new user can easily figure out what he can do with the bot.
# [Try it out](https://t.me/artifact2_bot)
