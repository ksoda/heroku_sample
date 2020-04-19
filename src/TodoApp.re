type item = {
  title: string,
  completed: bool,
};

type state = {
  /* this is a type w/ a type argument,
   * similar to List<Item> in TypeScript,
   * Flow, or Java */
  items: list(item),
};

type action =
  | AddItem;

// I've gone ahead and made a shortened name for converting strings to elements
let str = React.string;

[@react.component]
let make = () => {
  let ({items}, dispatch) =
    React.useReducer(
      (state, action) => {
        switch (action) {
        | AddItem =>
          Js.log("AddItem");
          {items: state.items};
        }
      },
      {items: [{title: "Write some things to do", completed: false}]},
    );
  <div className="app">
    <div className="title">
      {str("What to do")}
      <button onClick={_evt => dispatch(AddItem)}>
        {str("Add something")}
      </button>
    </div>
    <div className="items"> {str("Nothing")} </div>
    <div className="footer">
      {str(string_of_int(List.length(items)) ++ " items")}
    </div>
  </div>;
};