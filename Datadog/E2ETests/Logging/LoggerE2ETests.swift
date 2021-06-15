/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Datadog

class LoggerE2ETests: E2ETests {
    private var logger: Logger! // swiftlint:disable:this implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        logger = Logger.builder.build()
    }

    override func tearDown() {
        logger = nil
        super.tearDown()
    }

    // MARK: - Logging Method

    /// - api-surface: Logger.debug(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    ///
    /// - data monitor:
    /// ```logs
    /// $monitor_id = logs_logger_debug_log_data
    /// $monitor_name = "[RUM] [iOS] Nightly - logs_logger_debug_log: number of logs is below expected value"
    /// $monitor_query = "logs(\"service:com.datadog.ios.nightly @test_method_name:logs_logger_debug_log status:debug\").index(\"*\").rollup(\"count\").last(\"1d\") < 1"
    /// ```
    ///
    /// - performance monitor:
    /// ```apm
    /// $monitor_id = logs_logger_debug_log_performance
    /// $monitor_name = "[RUM] [iOS] Nightly Performance - logs_logger_debug_log: has a high average execution time"
    /// $monitor_query = "avg(last_1d):p50:trace.logs_logger_debug_log{env:instrumentation,resource_name:logs_logger_debug_log,service:com.datadog.ios.nightly} > 0.024"
    /// ```
    func test_logs_logger_DEBUG_log() {
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.debug(.mockRandom(), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.debug(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    ///
    /// - data monitor:
    /// ```logs
    /// $monitor_id = logs_logger_debug_log_with_error_data
    /// $monitor_name = "[RUM] [iOS] Nightly - logs_logger_debug_log_with_error: number of logs is below expected value"
    /// $monitor_query = "logs(\"service:com.datadog.ios.nightly @test_method_name:logs_logger_debug_log_with_error status:debug\").index(\"*\").rollup(\"count\").last(\"1d\") < 1"
    /// ```
    ///
    /// - performance monitor:
    /// ```apm
    /// $monitor_id = logs_logger_debug_log_with_error_performance
    /// $monitor_name = "[RUM] [iOS] Nightly Performance - logs_logger_debug_log_with_error: has a high average execution time"
    /// $monitor_query = "avg(last_1d):p50:trace.logs_logger_debug_log_with_error{env:instrumentation,resource_name:logs_logger_debug_log_with_error*,service:com.datadog.ios.nightly} > 0.024"
    /// ```
    func test_logs_logger_DEBUG_log_with_error() {
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.debug(.mockRandom(), error: ErrorMock(.mockRandom()), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.info(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_INFO_log() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.info(.mockRandom(), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.info(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_INFO_log_with_error() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.info(.mockRandom(), error: ErrorMock(.mockRandom()), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.notice(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_NOTICE_log() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.notice(.mockRandom(), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.notice(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_NOTICE_log_with_error() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.notice(.mockRandom(), error: ErrorMock(.mockRandom()), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.warn(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_WARN_log() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.warn(.mockRandom(), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.warn(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_WARN_log_with_error() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.warn(.mockRandom(), error: ErrorMock(.mockRandom()), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.error(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_ERROR_log() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.error(.mockRandom(), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.error(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_ERROR_log_with_error() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.error(.mockRandom(), error: ErrorMock(.mockRandom()), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.critical(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_CRITICAL_log() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.critical(.mockRandom(), attributes: DD.logAttributes())
        }
    }

    /// - api-surface: Logger.critical(_ message: String, error: Error? = nil, attributes: [AttributeKey: AttributeValue]? = nil)
    func test_logs_logger_CRITICAL_log_with_error() { // E2E:wip
        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.critical(.mockRandom(), error: ErrorMock(.mockRandom()), attributes: DD.logAttributes())
        }
    }

    // MARK: - Adding Attributes

    /// - api-surface: Logger.addAttribute(forKey key: AttributeKey, value: AttributeValue)
    func test_logs_logger_add_STRING_attribute() { // E2E:wip
        let attribute = DD.specialStringAttribute()

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.addAttribute(forKey: attribute.key, value: attribute.value)
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }

    /// - api-surface: Logger.addAttribute(forKey key: AttributeKey, value: AttributeValue)
    func test_logs_logger_add_INT_attribute() { // E2E:wip
        let attribute = DD.specialIntAttribute()

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.addAttribute(forKey: attribute.key, value: attribute.value)
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }

    /// - api-surface: Logger.addAttribute(forKey key: AttributeKey, value: AttributeValue)
    func test_logs_logger_add_DOUBLE_attribute() { // E2E:wip
        let attribute = DD.specialDoubleAttribute()

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.addAttribute(forKey: attribute.key, value: attribute.value)
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }

    /// - api-surface: Logger.addAttribute(forKey key: AttributeKey, value: AttributeValue)
    func test_logs_logger_add_BOOL_attribute() { // E2E:wip
        let attribute = DD.specialBoolAttribute()

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.addAttribute(forKey: attribute.key, value: attribute.value)
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }

    // MARK: - Removing Attributes

    /// - api-surface: Logger.removeAttribute(forKey key: AttributeKey)
    func test_logs_logger_remove_attribute() { // E2E:wip
        let possibleAttributes = [
            DD.specialStringAttribute(),
            DD.specialIntAttribute(),
            DD.specialDoubleAttribute(),
            DD.specialBoolAttribute()
        ]
        let randomAttribute = possibleAttributes.randomElement()!

        logger.addAttribute(forKey: randomAttribute.key, value: randomAttribute.value)

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.removeAttribute(forKey: randomAttribute.key)
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }

    // MARK: - Adding Tags

    /// - api-surface: Logger.addTag(withKey key: String, value: String)
    func test_logs_logger_add_tag() { // E2E:wip
        let tag = DD.specialStringTag()

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.addTag(withKey: tag.key, value: tag.value)
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }

    /// - api-surface: Logger.add(tag: String)
    func test_logs_logger_add_already_formatted_tag() { // E2E:wip
        let tag = DD.specialStringTag()

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.add(tag: "\(tag.key):\(tag.value)")
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }

    // MARK: - Removing Tags

    /// - api-surface: Logger.removeTag(withKey key: String)
    func test_logs_logger_remove_tag() { // E2E:wip
        let tag = DD.specialStringTag()
        logger.addTag(withKey: tag.key, value: tag.value)

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.removeTag(withKey: tag.key)
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }

    /// - api-surface: Logger.remove(tag: String)
    func test_logs_logger_remove_already_formatted_tag() { // E2E:wip
        let tag = DD.specialStringTag()
        logger.add(tag: "\(tag.key):\(tag.value)")

        measure(spanName: DD.PerfSpanName.fromCurrentMethodName()) {
            logger.remove(tag: "\(tag.key):\(tag.value)")
        }

        logger.sendRandomLog(with: DD.logAttributes())
    }
}
