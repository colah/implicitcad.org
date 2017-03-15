require 'tempfile'
require File.join Rails.root, "lib", "ext_open_scad_lib.rb"
require File.join Rails.root, "lib", "scad.rb"

class RenderersController < ApplicationController

  respond_to :json

  def render_scad
    output_format = "js"

    # Run the ExtOpenSCAD Compiler

    scad_file = Tempfile.new("scad")

    begin
      request.body.rewind
      scad_file.write(request.body.read)
      scad_file.close(false)

      #puts  "\n\n" + "-"*30 + "\n\n" + IO.read(scad_file.path) + "\n\n"

      api_response = extopenscad File.new(scad_file), output_format
      api_json = JSON.parse api_response.body
    ensure
      scad_file.close(true) if defined? scad_file
    end

    # Return the results

    raise 500 if !(defined? api_response and api_response.present? and api_response.code == 202)

    render :json => {:url => "http://#{api_server_url}/implicit_cad/#{api_json["uuid"]}"}
  end

  def api_server_url
    #implicitcad_api_server = Rails.env.development? ? "localhost:3000" : "23.21.177.106:3000"
    #implicitcad_api_server = Rails.env.development? ? "192.168.10.147:8888" : "23.21.177.106:3000"
    implicitcad_api_server = "127.0.0.1:3000"
#    implicitcad_api_server = "23.21.177.106:3000"
  end

  def extopenscad(f, format)
    puts "sending to API.."
    response = Typhoeus::Request.post("http://#{api_server_url}/implicit_cad/",
      :body => {
        :format => format,
        :input => File.open(f.path,"r")
      }
    )
=begin
    puts @@curl.inspect
    puts 1
    @@curl.http_post( Curl::PostField.file('input', f.path), Curl::PostField.content('output_format', format) )
    puts 2
    @@curl.perform
    puts 3
    @@curl.body_str
=end
    puts "sending to API.. [ DONE ]"
    return response
  end

  add_method_tracer :extopenscad, 'Custom/RenderController/extopenscad', :metric => true

end
