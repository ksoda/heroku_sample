module P = {
  [@react.component]
  let make = (~children) => <p className="mb-2"> children </p>;
};

let default = () =>
  <div>
    <h1 className="text-3xl font-semibold">
      "What is this about?"->ReasonReact.string
    </h1>
    <P>
      {React.string(
         {j| This is a simple template for a Next
      project using ReScript & TailwindCSS.|j},
       )}
    </P>
    <h2 className="text-2xl font-semibold mt-5">
      {React.string("Quick Start")}
    </h2>
    <P>
      <pre>
        {React.string(
           {j|git clone https://github.com/ryyppy/nextjs-default.git my-project
cd my-project
rm -rf .git|j},
         )}
      </pre>
    </P>
  </div>;

/*
 [@react.component]
 let make = (~onServer) => {
   <div>
     <Header />
     <p> {ReasonReact.string("Things todo TODAY!")} </p>
     <p> {ReasonReact.string("onServer: " ++ string_of_bool(onServer))} </p>
     <TodoList day=TodoApp.Today />
   </div>;
 };

 let default = make;

 let getInitialProps = context =>
   Js.Promise.make((~resolve, ~reject as _) => {
     let onServer =
       switch (Js.Nullable.toOption(context##req)) {
       | None => false
       | Some(_) => true
       };
     resolve(. {"onServer": onServer});
   });

 let inject:
   (
     Js.t('a) => React.element,
     {. "req": Js.Nullable.t(Js.t('a))} => Js.Promise.t(Js.t('a))
   ) =>
   unit = [%bs.raw
   {| (cls, fn) => cls.getInitialProps = fn |}
 ];

 inject(default, getInitialProps);
 */
