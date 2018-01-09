//
//  AppDelegate.swift
//  VideoSearchDemo
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 ntdhat. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MovieDBClient.loadConfiguration()
        MovieDBClient.loadGenresList()
        
        let ret = cpuEmulator(subroutine: ["INV R42",
                                           "MOV 101,R00",
                                           "JZ 13",
                                           "MOV R00,R08",
                                           "MOV 100,R00", 
                                           "JZ 10", 
                                           "INC R42", 
                                           "DEC R00", 
                                           "JMP 6", 
                                           "MOV R08,R00", 
                                           "DEC R00", 
                                           "JMP 3", 
                                           "INC R42"])
        print("ret \(ret)")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VideoSearchDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    enum InstructionEnum {
        case MOVE_FROM_REG
        case MOVE_FROM_CONS
        case ADD
        case DECREASE
        case INCREASE
        case INVERSE
        case JUMP
        case JUMP_Z
        case NOTHING
    }
    
    struct Instruction {
        var InstructionType : InstructionEnum
        var Param_1st : UInt32!
        var Param_2nd : Int!
    }
    
    var registers = [UInt32](repeating: 0, count: 43)
    
    func cpuEmulator(subroutine: [String]) -> String {
        var instructions = parseInstructions(subroutine:subroutine)
        var totalInstructionsExecuted = 0
        var index = 0
        repeat {
            let instruction = instructions[index]
            switch instruction.InstructionType {
            case .MOVE_FROM_REG:
                moveRegister(Rxx:Int(instruction.Param_1st), Ryy:instruction.Param_2nd)
                index = index + 1
            case .MOVE_FROM_CONS:
                moveConstant(d:instruction.Param_1st, Rxx:instruction.Param_2nd)
                index = index + 1
            case .ADD:
                add(Rxx:Int(instruction.Param_1st), Ryy:instruction.Param_2nd)
                index = index + 1
            case .DECREASE:
                decreaseByOne(Rxx:Int(instruction.Param_1st))
                index = index + 1
            case .INCREASE:
                increaseByOne(Rxx:Int(instruction.Param_1st))
                index = index + 1
            case .INVERSE:
                inverse(Rxx:Int(instruction.Param_1st))
                index = index + 1
            case .JUMP:
                index = Int(instruction.Param_1st) - 1
            case .JUMP_Z:
                if registers[0] == 0 {
                    index = Int(instruction.Param_1st) - 1
                }
                else {
                    index = index + 1
                }
            case .NOTHING:
                index = index + 1
            }
            
            totalInstructionsExecuted = totalInstructionsExecuted + 1
        } while (index < instructions.count && totalInstructionsExecuted <= 50000)
        
        return String(registers[42])
    }
    
    func parseInstructions(subroutine: [String]) -> [Instruction] {
        var ret = [Instruction]()
        for str in subroutine {
            let components = str.characters.split(separator:" ").map(String.init)
            switch components[0] {
            case "MOV":
                let regs = components[1].characters.split(separator:",").map(String.init)
                if regs[0].hasPrefix("R") {
                    let l = UInt32(regs[0].substring(from:regs[0].index(regs[0].startIndex, offsetBy: 1)))
                    let r = Int(regs[1].substring(from:regs[1].index(regs[1].startIndex, offsetBy: 1)))
                    ret.append(Instruction(InstructionType:.MOVE_FROM_REG, Param_1st:l, Param_2nd:r))
                }
                else {
                    let l = UInt32(regs[0])
                    let r = Int(regs[1].substring(from:regs[1].index(regs[1].startIndex, offsetBy: 1)))
                    ret.append(Instruction(InstructionType:.MOVE_FROM_CONS, Param_1st:l, Param_2nd:r))
                }
            case "ADD":
                let regs = components[1].characters.split(separator:",").map(String.init)
                let l = UInt32(regs[0].substring(from:regs[0].index(regs[0].startIndex, offsetBy: 1)))
                let r = Int(regs[1].substring(from:regs[1].index(regs[1].startIndex, offsetBy: 1)))
                ret.append(Instruction(InstructionType:.ADD, Param_1st:l, Param_2nd:r))
            case "DEC":
                let reg = UInt32(components[1].substring(from:components[1].index(components[1].startIndex, offsetBy: 1)))
                ret.append(Instruction(InstructionType:.DECREASE, Param_1st:reg, Param_2nd:0))
            case "INC":
                let reg = UInt32(components[1].substring(from:components[1].index(components[1].startIndex, offsetBy: 1)))
                ret.append(Instruction(InstructionType:.INCREASE, Param_1st:reg, Param_2nd:0))
            case "INV":
                let reg = UInt32(components[1].substring(from:components[1].index(components[1].startIndex, offsetBy: 1)))
                ret.append(Instruction(InstructionType:.INVERSE, Param_1st:reg, Param_2nd:0))
            case "JMP":
                let d = UInt32(components[1])
                ret.append(Instruction(InstructionType:.JUMP, Param_1st:d, Param_2nd:0))
            case "JZ":
                let d = UInt32(components[1])
                ret.append(Instruction(InstructionType:.JUMP_Z, Param_1st:d, Param_2nd:0))
            case "NOP":
                ret.append(Instruction(InstructionType:.NOTHING, Param_1st:0, Param_2nd:0))
            default:
                break
            }
        }
        return ret
    }
    
    func moveRegister(Rxx:Int, Ryy:Int) {
        registers[Ryy] = registers[Rxx]
    }
    
    func moveConstant(d:UInt32, Rxx:Int) {
        registers[Rxx] = d
    }
    
    func add(Rxx:Int, Ryy:Int) {
        registers[Rxx] = UInt32((UInt64(registers[Rxx]) + UInt64(registers[Ryy])) % 4294967296)
    }
    
    func decreaseByOne(Rxx:Int) {
        guard registers[Rxx] != 0 else {
            registers[Rxx] = 4294967295
            return
        }
        registers[Rxx] = registers[Rxx] - 1
    }
    
    func increaseByOne(Rxx:Int) {
        guard registers[Rxx] != 4294967295 else {
            registers[Rxx] = 0
            return
        }
        registers[Rxx] = registers[Rxx] + 1
    }
    
    func inverse(Rxx:Int) {
        registers[Rxx] = ~registers[Rxx]
    }
}

