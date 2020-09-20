# Setup data

```gql
mutation createTodo {
  createTodo(input: { text: "todo", userId: "1" }) {
    user {
      id
    }
    text
    done
  }
}

query findTodos {
  todos {
    text
    done
    user {
      name
    }
  }
}

mutation toggleTodo {
  toggleTodo(done: true, id: "T89") {
    id
    done
  }
}
```
