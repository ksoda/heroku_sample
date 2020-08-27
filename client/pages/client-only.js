import App from "../components/App";
import Header from "../components/Header.bs";
import Submit from "../components/Submit";
import PostList from "../components/PostList";

const ClientOnlyPage = (props) => (
  <App>
    <Header />
    <Submit />
    <PostList />
  </App>
);

export default ClientOnlyPage;
