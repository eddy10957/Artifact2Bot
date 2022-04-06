
import Vapor
import telegram_vapor_bot

final class DefaultBotHandlers {

    static func addHandlers(app: Vapor.Application, bot: TGBotPrtcl) {
        defaultHandler(app: app, bot: bot)
        commandCoinFlipHandler(app: app, bot: bot)
        commandInfoHandler(app: app, bot: bot)
        commandAuthorHandler(app: app, bot: bot)
        commandShowButtonsHandler(app: app, bot: bot)
        buttonsActionHandler(app: app, bot: bot)
    }

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

    private static func commandShowButtonsHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/show_buttons"]) { update, bot in
            guard let userId = update.message?.from?.id else { fatalError("user id not found") }
            let buttons: [[TGInlineKeyboardButton]] = [
                [.init(text: "Button 1", callbackData: "press 1"), .init(text: "Button 2", callbackData: "press 2")]
            ]
            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
            let params: TGSendMessageParams = .init(chatId: .chat(userId),
                                                    text: "Keyboard active",
                                                    replyMarkup: .inlineKeyboardMarkup(keyboard))
            try bot.sendMessage(params: params)
        }
        bot.connection.dispatcher.add(handler)
    }

    private static func buttonsActionHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCallbackQueryHandler(pattern: "press 1") { update, bot in
            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                                            text: update.callbackQuery?.data  ?? "data not exist",
                                                            showAlert: nil,
                                                            url: nil,
                                                            cacheTime: nil)
            try bot.answerCallbackQuery(params: params)
        }

        let handler2 = TGCallbackQueryHandler(pattern: "press 2") { update, bot in
            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                                            text: update.callbackQuery?.data  ?? "data not exist",
                                                            showAlert: nil,
                                                            url: nil,
                                                            cacheTime: nil)
            try bot.answerCallbackQuery(params: params)
        }

        bot.connection.dispatcher.add(handler)
        bot.connection.dispatcher.add(handler2)
    }

}
