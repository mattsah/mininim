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

Clone the application repo:

```
git clone https://github.com/mattsah/mininim
cd mininim
```

Install dependencies:

```
nimble install https://github.com/mattsah/mininim-core.git
nimble install https://github.com/mattsah/mininim-cli.git
nimble install https://github.com/mattsah/mininim-web.git
nimble setup
```

To work on related packages:

```
nimble develop git@github.com:mattsah/mininim-core.git
nimble develop git@github.com:mattsah/mininim-cli.git
nimble develop git@github.com:mattsah/mininim-web.git
```

Build

```
nimble build
```

Run
```
bin/mininim welcome
```