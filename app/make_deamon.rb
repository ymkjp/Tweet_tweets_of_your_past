
require "optparse"

OPTS = {}
opt = OptionParser.new
opt.on('-d', '--daemon') {|v| OPTS[:d] = v }
argv = opt.parse(ARGV)
if OPTS[:d]
    exit if fork
    Process.setsid
end
