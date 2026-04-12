### Before
When writing tests, focus on testing behaviour, not implementation details. A test should verify what the code does from the outside, not how it does it internally. If you refactor the internals of a function and all the tests break even though the function still produces the same output, the tests were testing the wrong thing. Mock external dependencies but never mock the code under test. Integration tests should hit real databases, not mocks — we learned this the hard way when mocked tests passed but a production migration failed because the mock didn't match actual database behaviour.

### After
Test outputs, not internals — if a refactor breaks tests but not behaviour, the tests are wrong. Mock external dependencies only; never mock the code under test. Integration tests hit real databases. (Mocked DB tests once passed while a production migration failed — the mock diverged from actual behaviour.)

### Source
Raw distillation. The text resembles appearance-vs-reality principles (Plato's Cave, the map/territory distinction), but the match is thematic, not precise — the original carries specific technical constraints (mock only external deps, real databases for integration tests) and a concrete past incident that any philosophical phrase would obscure.

### Dropped
Nothing. All constraints and the cautionary incident survive.
