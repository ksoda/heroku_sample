import { gql, useMutation } from "@apollo/client";

export default function PostUpvoter({ votes, id }) {
  const [updatePost] = useMutation(
    gql`
      mutation votePost($id: String!) {
        votePost(id: $id) {
          id
          votes
          __typename
        }
      }
    `
  );

  const upvotePost = () => {
    updatePost({
      variables: {
        id,
      },
      optimisticResponse: {
        __typename: "Mutation",
        votePost: {
          __typename: "Post",
          id,
          votes: votes + 1,
        },
      },
    });
  };

  return (
    <button onClick={() => upvotePost()}>
      {votes}
      <style jsx>{`
        button {
          background-color: transparent;
          border: 1px solid #e4e4e4;
          color: #000;
        }
      `}</style>
    </button>
  );
}
