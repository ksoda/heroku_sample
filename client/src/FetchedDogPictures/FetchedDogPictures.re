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