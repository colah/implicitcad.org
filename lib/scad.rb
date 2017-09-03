require 'iconv'

# OpenSCAD handling class.
class SCAD
  
  def self.scad_to_stl(srcscad)
    require 'open3'

    # Write request to .SCAD file
    input_file = Tempfile.new(['input_file', '.scad'])
    input_file.write(srcscad)
    input_file.close
    stl_file = Tempfile.new(['stl_file', '.stl'])

    stdin, stdout, stderr = Open3.popen3("openscad -o #{stl_file.path} #{input_file.path}")
    # response = `openscad -o #{stl_file.path} #{input_file.path}`
    # FIXME(ja): check response from scad to determine if it was successful.. raise if not
    return :response => stderr.read, :output => stl_file.read

  ensure
    input_file.unlink
    stl_file.close
    stl_file.unlink
  end

  def self.convert_format(srcdata, inputformat, outputformat)
    inputformat.downcase!
    outputformat.downcase!

    # Add validations
    # :in => %w(ply stl off obj 3ds collada ptx v3d pts apts xyz gts tri asc x3d x3dv vrml aln)
    # :in => %w(ply stl off obj 3ds collada vrml dxf gts u3d idtf x3d)
    # FIXME(nd): Raise incorrect format request if not

    inputformat = '.' + inputformat
    outputformat = '.' + outputformat

    input_file = Tempfile.new(['input_file', inputformat])
    input_file.write(srcdata)
    input_file.close

    output_file = Tempfile.new(['output_file', outputformat])
    response = `xvfb-run --server-args='-screen 0, 1024x768x24' meshlabserver -i #{input_file.path} -o #{output_file.path} -s #{Rails.root}/tools/scadconvertfilter.mlx`

    # FIXME(nd): Need to raise error condition if not successful
    return :response => response, :output => output_file.read

  ensure
    input_file.unlink
    output_file.close
    output_file.unlink
  end

  def self.obj_to_utf(srcobj)
    input_file = Tempfile.new(['input_file', '.obj'])
    input_file.write(srcobj)
    input_file.close

    utf_file = Tempfile.new(['utf_file', '.utf8'])

    FileUtils.cd File.dirname(utf_file)
    response = `#{Rails.root}/tools/webgl-loader/src/objcompress #{File.basename(input_file)} #{File.basename(utf_file.path)}`

    # output_filename = Dir["*#{File.basename(utf_file.path)}"].first
    # output_filename = Dir["*#{File.basename(utf_file.path)}"].first

    # output_file = File.open(utf_file,'r')
    # outputdata = output_file.read
    # output_file.close
    # File.delete(output_file)

    # Handling single utf8 output
    output = (s = utf_file.read).blank? ? [] : [utf_file]

    # Handling multiple utf8 output
    letter = 'A'
    while File.exist?(path = utf_file.path[0..-5] + letter + '.utf8')
      puts path
      puts File.exist?(path)

      output.push File.new(path)
      output.last.close

      letter = letter.next
    end

    return :response => response, :output => output
  ensure
    input_file.unlink
    utf_file.close
  end

  # New Relic Performance Hook
  if defined? NewRelic
    class << self
      include NewRelic::Agent::Instrumentation::ControllerInstrumentation
      add_method_tracer :obj_to_utf, 'Custom/SCAD/obj_to_utf', :metric => false
      add_method_tracer :convert_format, 'Custom/SCAD/convert_format', :metric => false
    end
  end

end
