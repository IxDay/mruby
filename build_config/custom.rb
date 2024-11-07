=begin
# https://github.com/mruby/mruby.git
MRUBY_CONFIG=build.rb rake
=end

MRuby::Build.new do |conf|
  # load specific toolchain settings
  conf.toolchain

  # conf.gembox 'default'
  # https://github.com/mruby/mruby/blob/f245943aeddb9aa44062b19871831ba4af49e494/mrbgems/default.gembox#L4
  conf.gembox "stdlib"
  conf.gembox "stdlib-ext"
  conf.gembox "stdlib-io"
  conf.gembox "math"
  conf.gembox "metaprog"

  # Generate mruby command
  conf.gem :core => "mruby-bin-mruby"

  conf.gem :github => 'mruby-Forum/mruby-ansi-colors'
  conf.gem :github => 'buty4649/mruby-onig-regexp'
  conf.gem :github => 'appPlant/mruby-process'
  # conf.gem :core => 'mruby-dir'
  # conf.gem :core => "mruby-io"
  # conf.gem :mgem => "mruby-optparse"
  # spec.add_dependency "mruby-process"
  # conf.gem :mgem => "mruby-require"
  # spec.add_dependency "mruby-file-stat"
  # conf.gem :core => "mruby-array-ext"
  # conf.gem :github => 'ixday/mrake'
  conf.gem '../mruby-rake'
  conf.gem :github => 'mattn/mruby-json'
  conf.gem :github => 'mrbgems/mruby-yaml'
  conf.gem :github => 'ixday/mruby-polarssl'
  #conf.gem :github => 'mattn/mruby-onig-regexp'
  # conf.gem '../mruby-onig-regexp'

  # include HTTP
  # conf.gem :github => 'matsumotory/mruby-simplehttp'

  # C compiler settings
  conf.cc do |cc|
  #  cc.command = ENV['CC'] || 'gcc'
    cc.flags << '-Os'
  #  cc.include_paths = ["#{root}/include"]
  #  cc.defines = %w()
  #  cc.option_include_path = %q[-I"%s"]
  #  cc.option_define = '-D%s'
  #  cc.compile_options = %Q[%{flags} -MMD -o "%{outfile}" -c "%{infile}"]
  end

  conf.enable_bintest
  conf.enable_test
end
