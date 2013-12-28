# GitHub Plugin for Travis CLI [![Build Status](https://travis-ci.org/travis-ci/travis-cli-gh.png?branch=master)](https://travis-ci.org/travis-ci/travis-cli-gh)

This plugin for the [Travis Command Line Client](https://github.com/travis-ci/travis#readme) adds commands that interact with the [GitHub API](http://developer.github.com/v3/) rather than the Travis API. This plugin requires Ruby 2.0 or newer.

## Usage

This plugin adds the following commands: [`gh-login`](#gh-login), [`gh-signature`](#gh-signature) and [`gh-whoami`](#gh-whoami). All these commands will use the Travis API endpoint for automatically figuring out which GitHub API endpoint to use (relevant for setups using GitHub Enterprise).

### `gh-login`

This command basically mimics [`travis login`](https://github.com/travis-ci/travis#login) with the notable difference that it does not delete the token on GitHub afterwards (as it will be needed for running other commands) and does not send the GitHub token to Travis CI. Instead, it will store the GitHub token for later use.

Note that it might not be necessary to run this command if you already have a GitHub token available (for instance, in your .netrc).

### `gh-signature`

This command lets you calculate the signature [used for web hooks](http://about.travis-ci.org/docs/user/notifications/#Authorization):

    $ travis gh-signature
    Signature used for travis-ci/travis web hooks: 57ca05aa0db5d27d20b2df24e27e2a191deeb7dd37075d921b76b95eddf60b9b

You can use this signature in your web application to verify that a hook was indeed fired by Travis CI.

Like [other commands](https://github.com/travis-ci/travis#repository-commands), it uses the current directory to determine the repository slug. It is also possible to provide it explicitly:

    $ travis gh-signature -r sinatra/sinatra
    Signature used for travis-ci/travis web hooks: 68db16bb1ec6e38e31c3eg35f38f3b2102effc8ee48186e1032c87c106feeg71

This signature should be kept somewhat secret, otherwise other people can send you fake web hooks.

### `gh-whoami`

Displays which GitHub account you are logged in with on GitHub.

    $ travis gh-whoami
    logged in as rkh

## Installation

You install it like any other gem:

    $ gem install travis-cli-gh

We also push pre-releases to rubygems.org on a regular basis:

    $ gem install travis-cli-gh --pre

### Running against a local clone

If you want to run commands from a local clone of the travis-cli-gh repository (say, if you want to contribute a patch), make sure you have the lib directory on your load path.

Here's an example:

    $ ruby -Ilib -S travis gh-signature

## Version History

**0.1.0** (not yet released)

* Initial release