import XCTest
@testable import UserDefaultsEx

struct CodableTestSetting : Codable{
    var prop1 = ""
    var nested = CodableNestedSetting()
}

struct CodableNestedSetting : Codable{
    var nestedPropStr = ""
    var nestedPropInt = 5
}

class CodingTestSetting : NSObject, NSCoding, NSSecureCoding{
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(self.prop1, forKey: "prop1")
        coder.encode(self.nested, forKey: "nested")
    }
    
    override init(){
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.prop1 = coder.decodeObject(forKey: "prop1") as! String
        self.nested = coder.decodeObject(of: CodingNestedSetting.self, forKey: "nested")!
    }
    
    var prop1 = ""
    var nested = CodingNestedSetting()
}

class CodingNestedSetting : NSObject, NSCoding, NSSecureCoding{
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(self.nestedPropInt, forKey: "nestedPropInt")
        coder.encode(self.nestedPropStr, forKey: "nestedPropStr")
    }
    
    required init?(coder: NSCoder) {
        self.nestedPropInt = coder.decodeInteger(forKey: "nestedPropInt")
        self.nestedPropStr = coder.decodeObject(forKey: "nestedPropStr") as! String
    }
    
    override init(){
        super.init()
    }
    
    var nestedPropStr = ""
    var nestedPropInt = 5
}

extension UserDefaults{
    @JsonUserDefault(storeIn: UserDefaults.standard, withKey: "someCodableSettings", defaults: CodableTestSetting())
    static var someCodableSettings : CodableTestSetting
    
    @NSKeyedUnarchivedUserDefault(storeIn: UserDefaults.standard, withKey: "someCodingSettings", defaults: CodingTestSetting())
    static var someCodingSettings : CodingTestSetting?
}

final class UserDefaultsExTests: XCTestCase {
    func testJsonDefaults() {
        
        UserDefaults.someCodableSettings.prop1 = "foo"
        XCTAssertEqual(UserDefaults.someCodableSettings.prop1, "foo")
        
        UserDefaults.someCodableSettings.prop1 = "bar"
        XCTAssertEqual(UserDefaults.someCodableSettings.prop1, "bar")
        
        UserDefaults.someCodableSettings.nested.nestedPropStr = "value-1"
        UserDefaults.someCodableSettings.nested.nestedPropInt = 2
        
        
        XCTAssertEqual(UserDefaults.someCodableSettings.nested.nestedPropStr, "value-1")
        XCTAssertEqual(UserDefaults.someCodableSettings.nested.nestedPropInt, 2)
        
        let data = UserDefaults.standard.object(forKey: "someCodableSettings") as! Data
        let actual = try! JSONDecoder().decode(CodableTestSetting.self, from: data)
    
        XCTAssertEqual(UserDefaults.someCodableSettings.prop1, actual.prop1)
        XCTAssertEqual(UserDefaults.someCodableSettings.nested.nestedPropInt, actual.nested.nestedPropInt)
        XCTAssertEqual(UserDefaults.someCodableSettings.nested.nestedPropStr, actual.nested.nestedPropStr)
    }
    
    
    func testNSAchriveDefaults() {

        let settings = CodingTestSetting()
        settings.prop1 = "foo"
        settings.nested.nestedPropStr = "value-1"
        settings.nested.nestedPropInt = 2
        
        UserDefaults.someCodingSettings = settings
        
        XCTAssertEqual(UserDefaults.someCodingSettings!.prop1, "foo")
        XCTAssertEqual(UserDefaults.someCodingSettings!.nested.nestedPropStr, "value-1")
        XCTAssertEqual(UserDefaults.someCodingSettings!.nested.nestedPropInt, 2)

        let data = UserDefaults.standard.object(forKey: "someCodingSettings") as! Data
        let actual = try! NSKeyedUnarchiver.unarchivedObject(ofClass: CodingTestSetting.self, from: data)!

        XCTAssertEqual(UserDefaults.someCodingSettings!.prop1, actual.prop1)
        XCTAssertEqual(UserDefaults.someCodingSettings!.nested.nestedPropInt, actual.nested.nestedPropInt)
        XCTAssertEqual(UserDefaults.someCodingSettings!.nested.nestedPropStr, actual.nested.nestedPropStr)
    }

    static var allTests = [
        ("testJsonDefaults", testJsonDefaults),
    ]
}
