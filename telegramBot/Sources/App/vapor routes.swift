//
//  File.swift
//  
//
//  Created by Edoardo Troianiello on 31/03/22.
//

import Vapor
import telegram_vapor_bot


func routes(_ app: Application) throws {

    app.post("5163865318:AAEbz537tPN4bmW3Gkb3Lfp1ltApLCf0JP8") { (request) -> String in
        do {
            let update: TGUpdate = try request.content.decode(TGUpdate.self)
            try TGBot.shared.connection.dispatcher.process([update])
        } catch {
//            log.error(error.logMessage)
        }

        return "ok"
    }
}
