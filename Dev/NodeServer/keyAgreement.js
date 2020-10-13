var EC = require('elliptic').ec;
var ec = new EC('p256');
 
// Generate keys
var key1 = ec.genKeyPair();
var key2 = ec.genKeyPair();
 
var shared1 = key1.derive(key2.getPublic());
var shared2 = key2.derive(key1.getPublic());
 
console.log('Both shared secrets are BN instances');
console.log(shared1.toString(16));
console.log(shared2.toString(16));


var eccrypto = require("eccrypto");
 
var privateKeyA = eccrypto.generatePrivate();
var publicKeyA = eccrypto.getPublic(privateKeyA);
console.log("hello spdjfosdfjk"+publicKeyA)
var privateKeyB = eccrypto.generatePrivate();
var publicKeyB = eccrypto.getPublic(privateKeyB);

// Encrypting the message for B.
eccrypto.encrypt(publicKeyB, Buffer.from("msg to b")).then(function(encrypted) {
  // B decrypting the message.
  eccrypto.decrypt(privateKeyB, encrypted).then(function(plaintext) {
    console.log("Message to part B:", plaintext.toString());
  });
});
 
// Encrypting the message for A.
eccrypto.encrypt(publicKeyA, Buffer.from("msg to a")).then(function(encrypted) {
  // A decrypting the message.
  eccrypto.decrypt(privateKeyA, encrypted).then(function(plaintext) {
    console.log("Message to part A:", plaintext.toString());
  });
});

const NodeRSA = require('node-rsa');
const key = new NodeRSA({b: 512});
console.log("whatsapp"+key.toString)
const text = 'Hello RSA!';
const encrypted = key.encrypt(text, 'base64');
console.log('encrypted: ', encrypted);
const decrypted = key.decrypt(encrypted, 'utf8');
console.log('decrypted: ', decrypted);