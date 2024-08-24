# Lace

Lace your Elixir with a finely curated blend of functional utilities,
crafted to complement and enhance the standard library.

## Vision

Lace aims to extend the capabilities of Elixir by providing a suite of functional utilities that are consistent, well-documented, and thoroughly tested.

It aspires to be a fixture in most Elixir developers' toolbelt.
To achieve this, it follows these guidelines to drive the project's maintainance and make it easy to adopt:

* Community-driven approach
* Strict semantic versioning
* Exhaustive test coverage
* First-class documentation
* Assured minimum level of maintenance
* Limited and clear scope
* No external dependencies

### Community-friendly approach

Anyone is highly encouraged to file feature requests, report issues, and open PRs for anything, from simple documentation improvements to
new functions or entire new modules.

### Strict semantic versioning

Lace follows semantic versioning; releases with breaking changes are published with a bumped MAJOR version.

As per the spec, these guarantees don't apply to versions < 1.0.0,
as this early phase is intended for rapid iteration and improvement.  
Until then, it is recommended to fix a specific version in your `mix.exs` file, e.g., `{:lace, "== 0.0.2"}`.

Pheraps controversially, Lace will not offer retrocompatibility guarantees on undocumented or buggy behaviour.
The docs and the tests are the behaviour source of truth on which the compatibility guarantees are based on, not the implementation.
**Do not rely on undocumented behaviour.** Or, if you do, be prepared to accept the consequences.  
If you feel like a function does not specify the behaviour on some edge cases,
please report it and, if confirmed, the doc will be updated, and thus become part of the public API.

### Exhaustive test coverage
The objective is to have 100% unit test coverage, and make use of property-based tests and other additional testing strategies when it makes sense.

### First-class documentation

Lace wants to follow Elixir's footsteps on documentation, aiming to have a comprehensive and high-quality one that lives within the codebase.

In order to do so, it follows the following principles:
* Every module must have a `@moduledoc` that introduces the module.  
  moduledocs are welcome to be as long as required, as long as they are not unnecessarily verbose.
* Every function must have a `@doc` with a precise description of the and at least 1 example.  
  Every detail that defines the behaviour (not the implementation!) of the function should be in its `@doc`.
* Every function (public or private) must have a typespec

### Maintainance
Lace maintainers may not respond to every GitHub issue right away or implement all feature requests,
but they'll do their best to offer a basic level of maintenance that guarantees:

* The project builds correctly with the latest N versions of Elixir (to be defined).
* Genuine bugs (as opposed to feature requests or differing views on the API/behavior) are promptly acknowledged.

Given the nature of the project, depending only on Elixir which comes with strong stability guarantees,
this ensures users can keep using Lace without having to worry about it being "outdated",
even if there haven't been recent commits.

### Limited and clear scope
Lace is limited in scope to be a mostly pure, stateless, collection of functions that complement Elixir's Standard Library.

It doesn't start any "application" and it shouldn't define any new data structures
-- with the exception of ones that might be just lightweight wrappers over standard Elixir ones;
like a `Frequencies` type that is just a map of `%{<unique element> => <count>}`.

### No external dependencies

Lace won't add any transitive runtime dependencies to your project.

Test, optional, and non-runtime dependencies are allowed.
