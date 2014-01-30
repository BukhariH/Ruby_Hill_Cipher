require 'matrix'
require 'SecureRandom'

class Integer
  # http://www.dr-lex.be/random/matrix_inv.html
  def modinv(modulus)
    a, b = modulus, self
    q, r = a / b, a % b
    t0, t1 = 0, 1

    while r > 0
      t0, t1 = t1, (t0 - q * t1) % modulus
      a, b = b, r
      q, r = a / b, a % b
    end

    raise RuntimeError.new("#{self} has no inverse modulo #{modulus}") unless b == 1
    t1
  end
end

class Encrypt
  def self.cipher(file)
    while true
      m = Matrix.build(3) { SecureRandom.random_number(255) + 1 }
      mod_det = m.determinant % 256
      next if mod_det == 0
      begin
        det_inv = mod_det.modinv(256)
        break
      rescue RuntimeError => e
        next
      end
    end

    # Inverse Decryption Matrix
    inv = Matrix[
      [ (m[2,2]*m[1,1] - m[2,1]*m[1,2]), -(m[2,2]*m[0,1] - m[2,1]*m[0,2]),  (m[1,2]*m[0,1] - m[1,1]*m[0,2])],
      [-(m[2,2]*m[1,0] - m[2,0]*m[1,2]),  (m[2,2]*m[0,0] - m[2,0]*m[0,2]), -(m[1,2]*m[0,0] - m[1,0]*m[0,2])],
      [ (m[2,1]*m[1,0] - m[2,0]*m[1,1]), -(m[2,1]*m[0,0] - m[2,0]*m[0,1]),  (m[1,1]*m[0,0] - m[1,0]*m[0,1])]
    ].map { |e| e * det_inv % 256 }

    # Turns the string from the file into an array of characters before taking their ord and then slices the array into 3 sections.
    message_raw = file.chars.map {|x| x.ord}.each_slice(3).to_a
    message_formatted = []

    # Got to make sure each array has a length of 3 for the matrix
    message_raw.each do |msg|
      if msg.length == 1
        msg << 0
        msg << 0
        message_formatted << msg
      elsif msg.length == 2
        msg << 0
        message_formatted << msg
      else
        message_formatted << msg
      end
    end

    message = Matrix.rows(message_formatted)
    # Times the Matrices together to get encrypted matrix
    enc_msg = message * m

    #Write public key with a secret to seperate each value
    pub_key = File.new( "key.pub" , "w")
    pub_key << inv.to_a.join("9fea3112b6475ddcb88ac2630dbcb18acfb6cd586aeaa2b0d181c5964f53936038ac4a836448d3bfbf40486733618407df4d41cc43f6de96abb57a7aa3968ac4")
    pub_key.close


    output_file = File.new( "encrypted_file" , "w")
    output_file.write enc_msg.to_a.join("9fea3112b6475ddcb88ac2630dbcb18acfb6cd586aeaa2b0d181c5964f53936038ac4a836448d3bfbf40486733618407df4d41cc43f6de96abb57a7aa3968ac4")
    output_file.close

    puts "Encrypt Success"
  end
  #Loads file to be encrypted
  self.cipher(File.read(ARGV[0]))
end