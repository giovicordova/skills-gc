import { describe, it } from "node:test";

describe("auth routes", () => {
  it("POST /login rejects missing credentials", async () => {
    // TODO: spin up the router and assert 400 when body is empty
  });

  it("POST /login returns 501 until real verification lands", async () => {
    // TODO: assert stub response shape
  });

  it("POST /login accepts valid credentials once implemented", async () => {
    // TODO: wire a fake user store and assert 200 + token
  });
});
