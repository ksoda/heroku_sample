module TodoItem = {
  [@react.component]
  let make = (~task: TaskCommand.task, ~onToggle) => {
    <div className="item" onClick={_evt => onToggle()}>
      <input
        type_="checkbox"
        checked={task.completed}
        readOnly=true
        /* TODO make interactive */
      />
      {React.string(task.title)}
    </div>;
  };
};

let valueFromEvent = (evt): string => evt->ReactEvent.Form.target##value;
module Input = {
  type state = string;
  [@react.component]
  let make = (~onSubmit) => {
    let (text, setText) = React.useReducer((_, newText) => newText, "");
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

type state = {
  tasks: TaskCommand.tasks,
  loading: bool,
};

type action =
  | Loading
  | Loaded(TaskCommand.tasks)
  | AddItem(string)
  | ToggleItem(int);

let lastId = ref(0);
let newItem: string => TaskCommand.task =
  text => {
    lastId := lastId^ + 1;
    {id: lastId^, title: text, completed: false};
  };

let initialState = {tasks: [], loading: false};

[@react.component]
let make = () => {
  let ({tasks, loading}, dispatch) =
    React.useReducer(
      (state, action) => {
        switch (action) {
        | Loading => {...state, loading: true}
        | Loaded(tasks) => {
            loading: false,
            tasks: List.concat([state.tasks, tasks]),
          }
        | AddItem(text) =>
          /* TODO: handle promise */
          TaskCommand.createTask(text, _ => ());
          {...state, tasks: [newItem(text), ...state.tasks]};
        | ToggleItem(id) => {
            ...state,
            tasks:
              List.map(
                (task: TaskCommand.task) =>
                  task.id === id
                    ? {...task, completed: !task.completed} : task,
                state.tasks,
              ),
          }
        }
      },
      initialState,
    );
  React.useEffect0(() => {
    TaskCommand.fetchTasks(payload => dispatch(Loaded(payload))) |> ignore;
    dispatch(Loading);
    None;
  });

  loading
    ? <div> "loading"->React.string </div>
    : <div className="app">
        <div className="title">
          {React.string("What to do")}
          <Input onSubmit={text => dispatch(AddItem(text))} />
        </div>
        <div className="tasks">
          {List.map(
             (task: TaskCommand.task) =>
               <TodoItem
                 key={string_of_int(task.id)}
                 onToggle={() => dispatch(ToggleItem(task.id))}
                 task
               />,
             tasks,
           )
           |> Array.of_list
           |> React.array}
        </div>
        <div className="footer">
          {(tasks->List.length->string_of_int ++ " tasks")->React.string}
        </div>
      </div>;
};
