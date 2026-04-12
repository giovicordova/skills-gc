Test behaviour, not implementation. If a refactor breaks tests but not outputs, the tests were wrong.

- **Hyrum's Law inverted**: your tests should depend only on the public contract, never on internals.
- **Mock boundaries, not the subject**: fake external dependencies; never mock the code under test.
- **Integration tests hit real infrastructure**: mocked DB tests passed while a production migration failed — the mock lied. Use real databases for integration tests.
