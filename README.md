Pulsar website
==============

It's just a simple HTML + Sass project.

Development Setup
-----------------

To work with the CSS just install Sass and let it watch the stylesheets directory.

1. Install Sass:

        $ gem install sass

2. Watch Sass changes:

        $ sass --watch scss/main.scss:css/main.css --style compressed

To display the font correctly you need to run a web server on your own machine. This is because [Typekit](https://typekit.com) will not work on pages that you open from your file system. You can use a tool like [Anvil for Mac](http://anvilformac.com) for local testing.

Reporting Issues
----------------

Mainly via GitHub Issues...

Deploy
------

This is automatically deployed via GH Pages. Whatever goes on this branch will be deployed as soon as the new code is pushed.
