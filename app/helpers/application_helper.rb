module ApplicationHelper

  def escad_example(example_name, opts = {:format => :text})
    example = File.open(File.join Rails.root, "config", "implicit-cad-examples", "#{example_name.to_s.gsub("_", "-")}.escad").read
    return opts[:format] == :url ? example.gsub("\n", "\\n") : example
  end

  def example_exists?(example_name)
    File.exists?(File.join Rails.root, "config", "implicit-cad-examples", "#{example_name.to_s.gsub("_", "-")}.escad")
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
    content = html_escape content
    content = preserve ("\n"*0 + content)
    pre = "<pre class=\"highlightable\">#{content}</pre>"
    capture_haml do
      haml_tag 'div.row.vertical-margined' do
        haml_tag 'div.span6.offset1.codeblock-btn-combo.example-image-height' do
          haml_concat pre
          haml_tag 'a.btn.btn-large.btn-h2-align', "Try this code!"
        end
        haml_tag 'div.span4' do
          haml_tag 'div.well.example-image'
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
