[@bs.module "isomorphic-unfetch"] external fetch: string => 'a = "default";

let service_url = ref("");
let tasksUrl = () => {
  let url = service_url^;
  {j|$(url)/tasks|j};
};
let setServiceUrl = url => {
  service_url := url;
};

type task = {
  completed: bool,
  id: int,
  title: string,
};

type tasks = list(task);

module Decode = {
  let task = (json): task =>
    Json.Decode.{
      completed: json |> field("completed", bool),
      id: json |> field("id", int),
      title: json |> field("description", string),
    };

  let tasks = (json): list(task) => Json.Decode.(json |> list(task));
};

let createTask: string => Js.Promise.t(task) =
  text => {
    let payload = Js.Dict.empty();
    Js.Dict.set(payload, "description", Js.Json.string(text));
    Js.Promise.(
      fetch(
        tasksUrl(),
        /* {
             method = "POST";
             body = Js.Json.stringify(Js.Json.object_(payload));
             headers = {"Content-Type"= "application/json"};
             mode = "cors";
           }, */
      )
      |> then_(r => r##json())
      |> then_(json => json |> Decode.task |> resolve)
    );
  };

let fetchTasks = () =>
  Js.Promise.(
    fetch(tasksUrl())
    |> then_(r => r##json())
    |> then_(json => json |> Decode.tasks |> resolve)
  );
