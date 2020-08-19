let styles =
  ReactDOMRe.Style.make(
    ~marginBottom="25px",
    ~marginRight="15px",
    ~fontSize="14px",
    (),
  );

[@react.component]
let make = () => {
  let pathname = Next.Router.useRouter()##pathname;
  <div style={ReactDOMRe.Style.make(~marginBottom="25px", ())}>
    <Next.Link href="/">
      <a style=styles> {ReasonReact.string("Home")} </a>
    </Next.Link>
    <Next.Link href="/about">
      <a style=styles> {ReasonReact.string("About")} </a>
    </Next.Link>
    <Next.Link href="/apollo">
      <a style=styles className={pathname === "/apollo" ? "is-active" : ""}>
        {ReasonReact.string("Apollo")}
      </a>
    </Next.Link>
    <Next.Link href="/client-only">
      <a
        style=styles
        className={pathname === "/client-only" ? "is-active" : ""}>
        {ReasonReact.string("Client-Only")}
      </a>
    </Next.Link>
    /* reason does not support kebab case */
    <Next.Link href="/todo_legacy">
      <a
        style=styles
        className={pathname === "/todo-legacy" ? "is-active" : ""}>
        {ReasonReact.string("Todo legacy")}
      </a>
    </Next.Link>
  </div>;
};

let default = make;
