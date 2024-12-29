require_relative 'toolchain'

ARCH_MAPPING = {
  "windows-x86_64"    => "x86_64-windows-gnu",
  "macos-x86_64"      => RUBY_PLATFORM,
  # "macos-aarch64"     => RUBY_PLATFORM, # this is not working at the moment
  "linux-x86_64"      => "x86_64-linux",
  "linux-x86_64-musl" => "x86_64-linux-musl"
}

def setup(conf)
  conf.gembox "stdlib"
  conf.gembox "stdlib-ext"
  conf.gembox "stdlib-io"
  conf.gembox "math"
  conf.gembox "metaprog"

  # Generate mruby command
  conf.gem :core => "mruby-bin-mruby"

  # Those are forked gem to allow proper cross compilation,
  # they are dependencies of the other gems listed below
  conf.gem :github => 'ixday/mruby-onig-regexp'
  conf.gem :github => 'appPlant/mruby-process'

  conf.gem :github => 'mruby-Forum/mruby-ansi-colors'
  conf.gem :github => 'mattn/mruby-json'
  conf.gem :github => 'mrbgems/mruby-yaml'
  conf.gem :github => 'ixday/mruby-polarssl'
  conf.gem :github => 'ixday/mruby-rake'
  conf.gem :github => 'matsumotory/mruby-simplehttp'

  # https://stackoverflow.com/questions/72030595/which-gcc-optimization-flags-affect-binary-size-the-most#answer-72037241
  conf.cc.flags << '-Os'
  conf.cxx.flags << '-Os'
  conf.linker.flags << '-s'

  # generate a binary using the passed name to ease release creation
  mruby = File.join build_dir, "bin", exefile("mruby")
  product = File.join build_dir, "bin", exefile("mruby-#{name}")

  file product => mruby do
    FileUtils.cp(mruby, product)
  end
  products << product # this adds the target rake task to current build targets
end

def build(name)
  MRuby::CrossBuild.new(name) do |conf|
    conf.toolchain :zig, ARCH_MAPPING[name]
    setup(conf)
  end
end
