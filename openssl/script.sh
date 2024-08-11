###Gen auto signed Crt & Key
openssl req -x509 -newkey rsa:4096 -sha256 -days 36500 \
  -nodes -keyout antonio3a.aaa.key -out antonio3a.aaa.crt \
  -subj "/C=AO/ST=Luanda/L=Luanda/O=3A Group Inc./OU=3A Dev LLC/CN=antonio3a.aaa" \
  -addext "subjectAltName=DNS:antonio3a.aaa,DNS:*.antonio3a.aaa"
