import Foundation

extension UserDefaults{
    
    /// Use the NSKeyedArchiver to archive the given value and set it into the UserDefaults by the given key
    @available(OSX 10.13, *)
    public func setKeyedArchiver<T>(value: T?, key: String){
        if let val = value {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: val, requiringSecureCoding: false)
            if data != nil{
                self.set(data, forKey: key)
            }
        } else{
            self.removeObject(forKey: key)
        }
    }
    
    /// Get the value by the provided key and use the NSKeyedUnarchiver to unarchive the value (if not nil)
    @available(OSX 10.13, *)
    public func getKeyedArchiver<T>(key: String) -> T? where T : NSObject, T : NSCoding {
        let data = self.object(forKey: key) as? Data
        if data == nil { return nil }
        
        let result = try? NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data!)
        return result
    }
    
    /// Use the JSONEncoder to encode the given value and set it into the UserDefaults by the given key
    public func setCodable<T>(value: T?, key: String) where T : Codable{
        if let val = value {
            if let json = try? JSONEncoder().encode(val) {
                self.set(json, forKey: key)
            }
        } else{
            self.removeObject(forKey: key)
        }
    }
    
    /// Get the value by the provided key and use the JSONDecoder to decode the value (if not nil)
    public func getCodable<T>(key: String) -> T? where T : Codable {
        if let data = self.object(forKey: key) as? Data {
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                return result
            }
        }
        return nil
    }

    
}


@propertyWrapper
public struct JsonUserDefault<Value> where Value : Codable{
    var store : UserDefaults
    var key : String
    var defaultValue : Value
    init(storeIn : UserDefaults, withKey: String, defaults: Value){
        self.store = storeIn
        self.key = withKey
        self.defaultValue = defaults
    }
    
    public var wrappedValue: Value {
        get {
            let val : Value? = self.store.getCodable(key: self.key)
            guard let result = val else {return self.defaultValue}
            return result
        }
        set {
            self.store.setCodable(value: newValue, key: self.key)
        }
    }
}

@propertyWrapper
public struct NSKeyedUnarchivedUserDefault<NSCodingType> where NSCodingType : NSObject, NSCodingType : NSCoding{
    var store : UserDefaults
    var key : String
    var defaultValue : Optional<NSCodingType>
    init(storeIn : UserDefaults, withKey: String, defaults: NSCodingType?){
        self.store = storeIn
        self.key = withKey
        self.defaultValue = defaults
    }

    @available(OSX 10.13, *)
    public var wrappedValue: NSCodingType? {
        get {
            let val : NSCodingType? = self.store.getKeyedArchiver(key: self.key)
            guard let result = val else {return self.defaultValue}
            return result
        }
        set {
            self.store.setKeyedArchiver(value: newValue, key: self.key)
        }
    }
}
