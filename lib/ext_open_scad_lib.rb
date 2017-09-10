require 'fileutils'

# manually call extopenscad.
module ExtOpenScad
  def self.compile!(scad_script)
    puts "moooo\n" * 2
    puts scad_script
    puts "\n" * 3

    # create the temp files
    FileUtils.mkpath(File.join(Rails.root, 'tmp', 'scads'))
    # FIXME: use an actually random temp file name.
    files = Hash[{ input: '.scad', output: '.js' }.collect { |sym, ext| [sym, Tempfile.new(['loljk', ext], File.join(Rails.root, 'tmp', 'scads'))] }]
    puts files.inspect
    stdin, stdout, stderr = [nil, nil, nil]
    response_data = ''
    puts "moo cows! LOL!\n"

    begin
      puts 'Begining the render!!'
      # load the scad script into the input file.
      files[:input].write(scad_script)

      # close the temp files immediately to save on file handles.
      files.each { |f| f.close(false) }
      # File.open(files[:input], 'w') {|f| f.write(scad_script) }

      puts 'running extopenscad...'

      # process the input with the extopenscad js exporter
      hs_lib = File.expand_path(File.join(File.dirname(__FILE__), 'hs', 'ImplicitExportJS.hs'))
      stdin, stdout, stderr, wait_thr = Open3.popen3("runhaskell #{hs_lib} #{files[:input].path} #{files[:output].path}")

      wait_thr.value # wait for extopenscad to return
      puts 'extopenscad complete!'

      # respond with the output file
      puts files[:output].path
      response_data = File.open(files[:output].path).read
    rescue(e)
      puts 'Rendering Error'
      puts e.backtrace
    ensure
      # kill the temp files with fire!
      files.each { |f| f.unlink }
      # recording the streams
      response = { format: 'THREE.Geometry', data: response_data, stdout: (stdout.read || ''), stderr: (stderr.read || '') }
      if response[:data].blank?
        response[:stderr] = response[:stdout] + response[:stderr]
        response[:stdout] = ''
      end
      puts response[:stdout]
      puts response[:stderr].red
      # closing the output streams
      stdin.close unless stdin.nil?
      stdout.close unless stdout.nil?
      stderr.close unless stderr.nil?
    end

    # return the response data
    response
  end
end
