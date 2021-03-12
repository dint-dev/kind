// Copyright 2021 Gohilla Ltd.
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

import 'package:kind/strings.dart';
import 'package:test/test.dart';

void main() {
  test('emailAddressStringKind', () {
    final kind = stringKindForEmailAddress;
    expect(kind.name, 'EmailAddress');

    // Constraints
    expect(kind.isSingleLine, isTrue);
    expect(kind.minLengthInUtf8, 6);
    expect(kind.maxLengthInUtf8, 80);

    // Some invalid examples
    expect(kind.instanceIsValid(''), isFalse);
    expect(kind.instanceIsValid('user'), isFalse);
    expect(kind.instanceIsValid('user@'), isFalse);
    expect(kind.instanceIsValid('user@domain'), isFalse);
    expect(kind.instanceIsValid('@domain.com'), isFalse);
    expect(kind.instanceIsValid('with whitespace@domain.com'), isFalse);
    expect(kind.instanceIsValid(' user@domain.com '), isFalse);
    expect(kind.instanceIsValid('a b@domain.com'), isFalse);
    expect(kind.instanceIsValid('a\nb@domain.com'), isFalse);
    expect(kind.instanceIsValid('a,b@domain.com'), isFalse);
    expect(kind.instanceIsValid('a<b@domain.com'), isFalse);
    expect(kind.instanceIsValid('a>b@domain.com'), isFalse);

    // Some valid examples
    expect(kind.instanceIsValid('a@domain.com'), isTrue);
    expect(kind.instanceIsValid('a.b.c.d@domain.com'), isTrue);
    expect(kind.instanceIsValid('ab-cd@domain.co.uk'), isTrue);
    expect(kind.instanceIsValid('abcd~box@domain.co.uk'), isTrue);
    expect(
        kind.instanceIsValid('abcd__@domain.XN--VERMGENSBERATUNG-PWB'), isTrue);

    // At least 2 declared examples, all valid
    expect(kind.declaredExamples, hasLength(greaterThanOrEqualTo(2)));
    for (var example in kind.declaredExamples) {
      expect(kind.instanceIsValid(example), isTrue);
    }
  });

  test('markdownStringKind', () {
    final kind = stringKindForMarkdown;
    expect(kind.name, 'markdown');

    // Constraints
    expect(kind.isSingleLine, isFalse);
    expect(kind.maxLengthInUtf8, null);

    // Anything is valid
    expect(kind.instanceIsValid(''), isTrue);
    expect(kind.instanceIsValid('a b.c\nd*-_[]()'), isTrue);

    // At least 1 declared example, all valid
    expect(kind.declaredExamples, hasLength(greaterThanOrEqualTo(1)));
    for (var example in kind.declaredExamples) {
      expect(kind.instanceIsValid(example), isTrue);
    }
  });

  test('phoneNumberStringKind', () {
    final kind = stringKindForPhoneNumber;
    expect(kind.name, 'phoneNumber');

    // Constraints
    expect(kind.isSingleLine, isTrue);
    expect(kind.maxLengthInUtf8, 40);

    // Some invalid examples
    expect(kind.instanceIsValid(''), isFalse);
    expect(kind.instanceIsValid('abc'), isFalse);
    expect(kind.instanceIsValid('email@address.com'), isFalse);

    // At least 2 declared examples, all valid
    expect(kind.declaredExamples, hasLength(greaterThanOrEqualTo(2)));
    for (var example in kind.declaredExamples) {
      expect(kind.instanceIsValid(example), isTrue);
    }
  });

  test('urlStringKind', () {
    final kind = stringKindForUrl;
    expect(kind.name, 'url');

    // Constraints
    expect(kind.isSingleLine, isTrue);
    expect(kind.minLengthInUtf8, 5);
    expect(kind.maxLengthInUtf8, 4096);

    // Some invalid examples
    expect(kind.instanceIsValid(''), isFalse);

    // Some valid examples
    expect(kind.instanceIsValid('http://google.com'), isTrue);
    expect(kind.instanceIsValid('https://google.com'), isTrue);
    expect(kind.instanceIsValid('https://google.com/?q=query'), isTrue);

    // At least 1 declared example, all valid
    expect(kind.declaredExamples, hasLength(greaterThanOrEqualTo(1)));
    for (var example in kind.declaredExamples) {
      expect(kind.instanceIsValid(example), isTrue);
    }
  });
}
