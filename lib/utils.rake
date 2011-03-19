# encoding: utf-8
namespace :util do

  desc "Monitor files for changes and run a single test when a change is detected.
    \nIt can take a string with space separated arguments:
    \n'on_success' or 's'  -> runs all tests after a succesful test
    \n'integration_on_success' or 'i' -> runs only integration tests after a succesful test
    \n'rails' or 'r' -> if it runs non-individual tests it does through 'rake test' and company
    \n'on_start' or 'st' -> perform an initial round of tests, if there is a setting about tests on_success it will be used, all tests will be run otherwise
    \n\nEnter 'help' on the terminal to see interactive commands !!"
  task :monitor, :opts do |t,args|
    parse_args(args)

    @tests_success = true
    if @on_start then  # initial execution
      update_file_list
      run_tests
    end
    keep_running = true
    while keep_running do
      # Loop until interrupted by ctrl-c
      trap("INT") { puts "\nExiting"; keep_running = false; @tests_success = false; }
      # loop through test_list looking for date changes
      keep_searching = true
#         @tests_success = true
      puts "\n"
      restart_waiter
      while keep_searching && keep_running do
        update_file_list
        parse_waiter_command
        print "\r Waiting for file changes (#{Time::now.strftime('%H:%M:%S')}) or a command, ctrl-c exits: "
        Kernel::sleep(1.0) # wait between searches for changed files

        @file_list.each do |file|
          Kernel::sleep(0.05) # keep the cpu from maxing out
          if @orig_dates[file] != File.stat(file).mtime
            puts "\n  File change detected: #{file}"
            puts "  Time is: #{Time::now}"

            if file =~ /_test\.rb$/ then  #already a test file
              keep_searching = false
              run_test_file(file)
            else
              # look for the test file
              filename = file.gsub('.rb','_test.rb').match(/.+[\/]*.+\/(.+\.rb)/)[1]
              @test_list.each do |item|
                if item =~ /#{filename}$/ then
                  keep_searching = false
                  run_test_file(item)
                  break
                end
              end
              if keep_searching then
                puts "\n  Test File not found: #{filename}"
              end
            end
            update_stamp(file)

          end # if @orig_dates[file] != File.stat(file).mtime
        end # @file_list.each do |file|
      end # while keep_searching... -- change detection loop

      if @tests_success and keep_running and @on_success then
        run_tests
      end
    end # while keep_running do -- main loop

  end # task :monitor

  def restart_waiter
    Thread.kill(@waiter) if !@waiter.nil? and @waiter.alive?
    @waiter = Thread.new do
      t = Thread.current
      t[:value] = $stdin.gets
    end
  end

  def waiter_value
    if @waiter.nil? or !@waiter.key?(:value) then
      ''
    else
      @waiter[:value]
    end
  end

  def parse_waiter_command
    opts = waiter_value
    puts "\n" if (!opts.nil? and opts.length > 0)
    if (opts =~ /\bhelp\b/i) then
      puts "Available commands:
  'on_success' or 'autos' \t to run all tests on success.
  'integration_on_success' \t or 'autoi' to run only integration tests on success. overrides 'autos'.
  'rails' or 'r' \t to toggle Rails mode.
  'show' \t to show the options' state.
  'all' or 'a' \t to run all tests now.
  'integration' or 'i' \t to run all integration tests now.
  'last' or 'l' \t to run last test.
  'notify' or 'n' \t to show last test results."
    end
    if (opts =~ /\bshow\b/i) then
      puts "On success = #{!@on_success.nil?}"
      puts "Integration on success = #{!@integration_on_success.nil?}"
      puts "Rails mode = #{!@rails.nil?}"
    end
    if (opts =~ /\bnoauto\b/i) then
      @on_success = nil
      @integration_on_success = nil
      puts "Changed 'On success' to #{!@on_success.nil?}"
      puts "Changed 'Integration on success' to #{!@integration_on_success.nil?}"
    end
    if (opts =~ /\bon_success\b/i or opts =~ /\bautos\b/i) then
      @on_success = true
      puts "Changed 'On success' to #{!@on_success.nil?}"
    end
    if (opts =~ /\bintegration_on_success\b/i or opts =~ /\bautoi\b/i) then
      @integration_on_success = true
      @on_success = true
      puts "Changed 'Integration on success' to #{!@integration_on_success.nil?}"
      puts "Changed 'On success' to #{!@on_success.nil?}"
    end
    if (opts =~ /\brails\b/i or opts =~ /\br\b/i) then
      if @rails then @rails = nil else @rails = true end
      puts "Changed 'Rails' to #{!@rails.nil?}"
    end
    if (opts =~ /\ball\b/i or opts =~ /\ba\b/i) then
      run_all_tests
    end
    if (opts =~ /\bintegration\b/i or opts =~ /\bi\b/i) then
      run_integration_tests
    end
    if (opts =~ /\blast\b/i or opts =~ /\bl\b/i) then
      run_last_test
    end
    if (opts =~ /\bnotify\b/i or opts =~ /\bn\b/i) then
      notify_last
    end
    puts "\n" if (!opts.nil? and opts.length > 0)
    restart_waiter if (!opts.nil? and opts.length > 0) or @waiter.nil? or !@waiter.alive?
  end

  def parse_args(args)
    args.with_defaults(:opts => "")
    opts = args.opts
    @on_start = (opts =~ /\bon_start\b/i or opts =~ /\bst\b/i)
    @on_success = (opts =~ /\bon_success\b/i or opts =~ /\bs\b/i)
    @integration_on_success = (opts =~ /\bintegration_on_success\b/i or opts =~ /\bi\b/i)
    @on_success = true if @integration_on_success
    @rails = (opts =~ /\brails\b/i or opts =~ /\br\b/i)
    puts "
    Running with these options...
      On start =#{!@on_start.nil?}
      On success =#{!@on_success.nil?}
      Integration on success =#{!@integration_on_success.nil?}
      Rails mode =#{!@rails.nil?}
      "
  end

  def update_stamp(file)
    @orig_dates[file] = File.stat(file).mtime
  end

  def run_test_file(test_file)
    puts "Running #{test_file}..."
    cmd = "ruby -I test #{test_file} | tee .testing.log"
    system(cmd)
    @last = cmd
    notify
  end

  # run tests according to on_success suite option. by default all tests are run.
  def run_tests
    if @integration_on_success then
      run_integration_tests
    else
      run_all_tests
    end
  end

  def run_all_tests
    puts "\nRunning all tests..."
    if @rails then
      cmd = "rake test | tee .testing.log"
    else
      cmd = "ruby -I test -e 'ARGV.each{|f| load f}' #{@test_list.collect { |fn| "\"#{fn}\"" }.join(' ')} | tee .testing.log"
    end
    system(cmd)
    @last = cmd
    notify
  end

  def run_integration_tests
    puts "\nRunning integration tests..."
    if @rails then
      cmd = "rake test:integration | tee .testing.log"
    else
      cmd = "ruby -I test -e 'ARGV.each{|f| load f}' #{@integration_test_list.collect { |fn| "\"#{fn}\"" }.join(' ')} | tee .testing.log"
    end
    system(cmd)
    @last = cmd
    notify
  end

  def run_last_test
    if @last.nil? then
      puts "\nNo test run yet..."
    else
      puts "\nRunning last test..."
      system(@last)
      notify
    end
  end

  def notify_last
    if @results.nil? then
      puts "\nNo test run yet..."
    else
      notify_results
      puts "\n Results: #{@results.inspect}"
    end
  end

  def update_file_list
    # the test_list
    @test_list = FileList['test/**/*_test.rb']
    @integration_test_list = FileList['test/integration/**/*_test.rb']

    # the file_list
    @file_list = [] if @file_list.nil?
    @new_file_list = FileList['test/**/*_test.rb'] | FileList['app/**/*.rb']
    nuevos = @new_file_list - @file_list
    @file_list = @new_file_list

    puts "\nAdding files to watch list... #{nuevos.inspect}\n" if !nuevos.empty?

    #the stamps
    @orig_dates = {} if @orig_dates.nil?
    nuevos.each do |file|
      update_stamp(file)
      sleep 0.05
    end
  end

  def notify
    # get time spent
    res = `grep .testing.log -e 'Finished in'`
    lines=res.split(/\n/)
    secs=0
    lines.each do |line|
      secs += line.gsub(/Finished in (\d+)\..+/,'\1').to_i
    end

    # get @results
    res = `grep .testing.log -e '[0-9]\\+ tests, [0-9]\\+ assertions'`
    lines=res.split(/\n/)
    @results = {:tests =>0, :assertions =>0, :failures =>0, :errors =>0, :pendings =>0, :omissions =>0, :notifications =>0}
    lines.each do |line|
      nums=line.gsub(/\D+/,',').split(',')
      @results[:tests]+=nums[0].to_i
      @results[:assertions]+=nums[1].to_i
      @results[:failures]+=nums[2].to_i
      @results[:errors]+=nums[3].to_i
      @results[:pendings]+=nums[4].to_i
      @results[:omissions]+=nums[5].to_i
      @results[:notifications]+=nums[6].to_i
    end

    @tests_success = true
    @tests_success = false if @results.all? do |k,v| v == 0 end
    @tests_success = (@results[:errors]==0 and @results[:failures]==0) if @tests_success # sólo lo cambiamos si es true

    @tests_partial_success = ( @tests_success and @results[:pendings]!=0 )

    @results[:secs] = secs # carry exec. time to notify

    notify_results
  end

  def notify_results
    case RUBY_PLATFORM
    when /mswin|mingw|cygwin/
      # beware of this platform !!
    when /darwin/
      # growl?
    else
      notify_by_notify_send
    end
  end

  def notify_by_notify_send
    icon = 'gtk-cancel'
    icon = 'gtk-ok' if @tests_success
    icon = 'gtk-preferences' if @tests_partial_success
    message = "#{@results[:tests]} tests, #{@results[:assertions]} assertions, #{@results[:failures]} failures, #{@results[:errors]} errors
    #{@results[:pendings]} pendings, #{@results[:omissions]} omissions, #{@results[:notifications]} notifications"
    system("notify-send -i #{icon} 'Testing results [#{@results[:secs]} secs]' '#{message}'")
  end

  desc "Annotate all models, unit tests, routes.rb and blueprints.rb"
  task :annotate do |t|
    system("annotate -i; annotate -r")
  end

  desc "Restart passenger. Use 'rake util:restart DEBUG=true' to debug."
  task :restart do
    system("touch tmp/restart.txt")
    system("touch tmp/debug.txt") if ENV["DEBUG"] == 'true'
  end

end # :util

