#          Copyright (c) 2009 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require File.expand_path('../../../../spec/helper', __FILE__)
spec_require 'mustache'

Ramaze::App.options.views = 'mustache'

class SpecMustache < Ramaze::Controller
  map '/'
  engine :Mustache

  def index
    '<h1>Mustache Index</h1>'
  end

  def links
    @index    = a("Index page",        r(:index))
    @internal = a("Internal template", r(:internal))
    @external = a("External template", r(:external))

    '<ul>
      <li>{{{index}}}</li>
      <li>{{{internal}}}</li>
      <li>{{{external}}}</li>
    </ul>'.ui
  end

  def sum(num1, num2)
    @sum = num1.to_i + num2.to_i
  end
end

describe 'Ramaze::View::Mustache' do
  behaves_like :rack_test

  should 'render' do
    got = get('/')
    got.status.should == 200
    got['Content-Type'].should == 'text/html'
    got.body.strip.should == "<h1>Mustache Index</h1>"
  end

  should 'use custom tags for default helpers' do
    got = get('/links')
    got.status.should == 200
    got['Content-Type'].should == 'text/html'
    got.body.strip.should ==
    '<ul>
      <li><a href="/index">Index page</a></li>
      <li><a href="/internal">Internal template</a></li>
      <li><a href="/external">External template</a></li>
    </ul>'.ui
  end

  should 'render external template' do
    got = get('/external')
    got.status.should == 200
    got['Content-Type'].should == 'text/html'
    got.body.strip.should ==
"<html>
  <head>
    <title>Mustache Test</title>
  </head>
  <body>
    <h1>Mustache Template</h1>
  </body>
</html>"
  end

  should 'render external template with instance variables' do
    got = get('/sum/1/2')
    got.status.should == 200
    got['Content-Type'].should == 'text/html'
    got.body.strip.should == "<div>3</div>"
  end
end
