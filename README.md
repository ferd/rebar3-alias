alias
=====

Runs an aliased command. Aliases can be declared as:

```erlang
 {alias, [
   {renamed,  ["help"]},
   {cleanall, ["clean", "-a"]},
   {testall,  ["do", "ct,", "eunit,", "cover"]},
   {validate, ["do", "ct,", "eunit,", "dialyzer"]},
 ]}.
```

Use
---

Add the plugin to your rebar config:

    {plugins, [
        {alias, {git, "https://github.com/ferd/rebar3-alias.git"}}
    ]}.

Then just call your plugin directly in an existing application:


    $ rebar3 alias <command>
    ===> Fetching alias
    ===> Compiling alias
    <Command Output>
