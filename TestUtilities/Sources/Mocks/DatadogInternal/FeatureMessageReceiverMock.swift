/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

import Foundation
import DatadogInternal

public struct FeatureMessageReceiverMock: FeatureMessageReceiver {
    public typealias ReceiverClosure = (FeatureMessage) -> Void

    @ReadWriteLock
    public private(set) var messages: [FeatureMessage] = []

    public var receiver: ReceiverClosure?

    /// Creates a Feature Message Receiever  mock.
    /// - Parameters:
    ///   - expectation: Test expectation that will be fullfilled when a message is
    ///                  received.
    ///   - receiver: The receiver closure called when receiving a message.
    public init(receiver: ReceiverClosure? = nil) {
        self.receiver = receiver
    }

    public func receive(message: FeatureMessage, from core: DatadogCoreProtocol) -> Bool {
        messages.append(message)
        receiver?(message)
        return true
    }
}
