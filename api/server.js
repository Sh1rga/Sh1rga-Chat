'use strict';
var flag_enable = false;

const express = require( 'express' );
const http = require( 'http' );
const socketIO = require( 'socket.io' );
const fs = require( 'fs-extra' );
const cron = require('node-cron');
const cryptico = require('cryptico');
require('date-utils');

const app = express();
const server = http.Server( app );
const io = socketIO( server );
app.set( 'views', __dirname + '/resources' );
app.set( 'view engine', 'ejs' );
const PORT = process.env.PORT || 6336;

var version = 0;
var counter = 0;
var time = "null";
var dataUser = "./database/user/";
var dataRoom = "./database/room/";
var dataFlag = "./database/flag/";
var len = 6;
var str = "0123456789";
var strLen = str.length;
var server_encrypt = "";
var server_decrypt = "";

var enc_bits = 2048;
var enc_len = 16;
var enc_str = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var enc_strLen = enc_str.length;
var enc_result = "";

io.on(
    'connection',
    ( socket ) =>
    {

        socket.on(
            'start', //Start
            ( strMessage ) =>
            {
                //Counter
                counter += 1;
                
                try {
                
                var crypt = strMessage;
                socket.emit( 'start' )
                
                //Get Time
                var wt = new Date();
                var time = wt.toFormat("HH24MISS");
                var htime = wt.toFormat("HH24");

                //Create roomID and userID
                var roomIDdetect = true;
                while( roomIDdetect == true ) {
                    var g_result = "";
                    var roomID = "";
                    for (var i = 0; i < len; i++) {
                    g_result += str[Math.floor(Math.random() * strLen)];
                    }
                    if( fs.existsSync( dataRoom + htime + '/' + roomID + '.json' ) ){
                        roomIDdetect = true;
                    }else{
                        roomIDdetect = false;
                    }
                }    
                
                var userIDdetect = true;
                while( userIDdetect == true ) {
                    var j_result = "";
                    var userID
                    for (var i = 0; i < len; i++) {
                    j_result += str[Math.floor(Math.random() * strLen)];
                    }
                    if( fs.existsSync( dataUser + htime + '/' + userID + '.json' ) ){
                        userIDdetect = true;
                    }else{
                        userIDdetect = false;
                    }
                }    
                
                roomID = time + g_result;
                userID = time + j_result;
                
                //Create room json file
                const room = {
                    join: false,
                    first_encrypt: crypt,
                    first: "",
                    second_encrypt: "",
                    second: "",
                    flag: false
                }
                const roomJson = JSON.stringify(room)
                fs.writeFileSync(dataRoom + htime + '/' + roomID + '.json', roomJson)
                
                //Create user json file
                const user = {
                    id: roomID,
                    first: true
                }
                const userJson = JSON.stringify(user)
                fs.writeFileSync(dataUser + htime + '/' + userID + '.json', userJson)
                
                //Send to client
                var msgcrypt = cryptico.encrypt(roomID, crypt);
                socket.emit( 'get-roomid', msgcrypt.cipher)
                var msgcrypt2 = cryptico.encrypt(userID, crypt);
                socket.emit( 'get-userid', msgcrypt2.cipher)
                } catch {
                    socket.emit( 'start-error' )
                }
                
            } );
            
            socket.on(
            'join',
            ( strMessage ) =>
            {   
                try {
                strMessage = cryptico.decrypt(strMessage, server_decrypt).plaintext;

                var findroom = false;
                try {
                var rtime = strMessage.substr( 0, 2 );
                var roomID = strMessage.substr( 0, 12 );
                var crypt = strMessage.substr( 12 );
                
                //Read room json
                //コード圧縮のためと面倒くささに負けて、エラー処理が雑ですが、たぶん大丈夫だと思います。。。たぶんね。。
                try {
                    var rjson = JSON.parse(fs.readFileSync(dataRoom + rtime + '/' + roomID + '.json', 'utf8'));
                    findroom = true;
                } catch {
                    socket.emit( 'join-notfound' )
                    findroom = false;
                }
                var joined = rjson.join;
                var first_crypt = rjson.first_encrypt;
                
                //Get Time
                var wt = new Date();
                var time = wt.toFormat("HH24MISS");
                var htime = wt.toFormat("HH24");
                
                //Create userID
                var userIDdetect = true;
                while( userIDdetect == true ) {
                    var j_result = "";
                    for (var i = 0; i < len; i++) {
                    j_result += str[Math.floor(Math.random() * strLen)];
                    }
                    if( fs.existsSync( dataUser + htime + '/' + userID + '.json' ) ){
                        userIDdetect = true;
                    }else{
                        userIDdetect = false;
                    }
                }
                
                var userID = time + j_result;
                
                //Check if the user is available to participate
                if (joined == false){
                    //Rewrite room json
                    rjson.join = true;
                    rjson.second_encrypt = crypt;
                    const roomJson = JSON.stringify(rjson)
                    fs.writeFileSync(dataRoom + rtime + '/' + roomID + '.json', roomJson)
                    
                    //Create user json file
                    const user = {
                        id: roomID,
                        first: false
                    }
                    const userJson = JSON.stringify(user)
                    fs.writeFileSync(dataUser + htime + '/' + userID + '.json', userJson)
                    
                    //Send to client
                    var msgcrypt = cryptico.encrypt(userID, crypt);
                    socket.emit( 'get-userid', msgcrypt.cipher)
                    socket.emit( 'join', first_crypt )
                }else{
                    socket.emit( 'joined' )
                }
                
                } catch {
                    if (findroom == true) {
                        socket.emit( 'join-error' )
                    }
                }
                } catch { socket.emit( 'join-error' ) }
                
            } );
            
            socket.on(
            'load',
            ( strMessage ) =>
            {
                try {
                strMessage = cryptico.decrypt(strMessage, server_decrypt).plaintext;
                try {
                    var ujson = "";
                    var utime = strMessage.substr( 0, 2 );
                    var roomID = 0;
                    var rtime = 0;
                    var rjson = "";
                    var fUser = false;
                    var flag = false;
                    
                    //Get json file
                    //ここも処理が雑だけどゆるしておくれ( ；∀；)
                    try {
                    ujson = JSON.parse(fs.readFileSync(dataUser + utime + '/' + strMessage + '.json', 'utf8'));
                    roomID = ujson.id;
                    rtime = roomID.substr( 0, 2 );
                    fUser = ujson.first;
                    rjson = JSON.parse(fs.readFileSync(dataRoom + rtime + '/' + roomID +'.json', 'utf8'));
                    flag = rjson.flag;
                    } catch {
                        socket.emit( 'roomNotFound' )
                    }
                    
                    //Send a message
                    if (flag == false) {
                    if (fUser == false) {
                        socket.emit( 'load', rjson.first )
                    }else{
                        socket.emit( 'load', rjson.second )
                    }
                    }else{
                        socket.emit( 'roomFlagged' )
                    }
                        
                } catch {
                    socket.emit( 'load-error' )
                }
                
                } catch { socket.emit( 'load-error' ) }
            } );
            
            socket.on(
            'first-load', //This is a program for the person who started the room to check if there are any participants in the room
            ( strMessage ) =>
            {
                try {
                strMessage = cryptico.decrypt(strMessage, server_decrypt).plaintext;
                var utime = strMessage.substr( 0, 2 );
                var userID = strMessage.substr( 0, 12 );
                //Get json file
                var ujson = JSON.parse(fs.readFileSync(dataUser + utime + '/' + userID + '.json', 'utf8'));
                var roomID = ujson.id;
                var rtime = roomID.substr( 0, 2 );
                var rjson = JSON.parse(fs.readFileSync(dataRoom + rtime + '/' + roomID + '.json', 'utf8'));
                var joined = rjson.join;
                var crypt = rjson.second_encrypt;
                
                //Send to client
                if (joined == true){
                    socket.emit( 'first-load', "1" + crypt)
                }else{
                    socket.emit( 'first-load', "0")
                }
                
                } catch { }
            } );
            
            socket.on(
            'send',
            ( strMessage ) =>
            {
                try {
                strMessage = cryptico.decrypt(strMessage, server_decrypt).plaintext;
                try {
                var utime = strMessage.substr( 0, 2 );
                var userID = strMessage.substr( 0, 12 );
                var getMessage = strMessage.substr( 12 );
                //Get json file
                var ujson = JSON.parse(fs.readFileSync(dataUser + utime + '/' + userID + '.json', 'utf8'));
                var fUser = ujson.first;
                var roomID = ujson.id;
                var rtime = roomID.substr( 0, 2 );
                var rjson = JSON.parse(fs.readFileSync(dataRoom + rtime + '/' + roomID + '.json', 'utf8'));
                
                //Writing messages
                if (fUser == true) {
                    rjson.first = getMessage;
                }else{
                    rjson.second = getMessage;
                }
                const roomJson = JSON.stringify(rjson)
                fs.writeFileSync(dataRoom + rtime + '/' + roomID + '.json', roomJson)
                
                //Send to client
                socket.emit( 'send-success' )
                } catch {
                    socket.emit( 'send-error' )
                }
                } catch { socket.emit( 'send-error' ) }
                
            } );
            
            socket.on(
            'delete',
            ( strMessage ) =>
            {
                try {
                strMessage = cryptico.decrypt(strMessage, server_decrypt).plaintext;
                try {
                    //Checking Files
                    var utime = strMessage.substr( 0, 2 );
                    var ujson = JSON.parse(fs.readFileSync(dataUser + utime + '/' + strMessage + '.json', 'utf8'));
                    var roomID = ujson.id;
                    var rtime = ujson.id.substr( 0, 2 );
                    var rfr = dataRoom + rtime + '/' + roomID + '.json';
                    var rfu = dataUser + utime + '/' + strMessage + '.json';
                    
                    //Delete Files
                    fs.rmSync(rfr, { recursive: true, force: true });
                    fs.rmSync(rfu, { recursive: true, force: true });
                    
                    //Send to client
                    socket.emit( 'delete-success' )
                } catch {
                    socket.emit( 'delete-error' )
                }
                
                } catch { socket.emit( 'delete-error' ) }
            } );
            
            socket.on(
            'flag',
            ( strMessage ) =>
            {
                if (flag_enable == true) {
                try {
                strMessage = cryptico.decrypt(strMessage, server_decrypt).plaintext;
                    //Checking Files
                    var utime = strMessage.substr( 0, 2 );
                    var ujson = JSON.parse(fs.readFileSync(dataUser + utime + '/' + strMessage + '.json', 'utf8'));
                    var roomID = ujson.id;
                    var rtime = ujson.id.substr( 0, 2 );
                    var fUser = ujson.first;
                    var rjson = JSON.parse(fs.readFileSync(dataRoom + rtime + '/' + roomID +'.json', 'utf8'));
                    var msg = "";
                    
                    //Get a message
                    if (fUser == false) {
                        msg = rjson.first;
                    }else{
                        msg = rjson.second;
                    }
                    
                    //Get Time
                    var wt = new Date();
                    var time = wt.toFormat("HH24MISS");
                    var htime = wt.toFormat("HH");
                    var date = wt.toFormat("MM/DD/YYYY/HH:MM:SS");
                    var flagID = "";
                    
                    //Create flagID
                    var IDdetect = true;
                    while( IDdetect == true ) {
                        var f_result = "";
                        for (var i = 0; i < len; i++) {
                        f_result += str[Math.floor(Math.random() * strLen)];
                        }
                        if( fs.existsSync( dataFlag + htime + '/' + flagID + '.json' ) ){
                            IDdetect = true;
                        }else{
                            IDdetect = false;
                        }
                    }
                    var flagID = time + f_result;
                    
                    //Save flag
                    rjson.flag = true;
                    const roomJson = JSON.stringify(rjson)
                    fs.writeFileSync(dataRoom + rtime + '/' + roomID + '.json', roomJson)
                    
                    //Create flag json file
                    const flag = {
                        date: date,
                        userID: strMessage,
                        roomID: roomID,
                        message: msg
                    }
                    const flagJson = JSON.stringify(flag)
                    fs.writeFileSync(dataFlag + htime + '/' + flagID + '.json', flagJson)
                    
                    //Send to client
                    socket.emit( 'flag', flagID )
                    console.log('FLAGGED:', flagID)
                    
                } catch { socket.emit( 'flag-error' ) }
                }else{
                    socket.emit( 'flag-error' )
                }
            } );
                socket.emit( 'flag-enable', flag_enable )
            
            socket.on(
            'version',
            ( strMessage ) =>
            {
                    socket.emit( 'version', version ) 
            } );
            
            
            socket.on(
            'cryptload',
            ( strMessage ) =>
            {
                    socket.emit( 'cryptload', server_encrypt )
            } );
            
    } );
    
