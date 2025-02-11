/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at Datadog (https://www.datadoghq.com/).
* Copyright 2019-2020 Datadog, Inc.
*/

import Foundation

/// Type-safe Swift ↔ Objc interopability schema.
internal protocol ObjcInteropType: AnyObject {}

/// Any `@objc class` which manages Swift `struct`.
internal protocol ObjcInteropClass: ObjcInteropType {
    var bridgedSwiftStruct: SwiftStruct { get }
    var objcPropertyWrappers: [ObjcInteropPropertyWrapper] { set get }
}

/// Schema of a root `@objc class` storing the mutable value of a `SwiftStruct`.
internal class ObjcInteropRootClass: ObjcInteropClass {
    /// The `SwiftStruct` managed by this `@objc class`.
    let bridgedSwiftStruct: SwiftStruct
    /// `bridgedSwiftStruct's` property wrappers exposed to Objc.
    var objcPropertyWrappers: [ObjcInteropPropertyWrapper] = []

    init(bridgedSwiftStruct: SwiftStruct) {
        self.bridgedSwiftStruct = bridgedSwiftStruct
    }
}

/// Schema of a transitive `@objc class` managing the access to the nested `SwiftStruct`.
internal class ObjcInteropTransitiveNestedClass: ObjcInteropClass {
    /// Property wrapper in the parent class, which stores the definition of this transitive class.
    private(set) unowned var parentProperty: ObjcInteropPropertyWrapper

    /// The nested `SwiftStruct` managed by this `@objc class`.
    let bridgedSwiftStruct: SwiftStruct
    /// `bridgedSwiftStruct's` property wrappers exposed to Objc.
    var objcPropertyWrappers: [ObjcInteropPropertyWrapper] = []

    init(owner: ObjcInteropPropertyWrapper, bridgedSwiftStruct: SwiftStruct) {
        self.parentProperty = owner
        self.bridgedSwiftStruct = bridgedSwiftStruct
    }
}

/// Schema of a transitive `@objc class` managing the access to a nested `SwiftStruct` referenced using `SwiftTypeReference`.
internal class ObjcInteropReferencedTransitiveClass: ObjcInteropTransitiveNestedClass {}

/// Schema of a non-transitive `@objc class` exposing values of nested `SwiftStruct`.
internal class ObjcInteropNestedClass: ObjcInteropClass {
    /// Property wrapper in the parent class, which stores the definition of this transitive class.
    private(set) unowned var parentProperty: ObjcInteropPropertyWrapper

    /// The `SwiftStruct` managed by this `@objc class`.
    let bridgedSwiftStruct: SwiftStruct
    /// `bridgedSwiftStruct's` property wrappers exposed to Objc.
    var objcPropertyWrappers: [ObjcInteropPropertyWrapper] = []

    init(owner: ObjcInteropPropertyWrapper, bridgedSwiftStruct: SwiftStruct) {
        self.parentProperty = owner
        self.bridgedSwiftStruct = bridgedSwiftStruct
    }
}

/// Schema of an `@objc enum` exposing values for the `SwiftEnum`.
internal class ObjcInteropEnum: ObjcInteropType {
    /// Property wrapper in the parent class, which stores the definition of this enum.
    private(set) unowned var parentProperty: ObjcInteropPropertyWrapper
    /// The `SwiftEnum` exposed by this Obj-c enum.
    let bridgedSwiftEnum: SwiftEnum

    init(owner: ObjcInteropPropertyWrapper, bridgedSwiftEnum: SwiftEnum) {
        self.parentProperty = owner
        self.bridgedSwiftEnum = bridgedSwiftEnum
    }
}

/// Schema of an `@objc enum` exposing values of the `SwiftEnum` referenced using `SwiftTypeReference`.
internal class ObjcInteropReferencedEnum: ObjcInteropEnum {}

/// Schema of an `@objc enum` exposing values of an array of `SwiftEnums`.
internal class ObjcInteropEnumArray: ObjcInteropEnum {}

// MARK: - Property wrapper schemas

/// Schema fo an `@objc` property which manages the access to the `SwiftStruct's` property.
internal class ObjcInteropPropertyWrapper: ObjcInteropType {
    /// The `@objc class` owning this property.
    private(set) unowned var owner: ObjcInteropClass
    /// Corresponding Swift property in `SwiftStruct`.
    let bridgedSwiftProperty: SwiftStruct.Property

    init(owner: ObjcInteropClass, swiftProperty: SwiftStruct.Property) {
        self.owner = owner
        self.bridgedSwiftProperty = swiftProperty
    }
}

/// A property wrapper which uses another `ObjcInteropType` for managing acces to a property in nested `SwiftStruct`.
internal protocol ObjcInteropPropertyWrapperForTransitiveType {
    var objcTransitiveType: ObjcInteropType { get }
}

/// Schema of an `@objc` property managing access to the nested `SwiftStruct`.
internal class ObjcInteropPropertyWrapperAccessingNestedStruct: ObjcInteropPropertyWrapper, ObjcInteropPropertyWrapperForTransitiveType {
    var objcNestedClass: ObjcInteropTransitiveNestedClass! // swiftlint:disable:this implicitly_unwrapped_optional
    var objcTransitiveType: ObjcInteropType { objcNestedClass }
}

/// Schema of an `@objc` property managing access to the nested `SwiftEnum`.
internal class ObjcInteropPropertyWrapperAccessingNestedEnum: ObjcInteropPropertyWrapper, ObjcInteropPropertyWrapperForTransitiveType {
    var objcNestedEnum: ObjcInteropEnum! // swiftlint:disable:this implicitly_unwrapped_optional
    var objcTransitiveType: ObjcInteropType { objcNestedEnum }
}

/// Schema of an `@objc` property managing access to the array of `SwiftEnums`.
internal class ObjcInteropPropertyWrapperAccessingNestedEnumsArray: ObjcInteropPropertyWrapper, ObjcInteropPropertyWrapperForTransitiveType {
    var objcNestedEnumsArray: ObjcInteropEnumArray! // swiftlint:disable:this implicitly_unwrapped_optional
    var objcTransitiveType: ObjcInteropType { objcNestedEnumsArray }
}

/// Schema of an `@objc` property managing access to the array of `SwiftStructs`.
internal class ObjcInteropPropertyWrapperAccessingNestedStructsArray: ObjcInteropPropertyWrapper, ObjcInteropPropertyWrapperForTransitiveType {
    var objcNestedClass: ObjcInteropNestedClass! // swiftlint:disable:this implicitly_unwrapped_optional
    var objcTransitiveType: ObjcInteropType { objcNestedClass }
}

/// Schema of an `@objc` property managing access to a property of the `SwiftStruct`.
internal class ObjcInteropPropertyWrapperManagingSwiftStructProperty: ObjcInteropPropertyWrapper {
    var objcInteropType: ObjcInteropType! // swiftlint:disable:this implicitly_unwrapped_optional
}

// MARK: - Plain type schemas

internal class ObjcInteropNSNumber: ObjcInteropType {
    let swiftType: SwiftType

    init(swiftType: SwiftType) {
        self.swiftType = swiftType
    }
}

internal class ObjcInteropNSString: ObjcInteropType {
    let swiftString: SwiftPrimitive<String>

    init(swiftString: SwiftPrimitive<String>) {
        self.swiftString = swiftString
    }
}

internal class ObjcInteropAny: ObjcInteropType {
    let swiftType: SwiftPrimitiveNoObjcInteropType

    init(swiftType: SwiftPrimitiveNoObjcInteropType) {
        self.swiftType = swiftType
    }
}

internal class ObjcInteropNSArray: ObjcInteropType {
    let element: ObjcInteropType

    init(element: ObjcInteropType) {
        self.element = element
    }
}

internal class ObjcInteropNSDictionary: ObjcInteropType {
    let key: ObjcInteropType
    let value: ObjcInteropType

    init(key: ObjcInteropType, value: ObjcInteropType) {
        self.key = key
        self.value = value
    }
}
