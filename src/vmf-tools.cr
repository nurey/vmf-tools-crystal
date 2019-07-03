# TODO: Write documentation for `Vmf::Tools`
require "dotenv"
require "http/client"
require "json"

class VMF
  SERVERS_ENDPOINT = "https://my.vmfarms.com/api/v1/servers/"

  @servers : String?
  @config : Hash(String, String)

  def initialize
    @config = Dotenv.load!("~/.vmf.env")
  end

  def servers : String
    access_token = @config["ACCESS_TOKEN"]
    uri = URI.parse(SERVERS_ENDPOINT)
    request = HTTP::Client.get(uri,
      headers: HTTP::Headers{"Authorization" => "Token #{access_token}", "Content-Type" => "application/json"}
    )
    response = request.body
  end

  def cached_servers : String
    _cached_servers = @servers
    return _cached_servers if _cached_servers

    @servers = servers
  end

  def active_servers : Array
    JSON.parse(cached_servers)["results"].as_a.select do |server|
      server["server_status"] == "started"
    end.map do |server|
      {
        :name => server["name"].as_s,
        :ip => server["public_interfaces"].as_a.first.as_s
      }
    end
  end

  def servers_by_name : Hash
    active_servers.each_with_object({} of String => String) do |server, memo|
      memo[server[:name]] = server[:ip]
    end
  end

  def servers_sorted : Array
    active_servers.sort { |a, b| a[:name] <=> b[:name] }
  end
end

module Vmf::Tools
  VERSION = "0.1.0"

  def shell(name)
    vmf = VMF.new

    if (ip = vmf.servers_by_name[name]?)
      system "ssh deploy@#{ip}"
    else
      puts "No server found."
      puts "Available servers:"
      puts vmf.servers_sorted.map { |s| "#{s[:name]} – #{s[:ip]}" }.join("\n")
    end
  end
end

include Vmf::Tools

cmd = ARGV.shift?
name = ARGV.shift?

if cmd == "shell"
  shell(name)
else
  puts "Unknown command #{cmd}"
  puts "Available commands:"
  puts "> #{PROGRAM_NAME} shell stage-zoo-app01 # shell into stage-zoo-app01"
  puts "> #{PROGRAM_NAME} shell ? # show available hosts"
end
