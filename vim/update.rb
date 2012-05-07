#!/usr/bin/env ruby

require 'fileutils'

pkgs = ['git-core', 'vim-gnome', 'ruby', 'ack-grep', 'exuberant-ctags']

pkgs.each do |pkg|
  puts "Checking if #{pkg} is installed..."
  if !system("dpkg -l | egrep \"\\s$pkg\\s\" 2>&1 > /dev/null")
    system "sudo apt-get install -y #{pkg}"
  else
    puts "Already installed!"
  end
end

if File.exist?("/usr/bin/ack-grep") && !File.symlink?("/usr/local/bin/ack")
  puts "Creating symlink for ack-grep"
  system "sudo ln -s /usr/bin/ack-grep /usr/local/bin/ack"
end

def home_root
  @home_root ||= File.expand_path("~")
end

def vim_root
  @vim_root ||= File.expand_path("~/.vim")
end

def gitbase
  @gitbase ||= "https://github.com/vim-scripts"
end

bundles = [
  ["vim-rooter",  "git://github.com/airblade/vim-rooter.git"],
  ["vim-sparkup", "git://github.com/kogakure/vim-sparkup.git"],
  #["Command-T", Proc.new({|vim_base| FileUtils.cd("#{vim_base}/bundle/Command-T/ruby/command-t"){system("/usr/bin/ruby extconf.rb"); system("make"))})],
  "ack.vim",
  "bufexplorer.zip",
  "Conque-Shell",
  "taglist.vim",
  "fugitive.vim",
  "Gundo",
  "rails.vim",
  "repeat.vim",
  "Rainbow-Parenthesis",
  "scratch-utility",
  "scratch.vim",
  "snipMate",
  "SuperTab",
  "surround.vim",
  "The-NERD-Commenter",
  "The-NERD-tree",
  "YankRing.vim",
  "ZoomWin",
  "hexHighlight.vim",
  "unimpaired.vim",
  "mru.vim",
  "Tabular",
  "haml.zip",
  "AutoClose",
  "jQuery",
  "JSON.vim",
  "matchit.zip",
  "VisIncr",
]

def update_code(base_dir, package, repo = nil)
  puts "Checking #{package}..."
  git_repo = repo || "#{gitbase}/#{package}.git"
  if File.directory?("#{base_dir}/#{package}")
    if File.directory?("#{base_dir}/#{package}/.git")
      puts "Udating from git.."
      FileUtils.cd("#{base_dir}/#{package}") { system("git pull") }
    else
      puts "Cloning into an exsiting directory..."
      FileUtils.cd("#{base_dir}/#{package}") { system("git clone #{git_repo} ./") }
    end
  else
    puts "Fresh clone"
    FileUtils.cd("#{base_dir}") { system("git clone #{git_repo}") }
  end

  puts "\n"
end

#TODO
# Compile c extension for commandT

update_code(vim_root, "pathogen.vim")

bundles.each do |bundle|
  dir = "#{vim_root}/bundle"
  repo = nil
  package = ''

  if bundle.is_a?(Array)
    package = bundle.first
    repo = bundle.last
  else
    package = bundle
  end

  update_code(dir, package, repo)
end

if !File.exist?("~/.vimrc")
  begin
    FileUtils.ln_s("#{vim_root}/vimrc", "#{home_root}/.vimrc")
  rescue Errno::EEXIST => e
    puts "Symlink already exists. Not recreating!"
  end
end

