def is_windows?(target) = target.match(/cygwin|mswin|mingw|bccwin|wince|emx/i)

class MRuby::Toolchain::Zig

  class ArchitectureNotSupported < StandardError
    attr_reader :arch
    def initialize(arch) = @arch = arch
    def message = "#{@arch} is not supported"
  end

  ARCHITECTURES = {
    "i386-windows-gnu"      => "i686-w64-mingw32",
    "x86_64-windows-gnu"    => "x86_64-w64-mingw32",
    "i386-linux"            => "i386-linux",
    "x86_64-linux"          => "x86_64-linux",
    "aarch64-linux"         => "aarch64-linux",
    "x86_64-linux-musl"     => "x86_64-linux-musl",
    "aarch64-macos"         => "aarch64-macos",
    "x86_64-macos"          => "x86_64-macos",
  }

  attr_reader :target, :arch
  def initialize(target=nil)
    @target = target || RUBY_PLATFORM
    @arch = ARCHITECTURES[@target] || raise(ArchitectureNotSupported.new @target)
  end

  def cc  = "zig cc -target #{@target}"
  def cxx = "zig c++ -target #{@target}"
  def ar  = "zig ar"
  def exe = is_windows?(@arch) ? ".exe" : ""

  def setup(conf)
    conf.toolchain :clang
    conf.exts.executable = exe
    conf.exts.library = is_windows?(@arch) ? ".lib" : ".a"
    conf.cc.command = cc
    conf.linker.command = cc
    conf.cxx.command = cxx
    conf.archiver.command = ar
    conf.linker.command = cc
    conf.host_target = @arch if conf.kind_of?(MRuby::CrossBuild)
  end
end

MRuby::Toolchain.new(:zig) do |conf, target|
  target = MRuby::Toolchain::Zig.new(target)
  host = MRuby::Toolchain::Zig.new()

  mrbc = MRuby::Build.new('host') do |conf|
    host.setup(conf)
    conf.build_mrbc_exec
    conf.disable_libmruby
    conf.disable_presym
  end

  target.setup(conf)
  conf.mrbcfile = File.join(mrbc.class.install_dir, "mrbc" + host.exe)
end


%w[
  x86_64-linux
  x86_64-windows-gnu
].each do |arch|
  MRuby::CrossBuild.new(arch) do |conf|
    conf.toolchain :zig, arch

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
  # conf.gem :github => 'ixday/mrake'
  # conf.gem '../mruby-rake'

  # conf.gem :github => 'mruby-Forum/mruby-ansi-colors'
  #   # conf.gem '../mrake'
  #   # conf.gem :github => 'ixday/mrake'
  #   # conf.gem :github => 'mattn/mruby-json'
  # # conf.gem '../mruby-yaml'
  #   # conf.gem :github => 'ixday/mruby-polarssl'
  #   # conf.gem :mgem => "mruby-dir"
  # conf.gem :core => 'mruby-dir'
  # # conf.gem :core => "mruby-io"
  # # conf.gem '../mruby-onig-regexp'
  # conf.gem :mgem => "mruby-optparse"
  # # spec.add_dependency "mruby-process"
  # # spec.add_dependency "mruby-require"
  # # spec.add_dependency "mruby-file-stat"
  # # spec.add_dependency "mruby-array-ext"
  # # spec.add_dependency "mruby-dir-glob"

    conf.cc do |cc|
      cc.flags << '-Os'
    end
  end
end
