#!/usr/bin/env ruby

require 'fileutils'
require './bundles'

if system("which apt-get 2>&1 > /dev/null")
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
elsif system("which pacman 2>&1 > /dev/null")
  pkgs = ['git', 'gvim', 'ruby', 'ack', 'ctags']

  pkgs.each do |pkg|
    puts "Checking if #{pkg} is installed..."
    if !system("pacman -Q #{pkg} 2>&1 > /dev/null")
      system "sudo pacman -S #{pkg}"
    else
      puts "Already installed!"
    end
  end

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

def bundles
  @bundles
end

def bundle_names
  @bundle_names ||= bundles.map { |bundle| bundle.is_a?(String) ? bundle : bundle.first }
end

def remove_stale_bundles
  Dir["#{vim_root}/bundle/*"].each do |dir|
    if File.directory?(dir) && !bundle_names.include?(File.basename(dir))
      puts "removing #{dir}"
      FileUtils.rm_r(dir)
    end
  end
end

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

remove_stale_bundles
