[@bs.val] external fetch: string => Js.Promise.t('a) = "fetch";

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

let createTask = text => callback => {
  let payload = Js.Dict.empty();
  Js.Dict.set(payload, "text", Js.Json.string(text));
  Js.Dict.set(payload, "done", Js.Json.boolean(false));
  Js.Promise.(
    Fetch.fetchWithInit(
      tasksUrl,
      Fetch.RequestInit.make(
        ~method_=Post,
        ~body=Fetch.BodyInit.make(Js.Json.stringify(Js.Json.object_(payload))),
        ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
        ()
      )
    )
    |> then_(Fetch.Response.json)
  |> then_(r => callback(r) |> resolve)
  );
}

let fetchTasks = callback =>
  Js.Promise.(
    fetch(tasksUrl)
    |> then_(response => response##json())
    |> then_(json =>
         json
         |> Decode.tasks
         |> (
           tasks => {
             callback(tasks);
             resolve();
           }
         )
       )
    |> ignore
  );
