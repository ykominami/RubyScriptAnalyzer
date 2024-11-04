require 'optparse'
require 'RubyAnalyzer/util'
require 'logger'

require 'RubyAnalyzer/env'
#require 'RubyAnalyzer/contents'
require 'RubyAnalyzer/klassoutput'
require 'RubyAnalyzer/rubysource'

module RubyAnalyzer
  opts = {}
  result = false
  required_options = %i!output_file idlist_file ident_file!
  opt = OptionParser.new do |opt|
    opt.banner = 'Usage: makesript.rb'
    opt.summary_width = 32
    opt.summary_indent = ' ' * 4
    opt.version = '1.0.0'
    
    opt.on("-o oflie", "--output=oflie", ""){|x|
      opts[:output_file] = x
    }
    opt.on("-i idlist_flie", "--idlist=idlist_flie", ""){|x|
      opts[:idlist_file] = x
    }
    opt.on("-d ident_flie", "--ident=ident_flie", ""){|x|
      opts[:ident_file] = x
    }
    begin
      opt.parse!(ARGV)
      result = true
    rescue => ex
      
    end
  end

  if opts.size == 0 || !required_options.all?{|k,v| opts.keys.include?(k)}
    puts opt.help
    exit(1)
  end

  rs = Rubysource.new( opts )
  rs.make_source
  rs.output_source
end # module RubyAnalyzer
