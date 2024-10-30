#!/usr/bin/env mruby
# This script can be run directly thanks to the shebang capability

def options()
  # Default options of our CLI
  options = {
    :domain => "example.com",
    :days => 3650,
    :clean => false,
  }

  OptionParser.new do |opts|
    program_name = File.basename __FILE__
    # Banner has been heavily inspired by the jq --help output
    opts.banner = <<~EOF
      #{program_name} - generate a root CA for your KPI

      Usage: #{program_name} [options] [DOMAIN]

      This command will generate a self signed certificate with a name constraint on DOMAIN (default to: #{options[:domain]}). It is inspired by the work from:https://systemoverlord.com/2020/06/14/private-ca-with-x-509-name-constraints.html

      Example:

        $ #{program_name} --days 365 --clean foo.bar

      Command options:
    EOF
    opts.on_tail("-h", "--help", "-H", "Display this help message.") do
      puts opts
      exit
    end
    [
      ["--days N", "-D",
        "Set validity period of root CA (defaults to: #{options[:days]}).",
        lambda { |v| options[:days] = Integer(v) }
      ],
      ["--clean",
        "Clean intermediate files, calling with this option will re-generate " +
          "your certificate each time.",
        lambda { |v| options[:clean] = true }
      ],
    ].each { |args| opts.on(*args) }
  end.parse!(ARGV)
  # we take the first remaining argument to override domain if present
  options[:domain] = ARGV.pop || options[:domain]
  options
end

# Certificate extends the Rake DSL, enabling the use and invocation of its functions
# and keywords within code. This serves as an example of how to leverage the DSL
# programmatically, without the need to write a Rakefile.
class Certificate
  include Rake::DSL

  def initialize(domain, days, clean)
    domain_slug = domain.to_s.gsub("\.", "_")
    key = "#{domain_slug}-#{days}-key.pem"
    conf = "#{domain_slug}-conf.ini"
    cert = "#{domain_slug}-#{days}-rootCA.pem"
    req = "#{domain_slug}-#{days}-crt.pem"

    file key do |t|
      sh "openssl genpkey -algorithm ed25519 -out #{t.name}"
    end
    file conf do |t|
      puts "generate config file"
      # inline file creation with a template using heredoc
      File.open(t.name, File::CREAT | File::TRUNC | File::WRONLY).write(<<~EOF
        basicConstraints = critical, CA:TRUE
        keyUsage = critical, keyCertSign, cRLSign
        subjectKeyIdentifier = hash
        nameConstraints = critical, permitted;DNS:.#{domain}
      EOF
      )
    end
    file req => [key] do |t|
      sh "openssl req -new -key #{t.prerequisites.first} -extensions v3_ca -batch -out #{t.name} -utf8"
    end

    @cert = file cert => [key, req, conf] do |t|
      sh "openssl x509 -req -sha256 -days #{days} -in #{req} -signkey #{key} -extfile #{conf} -out #{t.name}"
      next unless clean # exit early if we don't need to clean up
      File.delete(req)
      File.delete(conf)
    end
  end

  # This function is our entrypoint and invoke the Rake task "cert"
  def generate = @cert.invoke()

  # Let's use a static function and take advantage of ruby syntax
  def self.generate(domain:, days:, clean:) = Certificate.new(domain, days, clean).generate
end

Certificate.generate(**options)
