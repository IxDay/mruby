
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
    "aarch64-linux-musl"    => "aarch64-linux-musl",
    # those two are not working at the moment
    # "aarch64-macos"         => "aarch64-macos",
    # "x86_64-macos"          => "x86_64-macos",
  }

  attr_reader :target, :arch
  def initialize(target=RUBY_PLATFORM)
    @target = target
    @arch = ARCHITECTURES[@target] || (@target if is_native?)
    raise ArchitectureNotSupported.new @target if @arch == nil
  end

  def cc  = "zig cc" + (is_native? ? "" : " -target #{@target}")
  def cxx = "zig c++" + (is_native? ? "" : " -target #{@target}")
  def ar  = "zig ar"
  def exe = is_windows? ? ".exe" : ""

  def is_windows? = @arch.match(/cygwin|mswin|mingw|bccwin|wince|emx/i)
  def is_native? = @target == RUBY_PLATFORM

  def setup(conf)
    conf.toolchain :clang
    conf.host_target = @arch if conf.kind_of?(MRuby::CrossBuild)

    conf.exts.library = is_windows? ? ".lib" : ".a"
    conf.exts.executable = exe
    conf.cc.command = cc
    conf.linker.command = cc
    conf.cxx.command = cxx
    conf.archiver.command = ar
    conf.linker.command = cc
  end
end

MRuby::Toolchain.new(:zig) do |conf, target|
  host = MRuby::Toolchain::Zig.new()

  host.setup(conf) and next if !conf.kind_of?(MRuby::CrossBuild)

  target = MRuby::Toolchain::Zig.new(target)
  mrbc = MRuby::Build.new('host') do |conf|
    host.setup(conf)
    conf.build_mrbc_exec
    conf.disable_libmruby
    conf.disable_presym
  end

  target.setup(conf)
  conf.mrbcfile = File.join(mrbc.class.install_dir, "mrbc" + host.exe)
end
