class PagesController < ApplicationController
  include ApplicationHelper
  require 'openssl'
  require 'mechanize'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  caches_page :index, :editor, :examples, :api, :faq, :tutorial

  def index
    @editor = false
  end

  def editor
    if params["url"]
      agent = Mechanize.new
      @editor = true
      urlstr = "http://" + params["url"]
      page = agent.get urlstr
      code = page.content
      @code = ("//pulled from " + urlstr + "\n" + code).to_s.force_encoding("UTF-8").html_safe
      @example = nil
    else
      @code = nil
      @editor = true
      @example = params["example"] || "twisted_extrusion"
      @example = @example.downcase.gsub("[^a-z0-9\-]", "").gsub("[- ]", "_").to_sym
      raise "example does not exist" unless example_exists?(@example)
    end
  end

  def docs
    @editor = false
  end

  def api
    @editor = false
  end

  def tutorial
    @editor = false
  end

  def faq
    @editor = false
  end

  def examples
    @editor = false
  end

  def install
    @editor = false
  end

end
