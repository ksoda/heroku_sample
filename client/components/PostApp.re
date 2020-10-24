/*
 import { gql, useQuery, NetworkStatus } from "@apollo/client";

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
       update: (proxy, { data: { createTodo } }) => {
         const data = proxy.readQuery({
           query: ALL_POSTS_QUERY,
         });

         // Update the cache with the new post at the top of the list
         proxy.writeQuery({
           query: ALL_POSTS_QUERY,
           data: {
             ...data,
             todos: [...data.todos, createTodo],
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
     </form>
   );
 }
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

 export default function PostList() {
    const { loading, error, data, fetchMore, networkStatus } = useQuery(
      ALL_POSTS_QUERY,
      {
        // Setting this value to true will make the component rerender when
        // the "networkStatus" changes, so we are able to know if it is fetching
        // more data
        notifyOnNetworkStatusChange: true,
      }
    );
    const loadingMorePosts = networkStatus === NetworkStatus.fetchMore;
    const loadMorePosts = () => {
      fetchMore({
        variables: {
          skip: todos.length,
        },
      });
    };
    if (error) return <ErrorMessage message="Error loading posts." />;
    if (loading && !loadingMorePosts) return <div>Loading</div>;
    const { todos } = data;
    const areMoreTodos = false;
    return (
      <section>
        <ul>
          {Array.from(todos)
            .reverse()
            .map((todo, index) => (
              <li key={index}>
                <label>
                  <TodoToggler todo={todo} />
                  {todo.text}
                  {todo.id}
                </label>
              </li>
            ))}
        </ul>
        {areMoreTodos && (
          <button onClick={() => loadMorePosts()} disabled={loadingMorePosts}>
            {loadingMorePosts ? "Loading..." : "Show More"}
          </button>
        )}
      </section>
    );
   return null;
 }

 */

open ApolloHooks;

module FindTodos = [%graphql
  {|
   query FindTodos {
     todos {
       id
       text
       done
       user {
         name
       }
     }
   }
|}
];
[@react.component]
let default = () => {
  let (simple, _full) = useQuery(FindTodos.definition);
  <div>
    {switch (simple) {
     | Loading => <p> {React.string("Loading...")} </p>
     | Data(data) => <ul> {
            data##todos ->Belt.Array.map(todo => {
           <li>
             <p> {ReasonReact.string(todo##text)} </p>
           </li>
         })
       ->ReasonReact.array
      } </ul>
     | NoData
     | Error(_) => <p> {React.string("Get off my lawn!")} </p>
     }}
  </div>;
};
