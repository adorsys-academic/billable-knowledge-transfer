//
//  Created by Tim Abraham on 11.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//  Proof-Of-Concept for Bachelor Thesis
//  
//  Create https Connection


const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('key.pem'),
  cert: fs.readFileSync('cert.pem')
};

const httpsServer = https.createServer(options, app);
httpsServer.listen(3000);