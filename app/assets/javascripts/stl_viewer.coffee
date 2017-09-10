#= require stl_geometry

v = (x,y,z) -> new THREE.Vector3(x,y,z)

$.widget "ui.stlViewer", $.ui.mouse,
  options: {}

  _create: ->
    @$viewer = $(@element)

    @scene = new THREE.Scene()

    @transparent = false

    ambient = new THREE.AmbientLight( 0x8844AA )
    @scene.add( ambient )


    directionalLight = new THREE.DirectionalLight( 0xffffff )
    directionalLight.position.set( 40000, -100000, -100000 )
    directionalLight.target.position.set(0,0,0)
#    directionalLight.shadowCameraVisible = false
    directionalLight.castShadow = false
    directionalLight.intensity = 0.4
    @scene.add( directionalLight )

    spotLight = new THREE.SpotLight(0xffffff, 0.1)
    spotLight.position.set( 40000, -100000, 100000 )
 #   spotLight.shadowCameraNear = 0.000001
    spotLight.castShadow = false
#    spotLight.shadowDarkness = 0.2
    #spotLight.shadowCameraVisible = true
    @scene.add( spotLight )

    # For debugging purposes
    window.ambientLight = ambient
    window.dLight = directionalLight
    window.spotLight = spotLight

    #pointLight = new THREE.PointLight( 0xffffff );
    #pointLight.position.x = -1
    #pointLight.position.y = -600
    #@scene.add( pointLight );



    @setCamera("orthographic")
    #@setCamera("perspective")


    @render = @render.lazy(20) 
    try
      @renderer = new THREE.WebGLRenderer(alpha: true)
    catch error
      html = ""
      html += "<div class='no-web-gl-error'><h3>Your web browser does not appear to have webgl enabled.</h3>"
      html += "<p>We need WebGL to show your ImplicitCAD 3D models. "
      html += "Please enable WebGL or download a newer browser that is WebGL enabled.</p></div>"
      @$viewer.html(html)
    #@renderer = new THREE.CanvasRenderer()
    @renderer.setSize( @$viewer.innerWidth(), @$viewer.innerHeight() )

    @$viewer.html("").append(@renderer.domElement)

    @_initController()
    @render()
    console.log "moo? init!"

    bounds = @$viewer[0].getBoundingClientRect()
    yav = (bounds.top + bounds.bottom)/2
    xav = (bounds.left + bounds.right)/2
    w = Math.min bounds.right - bounds.left, bounds.bottom - bounds.top
    @p2_to_p3 = (x,y) ->
        xs = 2*(x-xav)/w
        ys = 2*(y-yav)/w
        s = Math.sqrt (xs*xs + ys*ys)
        if s > 1
          xs = xs / s
          ys = ys / s
        z = Math.sqrt(1 - Math.min 1, s*s)
        test = v(xs,ys,z)
        return test


  # mode = "perspective" or "orthographic"
  setCamera: (mode) ->
    @scene.remove( @camera ) if @camera?
    console.log THREE
    [w, h] = [ @$viewer.innerWidth(), @$viewer.innerHeight() ]
    if mode == "perspective"
      @camera = new THREE.PerspectiveCamera( 75, w / h, 1, 10000 )
    else
      @camera = new THREE.OrthographicCamera( w / -2, w / 2, h / -2, h / 2, -2000, 1000 )

    @camera.position.z = 100 #TODO: auto zoom to fit loaded stls in the viewer
    @scene.add( @camera )
    @render()
    console.log(@$viewer)

  # make the object being rendered transparent to light, so their is light deep in crevaces.
  setTransparent: (transparent, render = true) ->
    @transparent = if transparent? then transparent else !@transparent
    console.log @transparent
    # Turning on transparent models
    return unless @material?
    @material.color = new THREE.Color(if @transparent then 0x522966 else 0x8844AA)
    @material.opacity = if @transparent then 0.7 else 1.0
    @render() if render


  clearGeometry: (geometry) ->
    return unless @mesh?
    @scene.remove( @mesh )
    @render()


  loadGeometry: (geometry, is2D = false, width = 1,  append = false) ->
    geometry.computeFaceNormals()
    geometry.center(geometry)

    @clearGeometry()

    # Material created with DoubleSide, so both sides of the material are visible.
    @material = new THREE.MeshPhongMaterial
      color: 0x8844AA
      vertexColors: 0x8844AA
      shininess: 1
      specular: 0x8844AA
      shading: THREE.SmoothShading
      wireframe: false # true for nice wireframes
      wireframeLinewidth: 4
      overdraw: true
      # required for three.js f524992c0 or later. actually starts functioning sometime before 3cff346
      side: THREE.DoubleSide

    @mesh = new THREE.Mesh(geometry, @material)
    @mesh.overdraw = true

    # for debugging
    window.material = @material
    window.mesh = @mesh

    #@scene.add( @mesh, material )
    @scene.add(@mesh)
    # reset rotation
    # @mesh.rotation.x = 1/2 * Math.PI/2
    if is2D
      @mesh.quaternion.setFromAxisAngle(new THREE.Vector3(1,0,0), Math.PI)
    else
      @mesh.quaternion.setFromAxisAngle(new THREE.Vector3(1,0,0), Math.PI/2)

    #@camera.scale.x = 0.001*width
    #@camera.scale.y = 0.001*width
    #@camera.scale.z = 0.001*width
    # reset mouse drag
    @dragging = false
    @setTransparent(@transparent, false)
    @render()
    console.log "loaded geometry!"


  loadSTL: (stlString)->
    @loadGeometry new STLGeometry(stlString)


  render: ->
    @renderer.render( @scene, @camera ) if @renderer?


  zoom: (delta) ->
    multiplier = 1+Math.abs(delta)/5
    multiplier = ( if delta < 0 then multiplier else 1/multiplier )
    console.log(@camera.scale)
    @camera.scale.x *= multiplier
    @camera.scale.y *= multiplier
    @camera.scale.z *= multiplier
    @render()


   # Calculates a sketch-relative position vector for mouse events accounting for translation and scaling.
  _initController: ->
    this._mouseInit()
    @element.mousewheel _.throttle ( (a,b,c,d) => @_mouseWheel(a,b,c,d) ), 20


    # TODO: zoom!
  _mouseWheel: (event, delta, deltaX, deltaY) ->
    #@zoom( @_zoom.mouseWheelIncrement * delta )
    #console.log deltaY
    @zoom(deltaY)
    event.preventDefault()
    event.stopPropagation()
    return false


  _mouseStart: (e) ->
    @_mouse_click_pos = [e.pageX, e.pageY]
    @_quaternion_click_pos = if @mesh? then @mesh.quaternion.clone() else THREE.quaternion.prototype.set(1,0,0,0)
    @_position_click_pos = if @mesh? then [@mesh.position.y, @mesh.position.x] else [0,0]
    @_dragging = true


  _mouseStop: (e) ->
    @_dragging = false


  _mouseDrag: (e) ->
    return true unless @_dragging and @mesh?
    # Get the relative mouse delta position
    mouse_pos = [e.pageX, e.pageY]
    @_mouse_delta = ( mouse_pos[i] - @_mouse_click_pos[i] for i in [0,1] )

    if e.metaKey == true
      @mesh.position.y = @_position_click_pos[0] + @_mouse_delta[1] / 2
      @mesh.position.x = @_position_click_pos[1] + @_mouse_delta[0] / 2
    else
    
      # multiply a pair of quaternions, returning a quaternion.
      qm = (a,b) -> (new THREE.Quaternion).multiplyQuaternions(a, b)

      # get a new quaterion, initialized from the angles in Vector3 v.
      qVA = (v,a) -> (new THREE.Quaternion).setFromAxisAngle(v,a)

      p1 = @p2_to_p3 @_mouse_click_pos[0], @_mouse_click_pos[1]
      p2 = @p2_to_p3 mouse_pos[0], mouse_pos[1]
      dp = p1.dot(p2)
      dpm = Math.min 1, dp
      a = Math.acos (dpm)
      n = p1.cross(p2).normalize()
      @mesh.quaternion.copy qm qVA(n,a), @_quaternion_click_pos
# moves right, fails to start at old position.
#      oqVA(@_quaternion_click_pos,n,a)
#      @mesh.quaternion.copy oqVA(@_quaternion_click_pos,n,a)
# exponential movement.
#      @mesh.quaternion.multiply qVA(n,a)
#old, broken
#      @mesh.quaternion = qm qVA(n,a), @_quaternion_click_pos
    @render()
