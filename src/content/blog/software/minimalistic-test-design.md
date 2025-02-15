---
title: 'Minimalistic Test Design'
description: "You want your tests to find bugs, but also to not take much of your pressure feature-coding time. You've come to the right place!"
pubDate: 'Feb 15 2025'
category: 'Software Engineering'
tags: []
heroImage: '../../../assets/images/blog/software/minimalistic-test-design.webp'
---

As an opinionated software engineer, many of my opinions swung between extremes.
Functional or OOP? Interpreted or compiled? Relational or NoSQL?
I'm burnt by a practice and swing to an extreme, then read something that swings me to the opposite.

Test design is no different: Mock everything or nothing? Full pyramid or just UI tests? Test all functions or just the most important ones?
The problem with test design questions is that there is no measurable impact -- they don't affect cloud costs, revenue, or user engagement.
They only affect engineering velocity, which is yet to be measured effectively, and is basically impossible to A/B test.

So let me take you through a few extreme choices you probably made (and possibly remade),
and give you an optimal approach to get _velocity-efficient_ and _useful_ test coverage.

## To mock or not to mock?

Mocking is useful when a component truly doesn't care about the behavior of another.
A `list` doesn't care how its elements behave, and `filter(list, predicate)` doesn't care about a specific `predicate`.
For these situations mocking and isolation in tests work best -- "given _some_ `predicate`, how would my implementation behave?".

Product-specific code is mostly _not_ like that.
Components explicitly care about each others' exact behavior, not "_some_" behavior.
The product itself depends on exact components, not "_some_" components.

**Running example:** Human legs are coupled with a human body and vice versa.
Those integration points can't just switch to alternative parts of alternative mammals.
The product is _the full human_, regardless of how you arbitrarily split its code between files and classes.

_Testing conceptually coupled components in isolation is not testing your product._

Here are the biggest issues of testing with undue isolation:

* **You test impossible scenarios** by skipping integrations that would have limited them.
* **You miss real scenarios** by not looking for scenarios triggered by the integrations.
* **You get real scenarios wrong** by replacing behaviors with a "test version".
* **You maintain redundant code** by re-implementing components that are perfect the way they are.
* **Your tests are less readable** because while your real components have meaningful APIs, your mocks have a generic "when-then" API.

```python
# DON'T do this:
def test_human_leg():
  fake_human_body = <reimplement human body> # Unreadable and redundant
  human_leg = HumanLeg(fake_human_body)
  fake_human_body.fly() # Impossible, and did I forget to test walking?

  <verify HumanLeg behavior when the (fake) HumanBody flies>
```

Here are some commonly cited reasons for isolation, and how to correctly address them:

> "The other component is expensive to execute"

* **Debunk:** This isn't true for your arbitrary separation to classes and functions. Most of your code describes free business logic.
* **Strategy:** For components that _are_ expensive, make them configurable for testing instead of replacing them entirely
  (e.g. implementing a DB interface? support an in-memory version to help usages verify with your important business logic).

> "The other component is difficult to set up, and its edge cases are hard to reproduce"

* **Debunk:** Each components' tests need this setup for their own direct integrations anyway, whether they use fakes or reals.
* **Strategy:** Create test helpers for your components to make it trivial to test with them as real dependencies
  (e.g. a method that sets up the in-memory DB interface, or triggers a real failure that would otherwise require deep knowledge to reproduce).

> "The transitive dependencies are expensive to build"

* **Debunk:** When iterating on a component's tests you're not normally changing your dependencies, so their build time shouldn't affect your iterations.
* **Strategy:** Optimize your build system, not individual tests (e.g. make sure unchanged dependencies are cached).

```python
# DO this:
def test_human_leg():
  human_body = HumanBody(universe = "memory://") # Cheap and birthless
  human_leg = HumanLeg(human_body)
  trigger_test_walk(human_body) # Helper - trivial and realistic

  <verify HumanLeg behavior when the (real) HumanBody walks>
```

For the rare cases that truly can't be tested with real implementations (and you're not just lazy),
try to create the smallest cutouts around them rather than around every component in your code base.
If `A` depends on `B` that depends on `C`, and `C` isn't testable -- don't mock `B`.

