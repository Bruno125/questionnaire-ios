////////////////////////////////////////////////////////////////////////////
//
// Copyright 2015 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import XCTest
import Realm
import Realm.Private

#if swift(>=3.0)

class InitLinkedToClass: RLMObject {
    dynamic var value = SwiftIntObject(value: [0])
}

class IgnoredLinkPropertyObject : RLMObject {
    dynamic var value = 0
    var obj = SwiftIntObject()

    override class func ignoredProperties() -> [String] {
        return ["obj"]
    }
}

class SwiftRecursingSchemaTestObject : RLMObject {
    dynamic var propertyWithIllegalDefaultValue: SwiftIntObject? = {
        if mayAccessSchema {
            let realm = RLMRealm.default()
            return SwiftIntObject.allObjects().firstObject() as! SwiftIntObject?
        } else {
            return nil
        }
    }()

    static var mayAccessSchema = false
}

class InitAppendsToArrayProperty : RLMObject {
    dynamic var propertyWithIllegalDefaultValue: RLMArray = {
        if mayAppend {
            let array = RLMArray(objectClassName: SwiftIntObject.className())
            array.add(SwiftIntObject())
            return array
        } else {
            return RLMArray(objectClassName: SwiftIntObject.className())
        }
    }()

    static var mayAppend = false
}

class SwiftSchemaTests: RLMMultiProcessTestCase {
    func testWorksAtAll() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
        }
    }

    func testSchemaInitWithLinkedToObjectUsingInitWithValue() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        let config = RLMRealmConfiguration.default()
        config.objectClasses = [IgnoredLinkPropertyObject.self]
        config.inMemoryIdentifier = #function
        let r = try! RLMRealm(configuration: config)
        try! r.transaction {
            _ = IgnoredLinkPropertyObject.create(in: r, withValue: [1])
        }
    }

    func testCreateUnmanagedObjectWhichCreatesAnotherClassDuringSchemaInit() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        // Should not throw (or crash) despite creating an object with an
        // unintialized schema during schema init
        let _ = InitLinkedToClass()
    }

    func testCreateUnmanagedObjectWithLinkPropertyWithoutSharedSchemaInitialized() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        // This is different from the above test in that it links to an
        // unintialized type rather than creating one
        let _ = SwiftCompanyObject()
    }

    func testCreateUnmanagedObjectWhichCreatesAnotherClassViaInitWithValueDuringSchemaInit() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }
        
        let _ = InitLinkedToClass(value: [[0]])
        let _ = SwiftCompanyObject(value: [[["Jaden", 20, false]]])
    }

    func testInitUnmanagedObjectNotInClassSubsetDuringSchemaInit() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        let config = RLMRealmConfiguration.default()
        config.objectClasses = [IgnoredLinkPropertyObject.self]
        config.inMemoryIdentifier = #function
        let _ = try! RLMRealm(configuration: config)
        let r = try! RLMRealm(configuration: RLMRealmConfiguration.default())
        try! r.transaction {
            _ = IgnoredLinkPropertyObject.create(in: r, withValue: [1])
        }
    }

    func testPreventsDeadLocks() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        SwiftRecursingSchemaTestObject.mayAccessSchema = true
        assertThrowsWithReasonMatching(RLMSchema.shared(), ".*recursive.*")
    }

    func testAccessSchemaCreatesObjectWhichAttempsInsertionsToArrayProperty() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        // This is different from the above tests in that it is a to-many link
        // and it only occurs while the schema is initializing
        InitAppendsToArrayProperty.mayAppend = true
        assertThrowsWithReasonMatching(RLMSchema.shared(), ".*unless the schema is initialized.*")
    }

}

#else

class InitLinkedToClass: RLMObject {
    dynamic var value = SwiftIntObject(value: [0])
}

class IgnoredLinkPropertyObject : RLMObject {
    dynamic var value = 0
    var obj = SwiftIntObject()

    override class func ignoredProperties() -> [String] {
        return ["obj"]
    }
}

class SwiftRecursingSchemaTestObject : RLMObject {
    dynamic var propertyWithIllegalDefaultValue: SwiftIntObject? = {
        if mayAccessSchema {
            let realm = RLMRealm.defaultRealm()
            return SwiftIntObject.allObjects().firstObject() as! SwiftIntObject?
        } else {
            return nil
        }
    }()

    static var mayAccessSchema = false
}

class InitAppendsToArrayProperty : RLMObject {
    dynamic var propertyWithIllegalDefaultValue: RLMArray = {
        if mayAppend {
            let array = RLMArray(objectClassName: SwiftIntObject.className())
            array.addObject(SwiftIntObject())
            return array
        } else {
            return RLMArray(objectClassName: SwiftIntObject.className())
        }
    }()

    static var mayAppend = false
}

class SwiftSchemaTests: RLMMultiProcessTestCase {
    func testWorksAtAll() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
        }
    }

    func testSchemaInitWithLinkedToObjectUsingInitWithValue() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        let config = RLMRealmConfiguration.defaultConfiguration()
        config.objectClasses = [IgnoredLinkPropertyObject.self]
        config.inMemoryIdentifier = #function
        let r = try! RLMRealm(configuration: config)
        try! r.transactionWithBlock {
            IgnoredLinkPropertyObject.createInRealm(r, withValue: [1])
        }
    }

    func testCreateUnmanagedObjectWhichCreatesAnotherClassDuringSchemaInit() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        // Should not throw (or crash) despite creating an object with an
        // unintialized schema during schema init
        let _ = InitLinkedToClass()
    }

    func testCreateUnmanagedObjectWithLinkPropertyWithoutSharedSchemaInitialized() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        // This is different from the above test in that it links to an
        // unintialized type rather than creating one
        let _ = SwiftCompanyObject()
    }

    func testCreateUnmanagedObjectWhichCreatesAnotherClassViaInitWithValueDuringSchemaInit() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }
        
        let _ = InitLinkedToClass(value: [[0]])
        let _ = SwiftCompanyObject(value: [[["Jaden", 20, false]]])
    }

    func testInitUnmanagedObjectNotInClassSubsetDuringSchemaInit() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        let config = RLMRealmConfiguration.defaultConfiguration()
        config.objectClasses = [IgnoredLinkPropertyObject.self]
        config.inMemoryIdentifier = #function
        let _ = try! RLMRealm(configuration: config)
        let r = try! RLMRealm(configuration: RLMRealmConfiguration.defaultConfiguration())
        try! r.transactionWithBlock {
            IgnoredLinkPropertyObject.createInRealm(r, withValue: [1])
        }
    }

    func testPreventsDeadLocks() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        SwiftRecursingSchemaTestObject.mayAccessSchema = true
        assertThrowsWithReasonMatching(RLMSchema.sharedSchema(), ".*recursive.*")
    }

    func testAccessSchemaCreatesObjectWhichAttempsInsertionsToArrayProperty() {
        if isParent {
            XCTAssertEqual(0, runChildAndWait(), "Tests in child process failed")
            return
        }

        // This is different from the above tests in that it is a to-many link
        // and it only occurs while the schema is initializing
        InitAppendsToArrayProperty.mayAppend = true
        assertThrowsWithReasonMatching(RLMSchema.sharedSchema(), ".*unless the schema is initialized.*")
    }

}

#endif
