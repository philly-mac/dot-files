Dir["/home/philip/Audio/Music/**/*"].each do |file|
  puts "PROCESSING #{file}"
  if File.exists?(file)
    File.rename(file, file.gsub(/\.mp3/i,'.mp3')) if /\.mp3$/i =~ file
    File.rename(file, file.gsub(/\.jpg/i,'.jpg')) if /\.jpg$/i =~ file
  end
end
