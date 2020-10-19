import XCTest

import dozerTests

var tests = [XCTestCaseEntry]()
tests += dozerTests.allTests()
XCTMain(tests)
