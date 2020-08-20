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
  | AddItem(TaskCommand.task)
  | ToggleItem(int);

let initialState = {tasks: [], loading: false};

[@react.component]
let make = (~service_url) => {
  let ({tasks, loading}, dispatch) =
    React.useReducer(
      (state, action) => {
        switch (action) {
        | Loading => {...state, loading: true}
        | Loaded(tasks) => {
            loading: false,
            tasks: List.concat([state.tasks, tasks]),
          }
        | AddItem(task) => {...state, tasks: [task, ...state.tasks]}
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
    TaskCommand.setServiceUrl(service_url);
    TaskCommand.fetchTasks()
    |> Js.Promise.(then_(payload => resolve(dispatch(Loaded(payload)))))
    |> ignore;
    dispatch(Loading);
    None;
  });

  loading
    ? <div> "loading"->React.string </div>
    : <div className="app">
        <div className="title">
          {React.string("What to do")}
          <Input
            onSubmit={text => {
              TaskCommand.createTask(text)
              |> Js.Promise.(
                   then_(task => {
                     dispatch(AddItem(task));
                     resolve(task);
                   })
                 )
            }}
          />
        </div>
        <div className="tasks">
          {tasks
           |> List.sort((s: TaskCommand.task, t: TaskCommand.task) =>
                compare(t.id, s.id)
              )
           |> List.map((task: TaskCommand.task) =>
                <TodoItem
                  key={string_of_int(task.id)}
                  onToggle={() => dispatch(ToggleItem(task.id))}
                  task
                />
              )
           |> Array.of_list
           |> React.array}
        </div>
        <div className="footer">
          {(tasks->List.length->string_of_int ++ " tasks")->React.string}
        </div>
      </div>;
};

let default = make;
