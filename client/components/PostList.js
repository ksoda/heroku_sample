import { gql, useQuery, NetworkStatus } from "@apollo/client";
import ErrorMessage from "./ErrorMessage";
import PostUpvoter from "./PostUpvoter";

export const ALL_POSTS_QUERY = gql`
  query findTodos {
    todos {
      text
      done
      user {
        name
      }
    }
  }
`;

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
          .map((post, index) => (
            <li key={index}>
              <div>
                <span>{post.done ? "v" : "o"}. </span>
                <a href={post.url}>{post.text}</a>
                <PostUpvoter id={post.id} votes={post.votes} />
              </div>
            </li>
          ))}
      </ul>
      {areMoreTodos && (
        <button onClick={() => loadMorePosts()} disabled={loadingMorePosts}>
          {loadingMorePosts ? "Loading..." : "Show More"}
        </button>
      )}
      <style jsx>{`
        section {
          padding-bottom: 20px;
        }
        li {
          display: block;
          margin-bottom: 10px;
        }
        div {
          align-items: center;
          display: flex;
        }
        a {
          font-size: 14px;
          margin-right: 10px;
          text-decoration: none;
          padding-bottom: 0;
          border: 0;
        }
        span {
          font-size: 14px;
          margin-right: 5px;
        }
        ul {
          margin: 0;
          padding: 0;
        }
        button:before {
          align-self: center;
          border-style: solid;
          border-width: 6px 4px 0 4px;
          border-color: #ffffff transparent transparent transparent;
          content: "";
          height: 0;
          margin-right: 5px;
          width: 0;
        }
      `}</style>
    </section>
  );
}