//Delete files in 12-hour cycles
//もっと他にもいい方法あると思うけど、眠かったからこれで許して。
cron.schedule('0 0 0 * * *',  () => { time = "12"; deleteData(); newCrypt(); });
cron.schedule('0 0 1 * * *',  () => { time = "13"; deleteData(); });
cron.schedule('0 0 2 * * *',  () => { time = "14"; deleteData(); });
cron.schedule('0 0 3 * * *',  () => { time = "15"; deleteData(); });
cron.schedule('0 0 4 * * *',  () => { time = "16"; deleteData(); });
cron.schedule('0 0 5 * * *',  () => { time = "17"; deleteData(); });
cron.schedule('0 0 6 * * *',  () => { time = "18"; deleteData(); });
cron.schedule('0 0 7 * * *',  () => { time = "19"; deleteData(); });
cron.schedule('0 0 8 * * *',  () => { time = "20"; deleteData(); });
cron.schedule('0 0 9 * * *',  () => { time = "21"; deleteData(); });
cron.schedule('0 0 10 * * *', () => { time = "22"; deleteData(); });
cron.schedule('0 0 11 * * *', () => { time = "23"; deleteData(); });
cron.schedule('0 0 12 * * *', () => { time = "00"; deleteData(); newCrypt(); });
cron.schedule('0 0 13 * * *', () => { time = "01"; deleteData(); });
cron.schedule('0 0 14 * * *', () => { time = "02"; deleteData(); });
cron.schedule('0 0 15 * * *', () => { time = "03"; deleteData(); });
cron.schedule('0 0 16 * * *', () => { time = "04"; deleteData(); });
cron.schedule('0 0 17 * * *', () => { time = "05"; deleteData(); });
cron.schedule('0 0 18 * * *', () => { time = "06"; deleteData(); });
cron.schedule('0 0 19 * * *', () => { time = "07"; deleteData(); });
cron.schedule('0 0 20 * * *', () => { time = "08"; deleteData(); });
cron.schedule('0 0 21 * * *', () => { time = "09"; deleteData(); });
cron.schedule('0 0 22 * * *', () => { time = "10"; deleteData(); });
cron.schedule('0 0 23 * * *', () => { time = "11"; deleteData(); });

