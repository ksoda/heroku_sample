type item = {
  id: int,
  title: string,
  completed: bool,
};
module TodoItem = {
  [@react.component]
  let make = (~item, ~onToggle) => {
    <div className="item" onClick={_evt => onToggle()}>
      <input
        type_="checkbox"
        checked={item.completed}
        readOnly=true
        /* TODO make interactive */
      />
      {React.string(item.title)}
    </div>;
  };
};

let valueFromEvent = (evt): string => evt->ReactEvent.Form.target##value;
module Input = {
  type state = string;
  [@react.component]
  let make = (~onSubmit) => {
    let (text, setText) =
      React.useReducer((_, newText) => newText, "");
    <input
      value=text
      type_="text"
      placeholder="Write something to do"
      onChange={evt => setText(valueFromEvent(evt))}
      onKeyDown={evt =>
        if (ReactEvent.Keyboard.key(evt) == "Enter") {
          onSubmit(text);
          setText("");
        }
      }
    />;
  };
};

type state = {items: list(item)};

type action =
  | AddItem(string)
  | ToggleItem(int);

let lastId = ref(0);
let newItem = text => {
  lastId := lastId^ + 1;
  {id: lastId^ + 1, title: text, completed: true};
};

[@react.component]
let make = () => {
  let ({items}, dispatch) =
    React.useReducer(
      (state, action) => {
        switch (action) {
        | AddItem(text) => {items: [newItem(text), ...state.items]}
        | ToggleItem(id) => {
            items:
              List.map(
                item =>
                  item.id === id
                    ? {...item, completed: !item.completed} : item,
                state.items,
              ),
          }
        }
      },
      {
        items: [{id: 0, title: "Write some things to do", completed: false}],
      },
    );
  <div className="app">
    <div className="title">
      {React.string("What to do")}
      <Input onSubmit={text => dispatch(AddItem(text))} />
    </div>
    <div className="items">
      {List.map(
         item =>
           <TodoItem
             key={string_of_int(item.id)}
             onToggle={() => dispatch(ToggleItem(item.id))}
             item
           />,
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