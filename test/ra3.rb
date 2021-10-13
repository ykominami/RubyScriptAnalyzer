require 'rubyanalyzer2'

home_dir = '/home/ykominami'
dotfiles_dir = File.join(home_dir, "dotfiles")
dotfiles_win_dir = File.join(dotfiles_dir, "win")
repo_dir = File.join( home_dir , "repo", "tecsgen-trunk")
dotfiles_win_binr_dir = File.join( dotfiles_win_dir , "binr")

#fname = '/mnt/v/ext2/gem/tecsgen/y51.rb'
#fname = '/mnt/v/ext2/gem/tecsgen/y52.rb'
#fname = '/mnt/e/v/ext2/svn-tecs/tecsgen/trunk2/tecsgen/tecsgen.rb'
#fname = "#{repo_dir}/tecsgen/tecsgen.rb"
#fname = "#{dotfiles_win_binr_dir}/rb2.rb"
#fname = "rb2.rb"
fname = File.join(Dir.pwd , "rb2.rb" )

#fname2 = nil
#fname2 = '/mnt/v/ext2/gem/tecsgen/spec/test_data/r.rb'
#fname2 = '/mnt/e/v/ext2/gem/tecsgen/spec/test_data/r-a.rb'
#fname2 = File.join( dotfiles_win_binr_dir, "r-a.txt")
#fname2 = File.join( dotfiles_win_binr_dir, "r-a.rb")
#fname2 = "r-a.rb"
fname2 = File.join(Dir.pwd , "r-a-2-2.rb")
#fname2 = File.join( dotfiles_win_binr_dir, "r-a0.rb")
#fname2 = File.join( dotfiles_win_binr_dir, "r-a-2.rb")
#fname2 = File.join( dotfiles_win_binr_dir, "r-a-2-2.rb")

#target_classname_fname = '/mnt/c/Users/ykomi/binr/ra_target_classname.txt'
#target_classname_fname = '/mnt/c/Users/ykomi/binr/target_class-list.txt'
#target_classname_fname = '/mnt/c/Users/ykomi/binr/target_class-list-2.txt'
#target_classname_fname = '/mnt/c/Users/ykomi/binr/target_class-list-3.txt'
#exclude_classname_fname = '/mnt/c/Users/ykomi/binr/ra_exclude_classname.txt'

# target_classname_fname = File.join( dotfiles_win_binr_dir, "target_class-list-3.txt")
target_classname_fname = "target_class-list-3.txt"
target_classname_fname = File.join(Dir.pwd , target_classname_fname) 
# exclude_classname_fname = File.join( dotfiles_win_binr_dir, "ra_exclude_classname.txt")
exclude_classname_fname = "ra_exclude_classname.txt"
exclude_classname_fname = File.join(Dir.pwd , exclude_classname_fname)
#
exclude_constname_fname = "ra_exclude_constname.txt"
exclude_constname_fname = File.join(Dir.pwd , exclude_constname_fname)
#
puts %Q!RubyAnalyzer::Analyzer.new( #{fname} , #{fname2},  #{target_classname_fname}, #{exclude_classname_fname} )!
RubyAnalyzer::Analyzer.new(target_classname_fname, exclude_classname_fname, exclude_constname_fname, fname , fname2)
