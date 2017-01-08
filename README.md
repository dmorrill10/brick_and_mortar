BrickAndMortar: A Solid Foundation for Software Projects
================================================

[![Build Status](https://travis-ci.org/dmorrill10/brick_and_mortar.svg?branch=master)](https://travis-ci.org/dmorrill10/brick_and_mortar)

What is BrickAndMortar?
---------------

Many programming environments have dependency managers for their own libraries, such as *Bundler* for Ruby, *Pip* for Python, *Node Package Manager* for Node, and others. A problem arises however, if one needs to use packages from many environments, those that are in any dependency manager's library, or those written in languages that lack widespread dependency manager support such as C and C++.

**BrickAndMortar** is a meant to fill this gap and be a catch-all dependency manager for these projects that require a little extra glue to hold their foundation together.

It is not nearly as fancy a tool as *Bundler* or the like that does dependency conflict checking and automated updates. Instead, it seeks to do one much less ambitious, but nonetheless extremely useful job:

**Ensure that all specified dependencies, from here on called *bricks*, are linked or copied (not yet implemented) into the project's `vendor` directory, recursively.**


Supported Systems
-----------------

Currently only targeted for *nix. Tested on Ubuntu and Mac OS X.


Requirements
------------

- Ruby (>= 2.0, 1.9 might work as well but it has not been tested yet)


Usage
-----

1. Install `brick_and_mortar` gem with `gem install brick_and_mortar`
2. Write a `Brickfile` in your project's root directory that has the following fields:

  `name`
  ~   The name of the dependency. The directory or link that will be present in the `vendor` directory will have this name.

  `version`
  ~   The version of the brick as a string in whatever format is natural for it. This will be appended to the directory name of the copy of the brick downloaded in the `$BRICK_STORE_PREFIX/.brick_store` directory.

  `location`
  ~   Location of the brick. Either local system path, version control repository (*Git*, *Mercurial*, and *Subversion* currently supported), or URL. *zip*, *tar.gz*, and *tar.bz2* are the only currently supported compressed URL package formats.

3. Run `mortar` to install bricks to `vendor`, downloading them if necessary to `$BRICK_STORE_PREFIX/.brick_store`.


Settings
--------

(None of this is implemented yet).

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

Copyright Dustin Morrill, 2015-2017

MIT License
