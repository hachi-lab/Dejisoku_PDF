require 'openssl'
include OpenSSL::PKey

#RSA生成
rsa = OpenSSL::PKey::RSA.generate(2048)

#公開鍵・秘密鍵抽出
public_key = rsa.public_key

password = "pass"
private_key = rsa.export(OpenSSL::Cipher::Cipher.new("aes256"), password)

#秘密鍵で署名
data = "test"
sign = rsa.sign("sha256", data)

#公開鍵で検証
p public_key.verify("sha256", sign, data)

#不正なデータを検証
p public_key.verify("sha256", sign, "miss")
