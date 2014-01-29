require 'matrix'

class Decrypt
key = File.read("#{ARGV[0]}")
vol = File.read("#{ARGV[1]}")

inv = key.split("9fea3112b6475ddcb88ac2630dbcb18acfb6cd586aeaa2b0d181c5964f53936038ac4a836448d3bfbf40486733618407df4d41cc43f6de96abb57a7aa3968ac4").map { |x| x.to_i }.each_slice(3).to_a
enc_msg = vol.split("9fea3112b6475ddcb88ac2630dbcb18acfb6cd586aeaa2b0d181c5964f53936038ac4a836448d3bfbf40486733618407df4d41cc43f6de96abb57a7aa3968ac4").map { |x| x.to_i }.each_slice(3).to_a


dec_key = Matrix.rows(enc_msg) * Matrix.rows(inv)
dec_key = dec_key.map { |e| e % 256 }

output = []
dec_key.to_a.each do |m|
  m.each do |x|
      output << x.chr.force_encoding("UTF-8")
  end
end

output_file = File.open("#{File.basename("#{ARGV[1]}").gsub!("encrypted", "decrypted")}", "w:UTF-8") do |f|
f.write output.join()
end



puts "Decrypt Success."
end