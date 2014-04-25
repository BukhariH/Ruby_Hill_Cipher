require 'matrix'

class Decrypt
  def self.decrypt_cipher(key, vol)

    salt = '9fea3112b6475ddcb88ac2630dbcb18acfb6cd586aeaa2b0d181c5964f53936038ac4a836448d3bfbf40486733618407df4d41cc43f6de96abb57a7aa3968ac4'
    inv = key.split(salt).map { |x| x.to_i }.each_slice(3).to_a
    enc_msg = vol.split(salt).map { |x| x.to_i }.each_slice(3).to_a


    dec_key = Matrix.rows(enc_msg) * Matrix.rows(inv)
    dec_key = dec_key.map { |e| e % 256 }

    output = []
    dec_key.to_a.each do |m|
      m.each do |x|
        output << x.chr.force_encoding('UTF-8')
      end
    end

    File.open('decrypted_file.txt', 'w:UTF-8') do |f|
      f.write output.join
    end

    puts 'Decrypt Success'
  end

  decrypt_cipher(File.read("#{ARGV[0]}"), File.read("#{ARGV[1]}"))
end
