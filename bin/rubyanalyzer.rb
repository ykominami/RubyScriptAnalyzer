require 'optparse'
require 'set'
require 'logger'
require 'yaml'
# require 'astarisk'
require 'pathname'
require 'find'
require 'fileutils'
require 'benchmark'
# require 'env'
require 'pry'

require 'RubyAnalyzer/util'
require 'RubyAnalyzer/hierspace'
require 'RubyAnalyzer/item'
require 'RubyAnalyzer/ns'
require 'RubyAnalyzer/analyzer'
require 'RubyAnalyzer/ast'

require 'RubyAnalyzer/env_test'
require 'RubyAnalyzer/rubyanalyzer_test'

module RubyAnalyzer
  class App
    def initialize
      # Util.level = Logger::Severity::DEBUG
      Util.level = Logger::Severity::INFO
      # Util.level = Logger::Severity::WARN
      # Util.level = Logger::Severity::ERROR
      # Util.level = Logger::Severity::FATAL
      # Util.level = Logger::Severity::UNKNOWN
    end

    def setup_for_global
      @module_const_name = nil
      name = self.class.to_s.split('::')[0]
      const = Object.const_get( name )
      if const.instance_of?(::Module)
        @module_const_name = name
      end
      Itembase.set_module_name( @module_const_name )
    end

    def setup_for_ast(filelist_fname)
      @file_path_array = File.readlines( filelist_fname ).map(&:chomp)
    end

    def parse_all_script
      @file_path_array.each do |fpath|
        Env.new_env_for_ast( fpath )
        ast = Ast.new( fpath )
        ast.parse0
      end
    end

    def setup_for_reflection(fpath)
      @yaml = YAML.load_file(fpath)
      p "@yaml=#{@yaml}"
    end

    def analyze_by_reflection
      Env.new_env_reflection( self )
      analyzer = RubyAnalyzer::Analyzer.new( @yaml )
      analyzer.analyze
    end
  end

  opts = {
    :restore => false,
    :filelist => "flist.txt",
    :inputfpath => 'ra_inputfname.txt',
    :storefile => "/tmp/store.store",
  }

  conf_file = ENV.fetch('RUBYANALYZER_CONF', nil)
  conf_file ||= File.join(Dir.home, "rubyanalyzer.conf")

  @conf = YAML.load_file(conf_file)
  p @conf
  opts_keys = opts.keys
  opts_keys.each do |key|
    opts[key] = @conf[key.to_s] if @conf[key.to_s]
  end

=begin
  opt = OptionParser.new do |opt|
    opt.banner = 'Usage: rubyanalyzer.rb'
    opt.summary_width = 32
    opt.summary_indent = ' ' * 4
    opt.version = '1.0.0'

    opt.on("-l filelist", "--filelist=flie", ""){|x|
      opts[:filelist] = x
    }
    opt.on("-i inputfpath", "--inputfpath=inputfpath", ""){|x|
      opts[:inputfpath] = x
    }
    opt.on("-s storefile", "--storefile=storeflie", ""){|x|
      opts[:storefile] = x
    }
    opt.on("-r", "--restore", ""){|x|
      opts[:restore] = true
    }

    begin
      opt.parse!(rubyanalyzer_arg)
      result = true
    rescue => ex

    end
  end
=end
  #  p "ARGV=#{ARGV}"

  results = []
  app = nil

  filelist_fname = opts[:filelist]
  inputfpath = opts[:inputfpath]
  store_file = opts[:storefile]
  restore_flag = opts[:restore]

  #  LOAD_STORE_FILE = false

  ret = Benchmark.measure do
    app = App.new
  end
  results << ["init", ret]

  unless restore_flag
    ret = Benchmark.measure do
      app.setup_for_global
    end
    results << ["setup_for_global" , ret]

    ret = Benchmark.measure do
      app.setup_for_ast( filelist_fname )
      app.parse_all_script
    end
    results << ["ast" , ret]

    ret = Benchmark.measure do
      app.setup_for_reflection(inputfpath)
      app.analyze_by_reflection
    end
    results << ["reflection", ret]

    FileUtils.rm_f(store_file)

    ret = Benchmark.measure do
      Env.save(store_file)
    end
    results << ["save" , ret]
  end

  Env.reset_env
  ret = Benchmark.measure do
    obj = Env.load( store_file )
    Env.set_env( obj )
  end
  results << ["sotre" , ret]

  gvar_hs = {}
  gasgn_hs = {}

  env_keys = Env.get_env_keys
  pp "env_keys=#{env_keys}"
  env_ast_keys = Env.get_env_ast_keys
  pp "env_ast_keys=#{env_ast_keys}"

  env_ast_keys.each do |index|
    pp "index=#{index}"
    Env.get_env_ast_by_index(index)
  end
  gasgn_index = Env.get_ast_class_index( RubyAnalyzer::Ast::Gasgn )
  gvar_index =  Env.get_ast_class_index( RubyAnalyzer::Ast::Gvar )

  pp "gasgn_index=#{gasgn_index}"
  pp "gvar_index=#{gvar_index}"
  # binding.pry
  # exit

  puts "# gvar"
  ret = Benchmark.measure do
    app.show_item_list( gvar_hs )
  end
  results << ["show_item_list" , ret]
  puts ""
  puts "# gasgn"
  ret = Benchmark.measure do
    app.show_item_list( gasgn_hs )
  end
  results << ["show_item_list" , ret]
  #  app.testx

  # show all result
  results.each do |ary|
    pp ary[0]
    puts ary[1]
  end

  exit
end
