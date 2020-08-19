/* let service_url = [%raw
     {|
     new URL(JSON.parse(document.querySelector("#entry").textContent)).origin
   |}
   ]; */
let service_url = "";

[@react.component]
let make = () => {
  <div> <Header /> <TodoAppLegacy service_url /> </div>;
};

let default = make;
