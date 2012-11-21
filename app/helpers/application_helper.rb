module ApplicationHelper
  require 'digest'

  def escad_example(example_name, opts = {:format => :text})
    example_path = File.join Rails.root, "config", "implicit-cad-examples", "#{example_name.to_s.gsub("_", "-")}.escad"
    tutorial_path = File.join Rails.root, "config", "tutorial-examples", "#{example_name.to_s.gsub("_", "-")}.escad"
    if File.exists? example_path
      example = File.open(example_path).read
      return opts[:format] == :url ? example.gsub("\n", "\\n") : example
    elsif File.exists? tutorial_path
      example = File.open(tutorial_path).read
      return opts[:format] == :url ? example.gsub("\n", "\\n") : example
    end
  end

  def example_exists?(example_name)
    File.exists?(File.join Rails.root, "config", "implicit-cad-examples", "#{example_name.to_s.gsub("_", "-")}.escad") | File.exists?(File.join Rails.root, "config", "tutorial-examples", "#{example_name.to_s.gsub("_", "-")}.escad")
  end

  

  def examples
    File.read(File.join Rails.root, "config", "implicit-cad-examples.txt").split("\n")
  end

  def example_code(example)
    File.read(File.join Rails.root, "config", "implicit-cad-examples", "#{example}.escad")
  end

  def example_image_url(example)
    "/assets/examples-#{example}.png"
  end

  def navigation_button(url, title)
    if current_page? url
      link_to(title, url, class: "btn btn-large disabled")
    else
      link_to(title, url, class: "btn btn-large")
    end
  end

  def navigation_item(url, title)
    if current_page? url
      content_tag("li", link_to(title, url), class: "disabled-generic")
    else
      content_tag("li", link_to(title, url))
    end
  end

  def navigation_button_small(url, title)
    if current_page? url
      link_to(title, url, class: "btn disabled")
    else
      link_to(title, url, class: "btn")
    end
  end

  def escad_pre_with_image(&block)
    content = capture_haml do
      block.call
    end
    content2 = html_escape content
    content2 = preserve ("\n"*0 + content)
    pre = "<pre class=\"highlightable\">#{content2}</pre>"
    content = content.gsub("&#x000A;", "\n")
    name = Digest::SHA1.hexdigest content
    path = File.join Rails.root, "config", "tutorial-examples", "#{name}.escad"
    #File.open(path, File::CREAT|File::WRONLY) do |file|
    #  file.write(content)
    #end
    capture_haml do
      haml_tag 'div.row.vertical-margined' do
        haml_tag 'div.span7.offset1.codeblock-btn-combo.example-image-height' do
          haml_concat pre
          haml_tag 'a.btn.btn-large.btn-h2-align', "Try this code!", :href => "/examples/#{name}"
        end
        haml_tag 'div.span3' do
          image_path = File.join Rails.root, "app", "assets", "images", "tutorial-#{name}-tut.png"
          if File.exists? image_path
            haml_tag 'div.well.example-image', :style => "background-image: url('/assets/tutorial-#{name}-tut.png');"
          end
        end
      end
    end
  end

  def h2_anchor(title)
    name = title.downcase.gsub(" ", "-")
    capture_haml do
      haml_tag :h2 do
        haml_tag 'a.anchor', :name => name
        haml_concat title
      end
    end
  end

end
