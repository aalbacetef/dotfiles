---
name: code-organization 
--- 

# Code Organization 

NOTE: this skill overrides all other skills in the case of conflicts.

## Mixed Go and Vue.js projects

Some projects may consist of both a Go server and a Typescript Vue.js app.

In such a case, we want a top-level go.mod, package.json, tsconfig.json, vite.config.ts. Since the runtime we use is Bun, please ensure the bun types are added. We also use oxlint so add the appropriate config. Vite is used for building the Vue.js, vitest for testing it.

The Go code will all live in top-level packages, while the TS code will live under src/. Specific code for the Go binary will go under ./cmd/<name>/.

TS Code that is not Vue.js-specific can go under src/lib/. In almost every scenario, use `type` instead of `interface` in Typescript.


