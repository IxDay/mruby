def ext(target)
  target.match(/cygwin|mswin|mingw|bccwin|wince|emx/i) ? ".exe" : ""
end

class MRuby::Toolchain::Zig
  ARCHITECTURES = {
    "i386-windows"      => "i686-w64-mingw32",
    "x86_64-windows"    => "x86_64-w64-mingw32",
    "aarch64-windows"   => "aarch64-w64-mingw32",
    "i386-linux"        => "i386-linux",
    "x86_64-linux"      => "x86_64-linux",
    "aarch64-linux"     => "aarch64-linux",
    "x86_64-linux-musl" => "x86_64-linux-musl",
  }

  attr_reader :target, :arch, :ar
  def initialize(target)
    @target = target || RUBY_PLATFORM
    @arch = ARCHITECTURES[@target]
  end

  def exec_ext = ext(@arch)

  def cc = "zig cc -target #{@target}"
  def cxx = "zig c++ -target #{@target}"

  def ar = "zig ar"
end

MRuby::Toolchain.new(:zig) do |conf, target|
  zig = MRuby::Toolchain::Zig.new(target)
  ext = ext(RUBY_PLATFORM)

  mrbc = MRuby::Build.new('host') do |conf|
    conf.toolchain :gcc, default_command: "zig cc"
    conf.build_mrbc_exec
    conf.disable_libmruby
    conf.disable_presym
    conf.archiver.command = zig.ar
    conf.exts.executable = ext
  end

  ENV['CC'] = zig.cc
  ENV['CXX'] = zig.cxx
  toolchain :gcc

  if conf.kind_of?(MRuby::CrossBuild)
    conf.host_target = zig.arch
  end
  conf.mrbcfile = File.join(mrbc.class.install_dir, "mrbc" + ext)
  conf.archiver.command = zig.ar
  conf.exts.executable = zig.exec_ext
end

%w[x86_64-windows].each do |arch|
  MRuby::CrossBuild.new(arch) do |conf|
    conf.toolchain :zig, arch

    conf.gembox "stdlib"
    conf.gembox "stdlib-ext"
    conf.gembox "stdlib-io"
    conf.gembox "math"
    conf.gembox "metaprog"

    # Generate mruby command
    conf.gem :core => "mruby-bin-mruby"

    # conf.gem :github => 'mruby-Forum/mruby-ansi-colors'
    # conf.gem '../mrake'
    # conf.gem :github => 'ixday/mrake'
    # conf.gem :github => 'mattn/mruby-json'
    # conf.gem '../mruby-yaml'
    # conf.gem :github => 'ixday/mruby-polarssl'

    conf.cc do |cc|
    cc.flags << '-Os'
    end
  end
end
