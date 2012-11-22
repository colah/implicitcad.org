#= require stl_viewer
#= require codemirror_extopenscad
$ ->
  $editor = $(".editor")

  # anything after the ? is interpretted as a extopenscad script (if present)
  location_array = window.location.toString().split("?")
  content = if ( location_array.length >= 2 ) then location_array[1].replace(/%20/g, " ").replace(/\\n/g, "\n") else $editor.html()

  $editor.html("")

  console_reset = () ->
    console.log("Resetting Console...")
    $(".console").html("")

  console_write = (text) ->
    $(".console").append(text)
    console.log("Writing to Console...")

  #build_html = (name, args) ->
  #  builder = "<" + name + " "
  #  for arg in args:
       
  codeMirror = CodeMirror $editor[0],
    value: content
    mode:  "text/x-extopenscad"
    lineNumbers: true

  console.log $(".io-bar").ioBar
  $(".io-bar").ioBar
    app: "extopenscad"
    serialize: => codeMirror.getValue()
    deserialize: (content) => codeMirror.setValue(content)
    reset:  => codeMirror.setValue("")

  # Zoom buttons
  $(".btn-zoom-out").click => $stlViewer.stlViewer("zoom", -1)
  $(".btn-zoom-in").click => $stlViewer.stlViewer("zoom", +1)
  $(".btn-toggle-transparency").click =>
    console.log "mooo"
    $stlViewer.stlViewer("setTransparent")

  # Keyboard shortcuts (because OpenSCAD had lame keybindings)
  $keys = $(document).add("textarea")

  $keys.on "keydown", null, "F2", -> $(".io-bar").ioBar("save"); return false

  $keys.on "keydown", null, "F4", -> $(".btn-render").click(); return false
  $keys.on "keydown", null, "F5", -> $(".btn-render").click(); return false
  $keys.on "keydown", null, "F6", -> $(".btn-render").click(); return false

  render_and_load = -> 
    $(".console").html("<p><span class='label label-info'>Please hold.</span> Our best server imps are now rendering your file.</p>")

    $(".stl-viewer").stlViewer("clearGeometry")

    post = $.ajax
      url: 'http://23.21.177.106:8000/render/'
      data: {source: codeMirror.getValue()}
      dataType: "jsonp"
      success: (response) ->
        console.log response
        [shape, output, is2D, w] = response
        $(".stl-viewer").stlViewer( "loadGeometry", shape, is2D = is2D, width = w ) if shape?
        output_html = output.replace("\n", "<br/>")
        if shape?
          $(".console").append("<p>#{output_html}</p>")
        else
          $(".console").append("<p class='error'><span class='label label-important'>Error</span> #{output_html}</p>")
      error: ->
        $(".console").append "<p class='error'><span class='label label-important'>Error</span> <b>Oh no!</b> Something has gone wrong while we were rendering your file</p>"
        $(".console").append("<pre style='font-size: 5px; line-height: 5px'>       ▄██████████████▄▐█▄▄▄▄█▌\n      ██████▌▄▌▄▐▐▌███▌▀▀██▀▀\n      ████▄█▌▄▌▄▐▐▌▀███▄▄█▌\n      ▄▄▄▄▄██████████████▀</pre>")
        $(".console").append "<p class='error'>We're going to give those imps some really stern looks but in the mean time please try again or file a bug report if the problem persists.</p>"


  export_and_download = (format_req, format_mime, ext) -> 
    console_reset()
    console_write "<p>Preparing Export...</p>"
    $.ajax
      url: 'http://23.21.177.106:8000/render/'
      data: {source: codeMirror.getValue(), format: format_req}
      dataType: "jsonp"
      success: (response) ->
         [shape, output, is2D, w] = response
         uriContent = "data:model/"+format_mime+"," + encodeURIComponent(shape)
         console_write("<p>Export Done! <a href=\""+uriContent+"\" download=\"download."+ ext+"\" class=\"download-link\"> Download Ready!</a></p>")
         $(".download-link")[0].click()
         return false

  $(".download-STL").click =>
      export_and_download "STL", "stl", "stl"

  $(".download-SVG").click => 
      export_and_download "SVG", "svg", "svg"

  $(".download-gcode-hacklab-laser").click => 
      export_and_download "gcode/hacklab-laser", "gcode", "ngc"

  # Insert the stl viewer
  # DO THIS LAST -- it may fail, and we want the other things set up.
  $stlViewer = $(".stl-viewer").stlViewer()
  # Sending the code to the server to render
  $(".btn-render").click => render_and_load()
   
  $(window).load => do render_and_load()  if content.length > 2

