# egret

##Description

Egret is an Ocaml-like language targeting Erlang's BEAM. It is a learning tool, not production software.

##Dependencies

* rebar
* make
* erlando (automatically downloaded and built by rebar)

##Build

To build the egret compiler just run make.

    $ make

This will place the `egret` executable in the `bin` subdirectory.

##Use

The `egret` compiler can only take one parameter, the file to compile. For example:

    $ ./bin/egret test/add.egret

This will generate a BEAM file in the same directory as the source file. In this case it will be `test/add.beam`. From here, the BEAM file can be used just like any other; all functions are exported by default.

    $ cd test
    $ erl
    Eshell V7.2  (abort with ^G)
    $ 1> l(add).
    {module,add}
    
The above moves to the `test` directory, starts the Erlang shell, and loads the `add` BEAM file just built. To call a function:

    $ 2> add:add(3.0).
    5.0
    
Also, all egret modules export a `main/0` function that executes all the top level expressions.

    $ 3> add:main().
    5.0

