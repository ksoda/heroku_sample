import { gql, useMutation } from "@apollo/client";
import { ALL_POSTS_QUERY } from "./PostList";

export default function Submit() {
  const [createPost, { loading }] = useMutation(gql`
    mutation createTodo($item: String!) {
      createTodo(input: { text: $item, userId: "1" }) {
        text
        done
        user {
          name
        }
      }
    }
  `);

  const handleSubmit = (event) => {
    event.preventDefault();
    const form = event.target;
    const formData = new window.FormData(form);
    const item = formData.get("title");
    form.reset();

    createPost({
      variables: { item },
      update: (proxy, { data: { createPost } }) => {
        const data = proxy.readQuery({
          query: ALL_POSTS_QUERY,
        });
        // Update the cache with the new post at the top of the list
        proxy.writeQuery({
          query: ALL_POSTS_QUERY,
          data: {
            ...data,
            todos: [createPost, ...data.todos],
          },
        });
      },
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      <h1>Submit</h1>
      <input placeholder="title" name="title" type="text" required />
      <button type="submit" disabled={loading}>
        Submit
      </button>
      <style jsx>{`
        form {
          border-bottom: 1px solid #ececec;
          padding-bottom: 20px;
          margin-bottom: 20px;
        }
        h1 {
          font-size: 20px;
        }
        input {
          display: block;
          margin-bottom: 10px;
        }
      `}</style>
    </form>
  );
}
