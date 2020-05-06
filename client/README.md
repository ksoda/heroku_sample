# ReasonReact Template & Examples

## Dev

```sh
npm install
npm run server
# in a new tab
npm start
```

Open a new web page to `http://localhost:8000/`. Change any `.re` file in `src` to see the page auto-reload. **You don't need any bundler when you're developing**!

**How come we don't need any bundler during development**? We highly encourage you to open up `index.html` to check for yourself!

<details>
<summary>Features Used</summary>

|                           | Blinking Greeting | Reducer from ReactJS Docs | Fetch Dog Pictures | Reason Using JS Using Reason |
| ------------------------- | ----------------- | ------------------------- | ------------------ | ---------------------------- |
| No props                  |                   | ✓                         |                    |                              |
| Has props                 |                   |                           |                    | ✓                            |
| Children props            | ✓                 |                           |                    |                              |
| No state                  |                   |                           |                    | ✓                            |
| Has state                 | ✓                 |                           | ✓                  |                              |
| Has state with useReducer |                   | ✓                         |                    |                              |
| ReasonReact using ReactJS |                   |                           |                    | ✓                            |
| ReactJS using ReasonReact |                   |                           |                    | ✓                            |
| useEffect                 | ✓                 |                           | ✓                  |                              |
| Dom attribute             | ✓                 | ✓                         |                    | ✓                            |
| Styling                   | ✓                 | ✓                         | ✓                  | ✓                            |
| React.array               |                   |                           | ✓                  |                              |

</details>

## Bundle for Production

```sh
npm run build
```

## Handle Routing Yourself

To serve the files, this template uses a minimal dependency called `moduleserve`. A URL such as `localhost:8000/scores/john` resolves to the file `scores/john.html`. If you'd like to override this and handle URL resolution yourself, change the `server` command in `package.json` from `moduleserve ./ --port 8000` to `moduleserve ./ --port 8000 --spa` (for "single page application"). This will make `moduleserve` serve the default `index.html` for any URL. Since `index.html` loads `Main.bs.js`, you can grab hold of the URL in the corresponding `Index.re` and do whatever you want.

By the way, ReasonReact comes with a small [router](https://reasonml.github.io/reason-react/docs/en/router) you might be interested in.
