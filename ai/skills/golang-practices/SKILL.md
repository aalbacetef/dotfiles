---
name: Golang Best Practices
description: This document outlines key best practices and conventions for developing in Go, ensuring consistency, readability, and maintainability across projects. Adhering to these guidelines will help agents effectively understand, navigate, and contribute to Go codebases.
---

# Golang Best Practices

NOTE: this skill takes precedence over every other when in conflict.

## 1. Project Structure and Style

- **Package Naming:** All code should reside in appropriately named top-level packages.
- **Binary Locations:** Executable binaries should be placed under `./cmd/<name>/`. These `cmd` directories should contain minimal code, with core logic delegated to top-level "library" packages.

## 2. Testing Practices

- **Test File Location:** Always create a sibling `_test.go` file within the same package as the code it tests.
- **Golden Files:** For parsing HTTP requests/responses or similar data, use golden files under a `testdata/` directory. These files should be embedded into tests and processed by the code under test.
- **Test Organization:** Tests should be structured with a top-level `TestXXXX` function that orchestrates multiple sub-tests using `t.Run`.
- **Test Naming Convention:** Test names should follow the format: "it should ...".
- **Table-Driven Tests:** Prefer table-driven tests whenever possible for concise and comprehensive test cases.

## 3. Formatting and Linting

- **Formatting:** Code must always be formatted using `goimports -w`.
- **Linting:** `golangci-lint` is the preferred linter for Go projects, ensuring code quality and adherence to best practices.