function verCheck() {
var verjson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
version = verjson.version;
io.sockets.emit("version", version ) 
}

function newCrypt() {
try {
for (var i = 0; i < enc_len; i++) {
	enc_result += enc_str[Math.floor(Math.random() * enc_strLen)];
}

var cryptjson = JSON.parse(fs.readFileSync('./database/server.json', 'utf8'));

var private_key = cryptico.generateRSAKey(enc_result, enc_bits);
var public_key = cryptico.publicKeyString(private_key);
server_decrypt = private_key;
server_encrypt = public_key;

cryptjson.private = server_decrypt
cryptjson.public = server_encrypt

const newJson = JSON.stringify(cryptjson)
fs.writeFileSync('./database/server.json', newJson)
io.sockets.emit("cryptload", public_key)
console.log( 'NewCrypt: ' + public_key );
} catch { newCrypt(); }
}

function deleteData() {
    //Counter
    console.log( 'Counter: ' + counter );
    try {
        //Delete Files
        var rf = dataRoom + time;
        fs.rmSync(rf, { recursive: true, force: true });
        fs.mkdir(rf);
        rf = dataUser + time;
        fs.rmSync(rf, { recursive: true, force: true });
        fs.mkdir(rf);
        rf = dataFlag + time;
        fs.rmSync(rf, { recursive: true, force: true });
        fs.mkdir(rf);
        //Log
        console.log("Delete " + time);
    } catch {
        console.log("Delete err " + time);
    }
    try {
        var flag_enablejson = JSON.parse(fs.readFileSync('./database/server.json', 'utf8'));
        flag_enable = flag_enablejson.flag_enable;
    }catch{
        flag_enable = false;
    }
    io.socket.emit( 'flag-enable', flag_enable )
    console.log( 'Flag: ' + flag_enable );
}

//Server setup
app.use( express.static( __dirname + '/public' ) );

app.use( function( req, res, next ){
  res.status( 404 );
  res.render( '404', { path: req.path } );
});

server.listen(PORT,() => {
    verCheck();
    newCrypt();
    console.log( 'Server on port %d', PORT );
    console.log( ' Version: ' + version );
    console.log( ' Flag: ' + flag_enable );
} );
