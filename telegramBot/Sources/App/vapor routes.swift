//
//  File.swift
//  
//
//  Created by Edoardo Troianiello on 31/03/22.
//

import Vapor
import telegram_vapor_bot


func routes(_ app: Application) throws {

    app.post("//INSERT TOKEN HERE") { (request) -> String in
        do {
            let update: TGUpdate = try request.content.decode(TGUpdate.self)
            try TGBot.shared.connection.dispatcher.process([update])
        } catch {
//            log.error(error.logMessage)
        }

        return "ok"
    }
}
