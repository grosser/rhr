Ruby Hypertext Refinement -- the ease of PHP with the elegance of Ruby

Install
=======
    sudo gem install rhr

Usage
=====
    echo 'Hello <%= params["name"] || "RHR" %>' > index.erb
    rhr server
    --> http://localhost:3000
    --> http://localhost:3000/index.erb?name=World

 - Supports [Erb, Haml, Liquid, ... everything](https://github.com/rtomayko/tilt)
 - Does not serve Rakefile / Gemfile / Gemfile.lock + everything starting with `_` or `.`

Layouting
=========

 You can put a _layout.<FORMAT> file into the root of the project in order to define a special layout
 for all of the other pages. Insert a ```yield``` for your page's content:

    <html>
      <head>
        <title></title>
      </head>
      <body><%= yield %></body>
    </html>

TODO (fork!)
====
 - ~~use _layout.erb files as layout~~ unless view does something like `no_layout`
 - add helpers like link_to / tag / form
 - escape html in params <-> xss

Author
======
Initial (crazy) idea by [Steffen Schröder](https://github.com/ChaosSteffen)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...<br/>
[![Build Status](https://secure.travis-ci.org/grosser/rhr.png)](http://travis-ci.org/grosser/rhr)

