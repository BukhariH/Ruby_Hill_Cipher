def with_argv(*argv)
	original_argv = ARGV.dup
	ARGV.replace(argv)
	yield
	ARGV.replace(original_argv)
end

with_argv("Law.txt") do
	require '../encrypt'
end

with_argv("key.pub", "encrypted_file") do
	require '../decrypt'
end

class Test
	if File.read("Law.txt") == File.read("decrypted_file.txt").gsub("\u0000", "")
		File.delete("key.pub")
		File.delete("encrypted_file")
		File.delete("decrypted_file.txt")
		puts "Passed with flying colours"
	else
		File.delete("key.pub")
		File.delete("encrypted_file")
		puts "Test Failed"
	end
end