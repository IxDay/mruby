MRuby::CrossBuild.new("x86_64-windows-gnu") do |conf|
  conf.toolchain :clang

  conf.host_target = "x86_64-w64-mingw32"

  [conf.cc, conf.linker].each do |cc|
    cc.command = "zig cc -target x86_64-windows-gnu"
  end

  conf.cxx.command = "zig c++ -target x86_64-windows-gnu"
  conf.exts.library = ".lib"
  conf.exts.executable = ".exe"

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
  conf.gem :github => 'mattn/mruby-json'
  conf.gem :github => 'mrbgems/mruby-yaml'
  conf.gem :github => 'ixday/mruby-polarssl'
  # conf.gem "../mruby-require"
  # conf.gem :github => 'ixday/mrake'
  conf.gem '../mruby-rake'


  # conf.gem :core => 'mruby-dir'
  # conf.gem :core => "mruby-io"
  # conf.gem :mgem => "mruby-optparse"
  # spec.add_dependency "mruby-process"
  # conf.gem :mgem => "mruby-require"
  # spec.add_dependency "mruby-file-stat"
  # conf.gem :core => "mruby-array-ext"

  #conf.gem :github => 'mattn/mruby-onig-regexp'
  # conf.gem '../mruby-onig-regexp'
end
