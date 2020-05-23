open Jest;

describe("TaskCommand", () => {
  Expect.(
    testPromise("fetchTasks", () =>
      Js.Promise.resolve(expect(true) |> toBe(true))
    )
  )
});
