require 'stringio'
require 'logger'

require 'RubyAnalyzer/raenv'

module RubyAnalyzer
  class Util

    EnvStruct = Struct.new(:debug, :logger, :original_format)
    @@cv = EnvStruct.new
    @@cv.debug = false
    @@cv.logger = Logger.new(STDOUT)
    @@cv.logger.level = Logger::WARN
    @@cv.original_format = Logger::Formatter.new
    @@cv.logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end

    class << self
      def get_top_module_name( klass )
        module_name = nil
        array = klass.to_s.split('::')
        if array.size > 1
          const = Object.const_get( array[0] )
          if const.class.to_s == "Module"
            module_name = array[0]
          end
        end
        module_name
      end
      
      def indent( level )
        "#{' ' * level}"
      end

      def debug_pp( obj )
        out = StringIO.new
        PP.pp(obj, out)
        @@cv.logger.debug( out.string )
      end
    
      def level=( level )
        @@cv.logger.level = level
      end

      def debug( mes )
        @@cv.logger.debug( mes )
      end

      def info( mes )
        @@cv.logger.info( mes )
      end

      def warn( mes )
        @@cv.logger.warn( mes )
      end

      def error( mes )
        @@cv.logger.error( mes )
      end
      
      def fatal( mes )
        @@cv.logger.fatal( mes )
      end

      def unknown( mes )
        @@cv.logger.unknown( mes )
      end

      def remove_empty_line( list)
        list.map{|x| x.chomp}.select{ |y| y !~ /^\s*$/ }
      end      
    end
  end
end # module RubyAnalyzer
