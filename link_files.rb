require 'fileutils'

home = File.expand_path '~/'
base = File.expand_path "#{home}/.bash"

files = [
  ["#{base}/gitconfig", "#{home}/.gitconfig"],
  ["#{base}/irbrc",     "#{home}/.irbrc"],
  ["#{base}/pryrc",     "#{home}/.pryrc"],
  ["#{base}/railsrc",   "#{home}/.railsrc"],
  ["#{base}/vim",       "#{home}/.vim"],
]

files.each do |file|
  unless File.exist?(file[1])
    puts "Creating #{file[1]} ..."
    FileUtils.ln_s(file[0], file[1])
  end
end
