import { gql, useMutation } from "@apollo/client";

export default function TodoToggler({ todo }) {
  const [updateTodo] = useMutation(
    gql`
      mutation toggleTodo($done: Boolean!, $id: ID!) {
        toggleTodo(done: $done, id: $id) {
          id
          done
        }
      }
    `
  );

  const toggleTodo = () => {
    updateTodo({
      variables: {
        done: !todo.done,
        id: todo.id,
      },
    });
  };

  return (
    <input type="checkbox" checked={todo.done} onChange={() => toggleTodo()} />
  );
}
