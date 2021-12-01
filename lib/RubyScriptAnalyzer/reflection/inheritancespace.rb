module RubyScriptAnalyzer
  class InheritanceSpace < HierSpace
    def add( key_array , value )
      key = ([""] + key_array + [value.name_str]).join('/')
      @hs[key] = value

      key
    end
  end
end
