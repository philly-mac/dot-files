require 'fileutils'

home = File.expand_path '~/'
base = File.expand_path "#{home}/.bash"

files = [
  ["#{base}/gitconfig", "#{home}/.gitconfig"],
  ["#{base}/irbrc",     "#{home}/.irbrc"],
  ["#{base}/pryrc",     "#{home}/.pryrc"],
  ["#{base}/railsrc",   "#{home}/.railsrc"],
  ["#{base}/vim",       "#{home}/.vim"],
  ["#{base}/jedit",       "#{home}/.jedit"],
]

files.each do |file, linked_file|
  unless File.exist?(linked_file)
    puts "Creating #{linked_file} ..."
    FileUtils.ln_s(file, linked_file)
  end
end
