type item = {
  id: int,
  title: string,
  completed: bool,
};
module TodoItem = {
  [@react.component]
  let make = (~item) => {
    <div className="item">
      <input
        type_="checkbox"
        checked={item.completed}
        /* TODO make interactive */
      />
      {React.string(item.title)}
    </div>;
  };
};

type state = {items: list(item)};

type action =
  | AddItem;
let lastId = ref(0);
let newItem = () => {
  lastId := lastId^ + 1;
  {id: lastId^ + 1, title: "Click a button", completed: true};
};

[@react.component]
let make = () => {
  let ({items}, dispatch) =
    React.useReducer(
      (state, action) => {
        switch (action) {
        | AddItem => {items: [newItem(), ...state.items]}
        }
      },
      {
        items: [{id: 0, title: "Write some things to do", completed: false}],
      },
    );
  <div className="app">
    <div className="title">
      {React.string("What to do")}
      <button onClick={_evt => dispatch(AddItem)}>
        {React.string("Add something")}
      </button>
    </div>
    <div className="items">
      {List.map(
         item => <TodoItem key={string_of_int(item.id)} item />,
         items,
       )
       |> Array.of_list
       |> React.array}
    </div>
    <div className="footer">
      {(items->List.length->string_of_int ++ " items")->React.string}
    </div>
  </div>;
};