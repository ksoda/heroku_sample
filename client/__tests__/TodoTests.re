open Jest;

type react_test_renderer_context;
[@bs.module "react-test-renderer"]
external create: React.element => react_test_renderer_context = "create";
[@bs.send] external toJSON: react_test_renderer_context => string = "toJSON";

describe("Todo", () => {
  Expect.(
    test("render", () => {
      let tree =
        create(<TodoApp service_url="http://localhost:3000" />) |> toJSON;
      expect(tree) |> toMatchSnapshot;
    })
  )
});
