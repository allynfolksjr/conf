#!/usr/bin/env ruby

puts "Welcome. I will now place a few awesome symbolic links in place.\n\n"

user_home = `echo $HOME`.strip
dropbox = "#{user_home}/Dropbox/config"

symlink_db = []
symlink_db << ["#{dropbox}/.zshrc","#{user_home}/.zshrc"]
symlink_db << ["#{dropbox}/.hgrc","#{user_home}/.hgrc"]
symlink_db << ["#{dropbox}/.vimrc","#{user_home}/.hgrc"]
symlink_db << ["#{dropbox}/.gitconfig","#{user_home}/.gitconfig"]
symlink_db << ["#{dropbox}/sublime-text-2","#{user_home}/.config/sublime-text-2"]
symlink_db << ["#{dropbox}/apps/hg-prompt","#{user_home}/hg-prompt"]
symlink_db << ["#{dropbox}/apps/image-usb-stick","#{user_home}/image-usb-stick"]
symlink_db << ["#{dropbox}/apps/.oh-my-zsh","#{user_home}/.oh-my-zsh"]
symlink_db << ["#{dropbox}/apps/Sublime\\ Text\\ 2/sublime_text","/usr/bin/subl","root"]
symlink_db << ["#{dropbox}/sysinfo.pl","#{user_home}/sysinfo.pl"]
symlink_db << ["#{dropbox}/Repositories","#{user_home}/Repositories"]
symlink_db << ["#{dropbox}/.rspec","#{user_home}/.rspec"]

symlink_db.each do |db|
	if File.symlink?(db[1])
		puts "#{db[1]} already exists and is a symlink | No action taken"
		puts "#{db[1]} points to #{File.readlink(db[1])}\n\n"
		next
	end
	if File.exist?(db[1]) 
		puts "Warning! #{db[1]} already exists and is NOT a symlink | No action taken\n\n"
		next
	end
	File.symlink(db[0],db[1]) if db[2].nil?
	puts "#{db[1]} created and points to #{File.readlink(db[1])}\n\n" if db[2].nil?
	if db[2] === "root"
		puts "Root permission required"
		`sudo ln -s #{db[0]} #{db[1]}`
	end
end

