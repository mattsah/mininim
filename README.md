# Mininim

Mininim (like: minimum, but with "nim") is a general purpose framework for the Nim programming
language that is designed for:

- Familiar OOP paradigms
- Modularity and extensibility
- Rapid development with terse code

## Unpublished Alpha

All code is currently alpha state and is not published through official channels.  If you want to
test this example, see instructions below.

## Setup / Installation

Clone the repo:

```
git clone https://github.com/mattsah/mininim
cd mininim
```

Install dependencies:

```
nimble install https://github.com/euantorano/dotenv.nim
nimble install https://github.com/mattsah/mininim-core
nimble install https://github.com/mattsah/mininim-cli
nimble install https://github.com/mattsah/mininim-web
```

Setup and build:

```
nimble setup
nimble build
```