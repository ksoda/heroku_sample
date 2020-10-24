

import * as React from "react";
import * as Js_exn from "bs-platform/lib/es6/js_exn.js";
import * as Js_math from "bs-platform/lib/es6/js_math.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";

var prefix = {
  contents: 0
};

function make(param) {
  var prefix = String(Js_math.random_int(1000000, 9999999));
  var suffix = String(Date.now() | 0);
  return "" + prefix + "::" + suffix;
}

var TodoId = {
  prefix: prefix,
  make: make
};

function make$1(finishedOpt, text) {
  var finished = finishedOpt !== undefined ? finishedOpt : false;
  return {
          id: make(undefined),
          finished: finished,
          text: text
        };
}

function complete(t) {
  t.finished = true;
  return t;
}

function isSame(t1, t2) {
  return t1.id === t2.id;
}

var Todo = {
  make: make$1,
  complete: complete,
  isSame: isSame
};

function contains(list, todo) {
  return Belt_Array.some(list, (function (param) {
                return isSame(todo, param);
              }));
}

function complete$1(list, target) {
  return Belt_Array.map(list, (function (todo) {
                if (isSame(todo, target)) {
                  return complete(todo);
                } else {
                  return todo;
                }
              }));
}

function add(list, todo) {
  if (!Belt_Array.some(list, (function (param) {
            return isSame(todo, param);
          }))) {
    return Belt_Array.concat(list, [todo]);
  }
  var id = todo.id;
  return Js_exn.raiseError("Could not add todo " + id + ", it already exists.");
}

function remove(list, todo) {
  return Belt_Array.keep(list, (function (current) {
                return !isSame(todo, current);
              }));
}

var TodoList = {
  contains: contains,
  complete: complete$1,
  add: add,
  remove: remove
};

var appState = {
  contents: {
    today: [],
    tomorrow: []
  }
};

function add$1(state, day, todo) {
  if (day) {
    return {
            today: state.today,
            tomorrow: add(state.tomorrow, todo)
          };
  } else {
    return {
            today: add(state.today, todo),
            tomorrow: state.tomorrow
          };
  }
}

function complete$2(state, day, todo) {
  if (day) {
    return {
            today: state.today,
            tomorrow: complete$1(state.tomorrow, todo)
          };
  } else {
    return {
            today: complete$1(state.today, todo),
            tomorrow: state.tomorrow
          };
  }
}

function remove$1(state, day, todo) {
  if (day) {
    return {
            today: state.today,
            tomorrow: remove(state.tomorrow, todo)
          };
  } else {
    return {
            today: remove(state.today, todo),
            tomorrow: state.tomorrow
          };
  }
}

function getDay(state, day) {
  if (day) {
    return state.tomorrow;
  } else {
    return state.today;
  }
}

function reducer(state, action) {
  var newState;
  switch (action.TAG | 0) {
    case /* Add */0 :
        newState = add$1(state, action._0, action._1);
        break;
    case /* Complete */1 :
        newState = complete$2(state, action._0, action._1);
        break;
    case /* Remove */2 :
        newState = remove$1(state, action._0, action._1);
        break;
    
  }
  appState.contents = newState;
  return newState;
}

function useTodoReducer(param) {
  return React.useReducer(reducer, appState.contents);
}

export {
  TodoId ,
  Todo ,
  TodoList ,
  appState ,
  add$1 as add,
  complete$2 as complete,
  remove$1 as remove,
  getDay ,
  reducer ,
  useTodoReducer ,
  
}
/* react Not a pure module */
