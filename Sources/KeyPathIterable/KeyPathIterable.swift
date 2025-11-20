public protocol KeyPathIterable {
    static var allKeyPaths: [PartialKeyPath<Self>] { get }
    static var allAnyKeyPaths: [AnyKeyPath] { get }
    static var additionalKeyPaths: [PartialKeyPath<Self>] { get }

    var allKeyPaths: [PartialKeyPath<Self>] { get }
    var allAnyKeyPaths: [AnyKeyPath] { get }

    var recursivelyAllKeyPaths: [PartialKeyPath<Self>] { get }
    var recursivelyAllAnyKeyPaths: [AnyKeyPath] { get }
}

public extension KeyPathIterable {
    static var allAnyKeyPaths: [AnyKeyPath] {
        allKeyPaths.map { $0 as AnyKeyPath }
    }

    var allKeyPaths: [PartialKeyPath<Self>] {
        Self.allKeyPaths
    }

    var allAnyKeyPaths: [AnyKeyPath] {
        allKeyPaths.map { $0 as AnyKeyPath }
    }

    var recursivelyAllKeyPaths: [PartialKeyPath<Self>] {
        var recursivelyKeyPaths = [PartialKeyPath<Self>]()
        for keyPath in allKeyPaths {
            recursivelyKeyPaths.append(keyPath)
            if let anyKeyPathIterable = self[keyPath: keyPath] as? any KeyPathIterable {
                for childKeyPath in anyKeyPathIterable.recursivelyAllAnyKeyPaths {
                    if let appendedKeyPath = keyPath.appending(path: childKeyPath) {
                        recursivelyKeyPaths.append(appendedKeyPath)
                    }
                }
            }
        }
        return recursivelyKeyPaths
    }

    var recursivelyAllAnyKeyPaths: [AnyKeyPath] {
        recursivelyAllKeyPaths.map { $0 as AnyKeyPath }
    }

    static var additionalKeyPaths: [PartialKeyPath<Self>] {
        []
    }
}


// Copyright 2020 The TensorFlow Authors. All Rights Reserved.
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exceptions.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
public extension KeyPathIterable {
  /// Returns an array of all custom key paths of this value, to the specified
  /// type.
  func allKeyPaths<T>(to _: T.Type) -> [KeyPath<Self, T>] {
    return allKeyPaths.compactMap { $0 as? KeyPath<Self, T> }
  }

  /// Returns an array of all custom key paths of this value and any custom key
  /// paths nested within each of what this value's key paths refers to, to
  /// the specified type.
  func recursivelyAllKeyPaths<T>(to _: T.Type) -> [KeyPath<Self, T>] {
    return recursivelyAllKeyPaths.compactMap { $0 as? KeyPath<Self, T> }
  }

  /// Returns an array of all custom writable key paths of this value, to the
  /// specified type.
  func allWritableKeyPaths<T>(to _: T.Type) -> [WritableKeyPath<Self, T>] {
    return allKeyPaths(to: T.self)
      .compactMap { $0 as? WritableKeyPath<Self, T> }
  }

  /// Returns an array of all custom writable key paths of this value and any
  /// custom writable key paths nested within each of what this value's key
  /// paths refers to, to the specified type.
  func recursivelyAllWritableKeyPaths<T>(
    to _: T.Type
  ) -> [WritableKeyPath<Self, T>] {
    return recursivelyAllKeyPaths(to: T.self)
      .compactMap { $0 as? WritableKeyPath<Self, T> }
  }
}