#!/usr/bin/env mruby
# This script can be run directly thanks to the shebang capability

def main(namespace:, context:, path:)
  # switch to proper context if provided
  runp %W[kubectl config use-context #{context}] if context != nil

  # wait for pod to be ready
  runp %W[kubectl wait --for jsonpath='{.status.phase}'=Running -n #{namespace} pod/vault-0]

  # we fork the port forward process, it will be killed at the end of block
  fork(%W[kubectl port-forward -n #{namespace} svc/vault 8200:8200]) do

    # we retry for 5mn to contact the port forwarded
    retries(1000, 0.5) { TCPSocket.new("127.0.0.1", 8200) }

    ENV["VAULT_ADDR"] = "http://127.0.0.1:8200"
    # vault init
    lines = run %W[vault operator init -format json]
    keys, token = JSON.parse(lines.join)["unseal_keys_b64"]["root_token"]

    # we can inject the root token into the env variable used by the vault binary
    ENV["VAULT_TOKEN"] = token

    # pass insert
    run %W[pass insert "#{path}root"], true, "#{token}\n#{token}\n"
    5.times do |i|
      run %W[pass insert "#{path}key_#{i+1}"], true, "#{keys[i]}\n#{keys[i]}\n"
    end

    # vault unseal (we do not nead all unseal keys, so we just push the first 3)
    3.times do |i|
      puts "vault operator unseal XXX..."
      runp %W[vault operator unseal "#{keys[i]}"], false
    end
  end
end

def options()
  # Default options of our CLI
  options = {
    :namespace => "vault",
    :context => nil,
    :path => "vault/",
  }

  OptionParser.new do |opts|
    program_name = File.basename __FILE__
    # Banner has been heavily inspired by the jq --help output
    opts.banner = <<~EOF
      #{program_name} - unseal vault hosted on a given kubernetes cluster

      Usage: #{program_name} [options]

      This command will unseal a vault cluster and store the keys in a pass store

      Example:

        $ #{program_name} --namespace=vault-test --context=staging

      Command options:
    EOF
    opts.on_tail("-H", "-h", "--help", "Display this help message.") do
      puts opts
      exit
    end
    [
      ["--namespace <name>", "-N",
        "A kubernetes namespace where vault can be found (defaults to: #{options[:namespace]}).",
        lambda { |v| options[:namespace] = v }
      ],
      ["--context <name>", "-C",
        "A kubernetes context to switch to in case you don't want to use the default one.",
        lambda { |v| options[:context] = v }
      ],
      ["--path <path>", "-P",
        "A pass path to prepend to the keys inserted (defaults to : #{options[:path]}).",
        lambda { |v| options[:context] = v + "/" if v[-1] != "/" }
      ],
    ].each { |args| opts.on(*args) }
  end.parse!(ARGV)
  options
end

def fork(cmd)
  r, w = IO.pipe
  Kernel.fork do
    puts cmd.join " "
    IO.popen(cmd.join " ") do |p|
      r.gets
      Process.kill "TERM", p.pid
    end
  end
  begin
    yield
  ensure
    w.puts ""
  end
end

def retries(times=-1, wait=0.5)
  loop do
    begin
      yield
      return
    rescue
      return if (times-=1; times == 0)
      sleep wait
    end
  end
end

class IO
  def readlines()
    return to_enum(:readlines, self) unless block_given?
    # the each line from mruby seem broken so we are fixing it this way
    each {|buf| buf.split("\n").each {|line| yield line}}
  end
end


def run(cmd, echo=true, stdin=nil)
  return to_enum(:run, cmd, echo, stdin).to_a unless block_given?
  cmd = (cmd.respond_to? 'join') ? cmd.join(' ') : cmd
  puts cmd if echo
  if stdin
    IO.pipe do |r, w|
      w.write stdin
      w.close
      IO.popen(cmd, "r", in: r) { |f| f.readlines {|l| yield l} }
    end
  else
    IO.popen(cmd) {|f| f.readlines {|l| yield l}}
  end
  raise("Command failed") if not $?.success?
end

def runp(cmd, echo=true)
  run(cmd, echo){|l| puts "  >>> ".green + l }
end

main(**options)
