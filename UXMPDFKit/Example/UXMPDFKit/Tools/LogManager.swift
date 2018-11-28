//
//  LogManager.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/13.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation
import SwiftyBeaver


public struct Log {
    
    static func output() -> SwiftyBeaver.Type {
        let log = SwiftyBeaver.self
        configurationLog(log: log)
        return log
    }
    
    static private func configurationLog(log: SwiftyBeaver.Type){
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        //        let cloud = SBPlatformDestination(appID: "foo", appSecret: "bar", encryptionKey: "123") // to cloud
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        // or use this for JSON output: console.format = "$J"
        // https://docs.swiftybeaver.com/article/20-custom-format
        
        /// uses colors compatible to Terminal instead of Xcode, default is false
        //        console.useTerminalColors = false
        
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        log.addDestination(file)
        
        /*
         // Now let’s log!
         log.verbose("not so important")  // prio 1, VERBOSE in silver
         log.debug("something to debug")  // prio 2, DEBUG in green
         log.info("a nice information")   // prio 3, INFO in blue
         log.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
         log.error("ouch, an error did occur!")  // prio 5, ERROR in red
         
         // log anything!
         log.verbose(123)
         log.info(-123.45678)
         log.warning(Date())
         log.error(["I", "like", "logs!"])
         log.error(["name": "Mr Beaver", "address": "7 Beaver Lodge"])
         
         // optionally add context to a log message
         console.format = "$L: $M $X"
         log.debug("age", 123)  // "DEBUG: age 123"
         log.info("my data", context: [1, "a", 2]) // "INFO: my data [1, \"a\", 2]"
         */
    }
}


final class LogManager {
    
    static let shared = LogManager()
    let log = SwiftyBeaver.self
    
    init() {
        configurationLog()
    }
    
    private func configurationLog(){
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        //        let cloud = SBPlatformDestination(appID: "foo", appSecret: "bar", encryptionKey: "123") // to cloud
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        // or use this for JSON output: console.format = "$J"
        // https://docs.swiftybeaver.com/article/20-custom-format
        
        /// uses colors compatible to Terminal instead of Xcode, default is false
        //        console.useTerminalColors = false
        
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        log.addDestination(file)
        
        /*
         // Now let’s log!
         log.verbose("not so important")  // prio 1, VERBOSE in silver
         log.debug("something to debug")  // prio 2, DEBUG in green
         log.info("a nice information")   // prio 3, INFO in blue
         log.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
         log.error("ouch, an error did occur!")  // prio 5, ERROR in red
         
         // log anything!
         log.verbose(123)
         log.info(-123.45678)
         log.warning(Date())
         log.error(["I", "like", "logs!"])
         log.error(["name": "Mr Beaver", "address": "7 Beaver Lodge"])
         
         // optionally add context to a log message
         console.format = "$L: $M $X"
         log.debug("age", 123)  // "DEBUG: age 123"
         log.info("my data", context: [1, "a", 2]) // "INFO: my data [1, \"a\", 2]"
         */
    }
    
}
