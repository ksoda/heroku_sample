let tasksUrl = "http://localhost:3000/tasks";

type task = {
  completed: bool,
  id: int,
  title: string,
};

type tasks = list(task);

module Decode = {
  let task = (json): task =>
    Json.Decode.{
      completed: json |> field("done", bool),
      id: json |> field("id", int),
      title: json |> field("text", string),
    };

  let tasks = (json): list(task) => Json.Decode.(json |> list(task));
};

let createTask: string => Js.Promise.t(task) =
  text => {
    let payload = Js.Dict.empty();
    Js.Dict.set(payload, "text", Js.Json.string(text));
    Js.Dict.set(payload, "done", Js.Json.boolean(false));
    Js.Promise.(
      Fetch.fetchWithInit(
        tasksUrl,
        Fetch.RequestInit.make(
          ~method_=Post,
          ~body=
            Fetch.BodyInit.make(
              Js.Json.stringify(Js.Json.object_(payload)),
            ),
          ~headers=
            Fetch.HeadersInit.make({"Content-Type": "application/json"}),
          (),
        ),
      )
      |> then_(Fetch.Response.json)
      |> then_(json => json |> Decode.task |> resolve)
    );
  };

let fetchTasks = () =>
  Js.Promise.(
    Fetch.fetch(tasksUrl)
    |> then_(Fetch.Response.json)
    |> then_(json => json |> Decode.tasks |> resolve)
  );
