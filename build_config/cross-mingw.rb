#
# Ubuntu 20.04 requires at least `gcc-mingw-w64-x86-64` package as a
# cross compiler.
#

MRuby::CrossBuild.new("cross-mingw") do |conf|
  conf.toolchain :gcc
  conf.host_target = "x86_64-w64-mingw32"  # required for `for_windows?` used by `mruby-socket` gem
  conf.cc.command = "x86_64-w64-mingw32-gcc"
  #conf.cxx.command = "x86_64-w64-mingw32-g++"
  #conf.linker.command = "x86_64-w64-mingw32-ld"
  conf.archiver.command = "x86_64-w64-mingw32-gcc-ar"
  conf.exts.executable = ".exe"

  conf.gembox "stdlib"
  conf.gembox "stdlib-ext"
  conf.gembox "stdlib-io"
  conf.gembox "math"
  conf.gembox "metaprog"

  # Generate mruby command
  conf.gem :core => "mruby-bin-mruby"

  #conf.gem :github => 'mruby-Forum/mruby-ansi-colors'
  #conf.gem :github => 'appPlant/mruby-process'
  #conf.gem :github => 'ixday/mrake'
  #conf.gem :github => 'mattn/mruby-json'
  #conf.gem :github => 'mrbgems/mruby-yaml'
  #conf.gem :github => 'ixday/mruby-polarssl'
  conf.gem :github => 'buty4649/mruby-onig-regexp'
  #conf.gem :github => 'mattn/mruby-onig-regexp'
  #conf.gem '../mruby-onig-regexp'

end
