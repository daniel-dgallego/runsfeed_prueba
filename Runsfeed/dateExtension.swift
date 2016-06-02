//
//  dateExtension.swift
//  TimeMap
//
//  Created by Daniel Gallego Peralta on 8/11/15.
//  Copyright © 2015 danigp.es. All rights reserved.
//

import Foundation

extension NSDate{
    
    func nombreExtension()->String{
        return "Extension create for show date"
    }
    
    func dia()->String{
    
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Day , fromDate: self)
        
        if components.day > 9{
            return String(components.day)
        }
        else{
            return String("0\(components.day)")
        }
    }
    
    
    func mes()->String{
        
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month , fromDate: self)
        
        if components.month > 9{
            return String(components.month)
        }
        else{
            return String("0\(components.month)")
        }
    }
    
    
    func año()->String{
        
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Year , fromDate: self)
        
       
        return String(components.year)
       
    }
    
    
    func minuto()->String{
        
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute , fromDate: self)
        
        if components.minute > 9{
            return String(components.minute)
        }
        else{
            return String("0\(components.minute)")
        }
    }
    
    
    func hora()->String{
        
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour , fromDate: self)
        
        if components.hour > 9{
            return String(components.hour)
        }
        else{
            return String("0\(components.hour)")
        }
    }
    
    
    func segundo()->String{
        
        
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Second , fromDate: self)
        
        if components.second > 9{
            return String(components.second)
        }
        else{
            return String("0\(components.second)")
        }
    }
    
    
    func hoyPrimerSegundo()->NSDate{
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Hour , fromDate: now)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.dateFromComponents(components)!
    }
    
    func hoyUltimoSegundo()->NSDate{
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Hour , fromDate: now)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return calendar.dateFromComponents(components)!
    }
    
    
    func fechaCompleta()->String{
        return "\(self.dia())-\(self.mes())-\(self.año())"
    }
    
    
    
    func horaCompleta()->String{
        return "\(self.hora()):\(self.minuto())"
    }
    
    
    func fechaCompletaForDjango()->String{
        return "\(self.año())-\(self.mes())-\(self.dia()) \(self.hora()):\(self.minuto()):\(self.segundo())"
    }
    
    
}
