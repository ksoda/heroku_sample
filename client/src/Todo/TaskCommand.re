[@bs.val] external fetch: string => Js.Promise.t('a) = "fetch";

let tasksUrl = "http://localhost:3000/tasks";

type task = {
  completed: bool,
  id: int,
  title: string,
  uuid: string,
};

type tasks = list(task);

module Decode = {
  let task = (json): task =>
    Json.Decode.{
      completed: json |> field("done", bool),
      id: json |> field("id", int),
      title: json |> field("text", string),
      uuid: json |> field("uuid", string),
    };

  let tasks = (json): list(task) => Json.Decode.(json |> list(task));
};

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
