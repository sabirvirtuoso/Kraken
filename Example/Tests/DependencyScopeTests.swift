//
//  Kraken
//
//  Copyright (c) 2016 Syed Sabir Salman-Al-Musawi <sabirvirtuoso@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
@testable import Kraken

private protocol Service: Injectable {
}

private protocol Service2: Injectable {
}

private protocol Service3: Injectable {
}

private class ServiceImpl1: Service {
    required init() {
    }
}

private class ServiceImpl2: Service2 {
    required init() {
    }
}

private class ServiceImpl3: Service3 {
    required init() {
    }
}

class DependencyScopeTests: XCTestCase {

    override func setUp() {
        Kraken.reset()
    }

    func testThatPrototypeIsDefaultScopeForImplementationType() {
        // given
        Kraken.register(Service.self, implementationType: ServiceImpl1.self)

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.prototype)
    }

    func testThatPrototypeIsDefaultScopeForFactoryWithNoArgument() {
        // given
        Kraken.register(Service.self, factory: { ServiceImpl1() as Service })

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.prototype)
    }

    func testThatPrototypeIsDefaultScopeForFactoryWithOneArgument() {
        // given
        try! Kraken.register(Service.self) { (a1: Int) -> Injectable in

            return ServiceImpl1() as Service
        }

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.prototype)
    }

    func testThatPrototypeIsDefaultScopeForFactoryWithTwoArguments() {
        // given
        try! Kraken.register(Service.self) { (a1: Int, a2: Int) -> Injectable in

            return ServiceImpl1() as Service
        }

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.prototype)
    }

    func testThatPrototypeIsDefaultScopeForFactoryWithThreeArguments() {
        // given
        try! Kraken.register(Service.self) { (a1: Int, a2: Int, a3: Int) -> Injectable in

            return ServiceImpl1() as Service
        }

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.prototype)
    }

    func testThatScopeCanBeChangedForImplementationType() {
        // given
        Kraken.register(Service.self, implementationType: ServiceImpl1.self, scope: .singleton)

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.singleton)
    }

    func testThatScopeCanBeChangedForFactoryWithNoArgument() {
        // given
        Kraken.register(Service.self, scope: .singleton, factory: { ServiceImpl1() as Service })

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.singleton)
    }

    func testThatScopeCanBeChangedForFactoryWithOneArgument() {
        // given
        try! Kraken.register(Service.self, scope: .singleton) { (a1: Int) -> Injectable in

            return ServiceImpl1() as Service
        }

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.singleton)
    }

    func testThatScopeCanBeChangedForFactoryWithTwoArguments() {
        // given
        try! Kraken.register(Service.self, scope: .singleton) { (a1: Int, a2: Int) -> Injectable in

            return ServiceImpl1() as Service
        }

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.singleton)
    }

    func testThatScopeCanBeChangedForFactoryWithThreeArguments() {
        // given
        try! Kraken.register(Service.self, scope: .singleton) { (a1: Int, a2: Int, a3: Int) -> Injectable in

            return ServiceImpl1() as Service
        }

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.singleton)
    }

    func testThatItResolvesTypeAsNewInstanceForPrototypeScopeOfImplementationType() {
        // given
        Kraken.register(Service.self, implementationType: ServiceImpl1.self)

        // when
        let service1: Service = inject(Service.self)
        let service2: Service = inject(Service.self)

        // then
        XCTAssertFalse(service1 === service2)
    }

    func testThatItResolvesTypeAsNewInstanceForPrototypeScopeOfFactoryWithNoArgument() {
        // given
        Kraken.register(Service.self, factory: { ServiceImpl1() as Service })

        // when
        let service1: Service = inject(Service.self)
        let service2: Service = inject(Service.self)

        // then
        XCTAssertFalse(service1 === service2)
    }

    func testThatItResolvesTypeAsNewInstanceForPrototypeScopeOfFactoryWithOneArgument() {
        // given
        let arg1 = 1

        try! Kraken.register(Service.self) { (a1: Int) -> Injectable in
            XCTAssertEqual(a1, arg1)

            return ServiceImpl1() as Service
        }

        // when
        let service1: Service = inject(Service.self, withArguments: arg1)
        let service2: Service = inject(Service.self, withArguments: arg1)

        // then
        XCTAssertFalse(service1 === service2)
    }

    func testThatItResolvesTypeAsNewInstanceForPrototypeScopeOfFactoryWithTwoArguments() {
        // given
        let arg1 = 1, arg2 = 2

        try! Kraken.register(Service.self) { (a1: Int, a2: Int) -> Injectable in
            XCTAssertEqual(a1, arg1)
            XCTAssertEqual(a2, arg2)

            return ServiceImpl1() as Service
        }

        // when
        let service1: Service = inject(Service.self, withArguments: arg1, arg2)
        let service2: Service = inject(Service.self, withArguments: arg1, arg2)

        // then
        XCTAssertFalse(service1 === service2)
    }

    func testThatItResolvesTypeAsNewInstanceForPrototypeScopeOfFactoryWithThreeArgument() {
        // given
        let arg1 = 1, arg2 = 2, arg3 = 3

        try! Kraken.register(Service.self) { (a1: Int, a2: Int, a3: Int) -> Injectable in
            XCTAssertEqual(a1, arg1)
            XCTAssertEqual(a2, arg2)
            XCTAssertEqual(a3, arg3)

            return ServiceImpl1() as Service
        }

        // when
        let service1: Service = inject(Service.self, withArguments: arg1, arg2, arg3)
        let service2: Service = inject(Service.self, withArguments: arg1, arg2, arg3)

        // then
        XCTAssertFalse(service1 === service2)
    }

    func testThatItReusesInstanceForSingletonScopeOfImplementationType() {

        func test(_ scope: DependencyScope) {
            // given
            Kraken.register(Service.self, implementationType: ServiceImpl1.self, scope: scope)

            // when
            let service1: Service = inject(Service.self)
            let service2: Service = inject(Service.self)

            // then
            XCTAssertTrue(service1 === service2)
        }

        test(.singleton)
        test(.eagerSingleton)
    }

    func testThatItReusesInstanceForSingletonScopeOfFactoryWithNoArgument() {

        func test(_ scope: DependencyScope) {
            // given
            Kraken.register(Service.self, scope: .singleton, factory: { ServiceImpl1() as Service })

            // when
            let service1: Service = inject(Service.self)
            let service2: Service = inject(Service.self)

            // then
            XCTAssertTrue(service1 === service2)
        }

        test(.singleton)
        test(.eagerSingleton)
    }

    func testThatItReusesInstanceForSingletonScopeOfFactoryWithOneArgument() {

        func test(_ scope: DependencyScope) {
            // given
            let arg1 = 1

            try! Kraken.register(Service.self, scope: .singleton) { (a1: Int) -> Injectable in
                XCTAssertEqual(a1, arg1)

                return ServiceImpl1() as Service
            }

            // when
            let service1: Service = inject(Service.self, withArguments: arg1)
            let service2: Service = inject(Service.self, withArguments: arg1)

            // then
            XCTAssertTrue(service1 === service2)
        }

        test(.singleton)
    }

    func testThatItReusesInstanceForSingletonScopeOfFactoryWithTwoArguments() {

        func test(_ scope: DependencyScope) {
            // given
            let arg1 = 1, arg2 = 2

            try! Kraken.register(Service.self, scope: .singleton) { (a1: Int, a2: Int) -> Injectable in
                XCTAssertEqual(a1, arg1)
                XCTAssertEqual(a2, arg2)

                return ServiceImpl1() as Service
            }

            // when
            let service1: Service = inject(Service.self, withArguments: arg1, arg2)
            let service2: Service = inject(Service.self, withArguments: arg1, arg2)

            // then
            XCTAssertTrue(service1 === service2)
        }

        test(.singleton)
    }

    func testThatItReusesInstanceForSingletonScopeOfFactoryWithThreeArguments() {

        func test(_ scope: DependencyScope) {
            // given
            let arg1 = 1, arg2 = 2, arg3 = 3

            try! Kraken.register(Service.self, scope: .singleton) { (a1: Int, a2: Int, a3: Int) -> Injectable in
                XCTAssertEqual(a1, arg1)
                XCTAssertEqual(a2, arg2)
                XCTAssertEqual(a3, arg3)

                return ServiceImpl1() as Service
            }

            // when
            let service1: Service = inject(Service.self, withArguments: arg1, arg2, arg3)
            let service2: Service = inject(Service.self, withArguments: arg1, arg2, arg3)

            // then
            XCTAssertTrue(service1 === service2)
        }

        test(.singleton)
    }

    func testThatSingletonIsReleasedWhenDefinitionIsRemoved() {

        func test(_ scope: DependencyScope) {
            // given
            Kraken.register(Service.self, implementationType: ServiceImpl1.self, scope: scope)
            let service1: Service = inject(Service.self)

            // when
            Kraken.remove(Service.self)

            // then
            XCTAssertNotNil(service1)
            XCTAssertNil(Kraken.definitionMap[String(describing: Service.self)])
            XCTAssertNil(Kraken.singletons[String(describing: Service.self)])
        }

        test(.singleton)
        test(.eagerSingleton)
    }

    func testThatSingletonIsReleasedWhenContainerIsReset() {

        func test(_ scope: DependencyScope) {
            // given
            Kraken.register(Service.self, implementationType: ServiceImpl1.self, scope: scope)
            let service1: Service = inject(Service.self)

            // when
            Kraken.reset()

            // then
            XCTAssertNotNil(service1)
            XCTAssertNil(Kraken.definitionMap[String(describing: Service.self)])
            XCTAssertNil(Kraken.singletons[String(describing: Service.self)])
        }

        test(.singleton)
        test(.eagerSingleton)
    }

    func testThatOnlyEagerSingletonIsCreatedWhenContainerIsBootsrapped() {
        // given

        // when
        Kraken.register(Service.self, implementationType: ServiceImpl1.self, scope: .eagerSingleton)
        Kraken.register(Service2.self, implementationType: ServiceImpl2.self, scope: .singleton)
        Kraken.register(Service3.self, scope: .eagerSingleton, factory: { ServiceImpl3() as Service3 })

        // then
        XCTAssertNotNil(Kraken.singletons[String(describing: Service.self)])
        XCTAssertNotNil(Kraken.singletons[String(describing: Service3.self)])
        XCTAssertNil(Kraken.singletons[String(describing: Service2.self)])
    }

    func testThatItThrowsErrorIfScopeIsEagerSingletonForFactoryWithOneArgument() {
        // given

        // when
        AssertThrows(expression: try Kraken.register(Service.self, scope: .eagerSingleton) { (a1: Int) -> Injectable in

            return ServiceImpl1() as Service

        }) { error in
            guard case let KrakenError.eagerSingletonNotAllowed(key) = error else {
                return false
            }

            // then
            let expectedKey = String(describing: Service.self)
            XCTAssertEqual(key, expectedKey)

            return true
        }
    }

    func testThatItThrowsErrorIfScopeIsEagerSingletonForFactoryWithTwoArguments() {
        // given

        // when
        AssertThrows(expression: try Kraken.register(Service.self, scope: .eagerSingleton) { (a1: Int, a2: Int) -> Injectable in

            return ServiceImpl1() as Service
        }) { error in
            guard case let KrakenError.eagerSingletonNotAllowed(key) = error else {
                return false
            }

            // then
            let expectedKey = String(describing: Service.self)
            XCTAssertEqual(key, expectedKey)

            return true
        }
    }

    func testThatItThrowsErrorIfScopeIsEagerSingletonForFactoryWithThreeArguments() {
        // given

        // when
        AssertThrows(expression: try Kraken.register(Service.self, scope: .eagerSingleton) { (a1: Int, a2: Int, a3: Int) -> Injectable in

            return ServiceImpl1() as Service
        }) { error in
            guard case let KrakenError.eagerSingletonNotAllowed(key) = error else {
                return false
            }

            // then
            let expectedKey = String(describing: Service.self)
            XCTAssertEqual(key, expectedKey)

            return true
        }
    }

    func testThatScopeIsEagerSingletonForDependencyRegisteredWithImplementation() {
        // given
        Kraken.register(Service.self, implementation: ServiceImpl1())

        // when
        let serviceDefinition = Kraken.definitionMap[String(describing: Service.self)]

        // then
        XCTAssertEqual(serviceDefinition!.scope, DependencyScope.eagerSingleton)
    }

}
