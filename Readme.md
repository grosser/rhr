Ruby Hypertext Refinements -- the ease of PHP with the elegance of Ruby

Install
=======
    sudo gem install rhr

Usage
=====
    echo 'Hello <%= "RHR" %>' > index.erb
    rhr server
    --> http://localhost:3000
    --> http://localhost:3000/index.erb

 - Supports [Erb, Haml, Liquid, ... everything](https://github.com/rtomayko/tilt)
 - Does not serve Rakefile / Gemfile / Gemfile.lock + everything starting with `_` or `.`

======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...<br/>
[![Build Status](https://secure.travis-ci.org/grosser/rhr.png)](http://travis-ci.org/grosser/rhr)
