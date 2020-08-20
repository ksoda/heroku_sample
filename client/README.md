# ReasonReact Template & Examples

## Dev

```bash
npm install
npm run dev
```

There are 2 convenience scripts to facilitate running these separate processes:

1. `npm run dev:reason` - This script will start the ReasonML toolchain in
   watch mode to re-compile whenever you make changes.
2. `npm run dev:next` - This script will start the next.js development server
   so that you will be able to access your site at the location output by the
   script. This will also hot reload as you make changes.

### Enviroment

```sh
opam switch 4.06.1
opam install reason merlin refmt rtop
```

## Bundle for Production

Build and run:

```bash
npm run build
npm run start
```
