require 'optparse'
require 'RubyAnalyzer/util'
require 'logger'

require 'RubyAnalyzer/env'
# require 'RubyAnalyzer/contents'
require 'RubyAnalyzer/klassoutput'
require 'RubyAnalyzer/rubysource'

module RubyAnalyzer
  opts = {}
  result = false
  required_options = %i[output_file idlist_file ident_file]
  OptionParser.new do |opt|
    opt.banner = 'Usage: makesript.rb'
    opt.summary_width = 32
    opt.summary_indent = ' ' * 4
    opt.version = '1.0.0'

    opt.on("-o oflie", "--output=oflie", "") do |x|
      opts[:output_file] = x
    end
    opt.on("-i idlist_flie", "--idlist=idlist_flie", "") do |x|
      opts[:idlist_file] = x
    end
    opt.on("-d ident_flie", "--ident=ident_flie", "") do |x|
      opts[:ident_file] = x
    end
    begin
      opt.parse!(ARGV)
      result = true
    rescue StandardError => ex
      puts ex
    end
  end

  if opts.empty? || !required_options.all?{|k, _v| opts.keys.include?(k)}
    puts opt.help
    exit(1)
  end

  rs = Rubysource.new( opts )
  rs.make_source
  rs.output_source
end
