require File.join(File.dirname(__FILE__), '../app/models/three_js_monkey.rb')
f = File.new(File.join(File.dirname(__FILE__), 'test.monkey.js'), 'w')
f.write ThreeJSMonkey.compile_js(File.new(File.join(File.dirname(__FILE__), 'test.stl')))
f.close
