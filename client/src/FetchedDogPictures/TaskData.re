[@bs.val] external fetch: string => Js.Promise.t('a) = "fetch";

type state =
  | LoadingDogs
  | ErrorFetchingDogs
  | LoadedDogs(array(string));

[@react.component]
let make = () => {
  let (state, setState) = React.useState(() => LoadingDogs);

  // see reasonml.github.io/reason-react/docs/en/components#hooks for more info
  React.useEffect0(() => {
    Js.Promise.(
      fetch("https://dog.ceo/api/breeds/image/random/3")
      |> then_(response => response##json())
      |> then_(jsonResponse => {
           setState(_previousState => LoadedDogs(jsonResponse##message));
           Js.Promise.resolve();
         })
      |> catch(_err => {
           setState(_previousState => ErrorFetchingDogs);
           Js.Promise.resolve();
         })
      |> ignore
    );

    // No cleanup to do before unmounting
    // this fetch should just be a plain callback, with a cancellation API
    None;
  });

  switch (state) {
  | ErrorFetchingDogs => React.string("An error occurred!")
  | LoadingDogs => React.string("Loading...")
  | LoadedDogs(dogs) =>
    dogs->Belt.Array.map(dog => <img key=dog src=dog />)->React.array
  };
};
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