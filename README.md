BrickAndMortar: A Solid Foundation for Software Projects
================================================

What is BrickAndMortar?
---------------

Many programming environments have dependency managers for their own libraries, such as *Bundler* for Ruby, *Pip* for Python, *Node Package Manager* for Node, and others. A problem arises however, if one needs to use packages from many environments, those that are in any dependency manager's library, or those written in languages that lack widespread dependency manager support such as C and C++.

**BrickAndMortar** is a meant to fill this gap and be a catch-all dependency manager for these projects that require a little extra glue to hold their foundation together.

It is not nearly as fancy a tool as *Bundler* or the like that does dependency conflict checking and automated updates. Instead, it seeks to do one much less ambitious, but nonetheless extremely useful job:

**Ensure that all specified dependencies, from here on called *bricks*, are linked or copied into the project's `vendor` directory, recursively.**

Its possible that there are tools in existence that do exactly this, but I have been unable to find them as of yet. Feel free to point me to them.


Supported Systems
-----------------

Currently only targeted for Linux, and only tested on Ubuntu.


Requirements
------------

- Ruby (>= 1.8.7)


Usage
-----

1. Install `brick_and_mortar` gem with `gem install brick_and_mortar`
2. Write a `Brickfile.yml` in your project's root directory that has the following fields:
  
  `name`
  ~   The name of the dependency. The directory or link that will be present in the `vendor` directory will have this name.

  `version`
  ~   The version of the brick as a string in whatever format is natural for it. This will be appended to the directory name of the copy of the brick downloaded in the `$BRICK_STORE_PREFIX/.brick_store` directory.

  `location`
  ~   Location of the brick. Either local system path, version control repository (*Git*, *Mercurial*, and *Subversion* currently supported), or URL.

3. Run `brick_and_mortar lay` to install bricks to `vendor`, downloading them if necessary to `$BRICK_STORE_PREFIX/.brick_store`.


Settings
--------

Write a `$HOME/.brick_and_mortarrc` file to specify:

`BRICK_STORE_PREFIX`
~   The directory that contains `.brick_store`. As the name suggests, `.brick_store` is where all bricks will be stored before they are linked or copied into the `vendor` directories of individual projects.

`DEFAULT_BRICK_SHARING_POLICY`
~   Specify the default behavior when placing bricks in projects. Accepts either 
    - `copy`, where the brick will be copied into `vendor`, or 
    - `link`, where the brick will be symbolically linked into `vendor`.
    Defaults to `link`.


License
-------

Copyright Dustin Morrill, 2015

MIT License
