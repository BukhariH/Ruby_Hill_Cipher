Ruby_Hill_Cipher
================

The only open source implementation of the Hill Cipher in Ruby.

![Hill Cipher Machine](https://i.imgur.com/nDVYLbr.png)

## How to use:

### Encrypt
``` bash
git clone git@github.com:BukhariH/Ruby_Hill_Cipher.git
ruby encrypt.rb your_file.txt
```

This will produce two files:
* encrypted_file
* key.pub

Now go ahead and share those two files in WW1 fashion.

### Decrypt
Using files created earlier:

``` bash
ruby decrypt.rb key.pub encrypted_file
```
Now a new decrypted file will be created:
decrypted_file.txt

### Test
Best to run test first:

``` bash
cd test/
ruby test.rb
```

## Warning

This is fun. Please do not use in production because:
[How to decode a Hill Cipher without a key](https://www.youtube.com/watch?v=gKJQFkG5Rvc)