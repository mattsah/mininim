# XML Templates

The `mininim/xmltemplates` module provides advanced dynamic template rendering.

## Common

```nim
import
    mininim,
    mininim/xmltemplates
```

## Basic Usage

```nim
let
    template = XmlEngine.loadFile(
        "resources/hello.html"
    )

echo template.render((name: "World"))
```

File: `resources/hello.html`
```nim
<html>
    <body>
        <h1>Hello {{ name }}!</h1>
    </body>
</html>
```

More common than loading templates and rendering them directly is using them in the context of routed `Action` classes.  The `html()` method provides the process `XmlTemplate` as a convertable response for the request:

```nim
method invoke(): Response =
    let
        user = this.users.find(this.get("id"))

    if user == nil:
        result = Response(status: HttpCode(404))
    else:
        result = this.html(
            "resources/pages/users/get.html",
            (user: user)
        )
```

## Templating

Templating uses the `mininim/dynamic` and the `mininim/script` module (part of `mininim-core`) to provide dynamic template rendering based on a simple expression language.  It combines this with custom tags which provide control logic such as `for` loops and if/else conditions via `try` and `do` tags.  For example:

```nim
<h1>{{ title }}</h1>
<for key="i" val="user" in:val="users">
    <section>
        <h3>{{ user.name }}</h3>
        <p>
            {{ user.intro }}
        </p>
    </section>
</for>
```

The `{{ }}` are used for interpolation and are most commonly found in text:

```nim
<title>{{ title }}</title>
```

You can also interpolate data in attributes:

```nim
<img src="{{ image.path }}" alt="{{ img.description }}" />
```

All interpolated data will be entity escaped by default.

### Setting Data

Template data can be provided when the template is loaded, rendered, or during its processing.  The two examples under "Basic Usage" showed how to pass data in from the Nim side, but you can also set data within the template itself:

```nim
<set
    title="User List"
/>
```

To evaluate an expression you can use the `:val` attribute filter:

```nim
<set
    four:val="2+2"
/>
```

> **NOTE:** You can add more than one piece of data in a single set tag by providing multiple attributes, however, the order of these values being set is not guaranteed.  Accordingly you cannot rely on data previously set in the same `<set>` tag.  For example, the following is **not** gauranteed to work:
>
> ```nim
> <set
>       four:val="2+2"
>       nine:val="four+5"
> />
> ```


For more complex data, such as our user's object, we can use the `<val>` tag:

```nim
<val name="users">
    [
        (name: "Kathy", intro: "The smartest girl in the room."),
        (name: "Bob", intro: "An awesome friend.")
    ]
</val>
```

### Raw

You can use the `raw` attribute filter or the `<raw>` tag to change interpolation behavior, though its effect will vary depending where its used.  For an attribute, this will result in no interpolation and will, instead, print the literal `{{ ... }}` string, e.g.:

```nim
<set
    path="/assets/logo.png"
    description="A beautiful logo designed just for you."
/>
<img src="{{ path }}" alt:raw="{{ description }}" />
```

Would produce:

```nim
<img src="/assets/logo.png" alt="{{ description }}" />
```

In the context of a text node, the `{{ ... }}` parts will also not be interpolated, however, the XML/HTML will not be escaped:

```nim
<set
    name="World"
    paragraph:raw="<p>Hello {{ name }}!</p>"
>
<raw>
    {{ paragraph }}
</raw>
```

> **NOTE:** The example above does not fall subject to the aforementioned multiple set rule because the `{{ name }}` part is not being
> interpolated due to the `raw` attribute filter.

Would produce:

```nim
<p>Hello {{ name }}!</p>
```

As opposed to:

```nim
&lt;p&gt;Hello {{ name }}!&lt;/p&gt;
```

Using `<raw>`, we could modify our user list example above to allow HTML in the user intros.

### Mix

If you want your template data to be fully rendered/interpolated, you can use the `<mix>` tag, which, modifying our previous example to be:

```nim
<mix>
    {{ paragraph }}
</mix>
```

Would produce:

```nim
<p>Hellow World</p>
```

The `<mix>` tag is very powerful and should almost never be used on data which was inputted by untrusted users.  While interpolated data does not allow for external function calls or modifying anything in the scope of Nim, it is possible that by using the `<mix>` tag on untrusted user data that they could expose other data available in the tempalate, but not intended to be visible to them.

### For Loops

As seen in our first templaing example the `<for>` tag can be used to loop over template data.  By providing the `key` and `val` attributes, we make the respective values available in all chil nodes.

> **NOTE:** the variables which are set via the `key` and `val` attributes are not available outside the scope of the loop.  Additionally, and `<set>` or `<val>` tags inside the loop will only be available inside the loop (or to additional children).  In short, while scoped tags like `<for>` have access to data in the parent scope, the data created within them is not accessible outside.

### Do / Try Conditions

You can use the `<do>` and `<try>` tags to perform if and if/elseif/else type logic.  For example:

```nim
<do if:val="user.name == 'Bob'">
    <p>
        Hi Bob!
    </p>
</do>
```

In the example above, the children will only be visible if the condition matches.  In order to achieve more complex branching logic, you can use the `<try>` tag to wrap multiple do tags.  Only the first `<do>` tag with a matching condition will be used.  While this example is contrived, it demonstrates the function:

```nim
<try>
    <do if:val="user.name == 'Bob'">
        <p>
            Hi Bob!
        </p>
    </do>
    <do if:val="user.name == 'Kathy'">
        <p>
            Hi Kathy!
        </p>
    </do>
    <do>
        <p>
            Hi Friend!
        </p>
    </do>
</try>
```

## Caveats

The funcionality available within templates depends on the `mininim/script` as well as the `mininim/dynamic` module which currently does not implement all operators, functions, etc, which are common to Nim, let alone even simpler programming languages.  It is also important to remember that as a dynamic language, the standard rules of strict typing do not apply.

For more information about what is supported check the docs for dynamnic and script.