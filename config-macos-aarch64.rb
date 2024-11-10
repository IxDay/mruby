require_relative 'build'

# The mac ARM is the only target where zig toolchain is not working.
# I will open issues to address this, in the meantime, I fallback on legacy compilation method
MRuby::Build.new('host') do |conf|
  conf.toolchain :clang

  conf.disable_libmruby
  conf.disable_presym
  conf.build_mrbc_exec
end

MRuby::Build.new("macos-aarch64") do |conf|
  conf.toolchain :clang

  conf.mrbcfile = MRuby.targets['host'].mrbcfile
  setup(conf)
end