## How to structure tests?

So now that tests execute multiple components, wouldn't I test the same thing over and over?
When designing your tests, you should be thinking about _behaviors_, not _components_.
You should care about the product, not the code.

You generally try to structure your code based on behaviors, so it makes sense to follow the code when structuring the tests.
To avoid repetition, the trick is to scope your test groups such that _you only test each behavior once universally_.

Continuing the example above -- you shouldn't test all the behaviors of the leg, only to retest all of them when testing the body.
Instead, you can follow this minimalistic structure:

* **Human leg test group:** Verifies behaviors of the leg (attached to a body), down to the smallest detail that can be expected from a human leg.
  * This includes moving individual toes, for example.
* **Human body test group:** Verifies behaviors of the body (attached to legs), but only verify leg details the body _explicitly cares about_.
  * This includes bending down (which synchronizes the back and legs), but _not_ moving individual toes.

The test groups of both components execute the real implementation of the other, but each group focuses on different _behaviors_.

```python
class HumanLegTests:
  def test_moving_toes(): ...
  def test_walking(): ...

class HumanBodyTests:
  def test_bending(): ... # Verifying synchronization of back and legs
  def test_walking(): ... # OK, if verifying ONLY body-focused behaviors
  def test_moving_toes(): ... # DON'T: Redundant - the body doesn't explicitly care
```

Sometimes a component is so simple that it's not worth distinguishing its test group from its sole usage.
Distinguishing a component's test group is not required for a minimalistic test design,
but it can sometimes help you find your tests and avoid repetition,
especially if there are multiple components depending on it.

```python
# This is also OK:
class HumanBodyTests:
  def test_walking(): ...
  def test_bending(): ...
  def test_leg_moving_toes(): ...

# DON'T do this, create leg tests separately instead:
class LeftHumanBodyTests:
  def test_leg_moving_toes(): ...
class RightHumanBodyTests:
  def test_leg_moving_toes(): ...
```

## The test pyramid

Terms like "unit tests", "integration tests", and "system tests" are highly subjective:

* Every test verifies a behavior of some scoped unit, even if the unit has a lot behind it ("a lot" is subjective too - is _a computer_ not a lot?).
* Every test integrates multiple pieces of code, even if only code included in the standard library (e.g. the implementation of `list`, or arithmetic operations).
* No test verifies the entire system, it is always focusing on some behavior within it.

Thinking in pyramids manifests several test design issues:

* It makes you test with undue isolation.
* It makes you test the same behavior multiple times.
* It makes it confusing where future tests should be (does _this_ behavior need an "integration test" or just a "unit test"?).

```python
# DON'T do this:
class HumanBodyUnitTests:        <test ALL HumanBody behaviors>
class HumanBodyIntegrationTests: <test SOME HumanBody behaviors>

class HumanLegUnitTests:         <test ALL HumanLeg behaviors>
class HumanLegIntegrationTests:  <test SOME HumanLeg behaviors>
```

Alternatively, "test size" refers to the _objective_ technical cost of running a test.
Does the test require a file system? Multiple threads, processes, or servers? An emulator or a browser?
Instead of designing a pyramid of duplicate tests, design based on the test size requirements of the different behaviors.

```python
# DO this:
class HumanBodyTests: <mostly larger tests requiring threads>
class HumanLegTests:  <mostly smaller tests requiring pure business logic>
```

If your testing framework requires a different test group for different sizes,
it's OK to have multiple test groups for the same component as long as the behaviors don't overlap.
Naming the test groups based on the behaviors would help you avoid duplication.

```python
# This is also OK:
class HumanBodyMovementTests: <large tests requiring physics simulation>
class HumanBodySesnsoryTests: <small tests requiring pure business logic>
```

If you name these "integration" and "unit", will it be as easy to understand which test goes where?

## Conclusion

Having a minimalistic approach to testing can be a fun puzzle for the perfectionists within us.
It lets you iterate fast, both in maintaing the tests and in finding real bugs in the product.

I hope this post will help you achieve a better test design.
If it didn't -- you know where to find me, and I'm happy to discuss!
