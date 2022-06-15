var version = "0.2.0";
var socketTime = 0;
var socketConnect = false;
var server_encrypt = "";
var my_encrypt = "";
var my_decrypt = "";
var encrypt_key = "";
var roomID = 240000000000;
var userID = 240000000000;
var userID_crypt = "";
var join = false;
var reloadDelay = false;
var yjoin = false;
var deletePress = 0;
var inputText = "";
var getMess = "";
var getMessDec = "";
var cryptFlag = false;
var langFlag = false;
var verErrorFlag = false;
var langErrorFlag = false;
var serverErrorFlag = false;
var latestError = "";
var nowErrorView = "";
var errorCheckEnd = false;
var language = "en";
var defaultLang = (window.navigator.languages && window.navigator.languages[0]) ||
    			   window.navigator.language ||
    			   window.navigator.userLanguage ||
            	   window.navigator.browserLanguage;

var langjson = "";

function getParam(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

window.onload = function(){ location.href = "sh1rga://appSettingLoad";
	autoLangSet();
	socketTimeCounter();
	errorloop();
	$('#box').css('height',(window.innerHeight - 110) + 'px');
	document.addEventListener('touchmove', (e) => { if (e.touches.length > 1) { e.preventDefault();}}, { passive: false });
	document.addEventListener("dblclick", function(e){ e.preventDefault();}, { passive: false });
}
window.onresize = function () {
	$('#box').css('height',(window.innerHeight - 110) + 'px');
}
$(window).on('load orientationchange resize', function() {
    window.setTimeout("$('#box').css('height',(window.innerHeight - 130) + 'px');", 50);
});

function autoLangSet() {
  if (getParam('lang') == null) {
	const langlist = ['ja', 'ru', 'ar', 'es', 'pt', 'fr', 'de', 'ko'];
	const cnlanglist = ['zh-TW', 'zh-tw', 'zh-HK', 'zh-hk'];
	if (langlist.includes(defaultLang.substr( 0, 2 ))) {
		language = defaultLang.substr( 0, 2 );
	}else if (cnlanglist.includes(defaultLang.substr( 0, 5 ))) {
		language = "tw";
	}else if (defaultLang.substr( 0, 5 ) == "zh-CN" || defaultLang.substr( 0, 5 ) == "zh-cn") {
		language = "cn";
	}
  }else{
  	const langlist = ['en', 'ja', 'ru', 'cn', 'tw', 'ar', 'es', 'pt', 'fr', 'de', 'ko'];
  	language = getParam('lang');
  }
  langset();
}

function langset() {
$('#loadCurtain').css('visibility','unset');
$('#loadCurtain').css('opacity','100%');
$(function() { settinglangset();
  $.ajax({
    type: 'GET',
    url: address_client + '/lang/' + language + '.json',
    dataType: 'json'
  })
  .then(
    function (json) {
    	langjson = json;
    	if (language == "ar") {
			document.getElementById('bdo').dir = "rtl";
		}else{
			document.getElementById('bdo').dir = "ltr";
		}
		if (language == "cn") {
			document.getElementById('html').lang = "zh-CN";
		}else if (language == "tw") {
			document.getElementById('html').lang = "zh-TW";
		}else{
			document.getElementById('html').lang = language;
		}
    	langFlag = true;
    	langErrorFlag = false;
    	if (serverErrorFlag == false) {
  		  if (verErrorFlag == true && latestError == "ver") {
			document.getElementById('msg').innerHTML = '<div class="msg" id="msgbox">' + langjson.oldver1 + '<br>' + langjson.oldver2 + '</div>';
			nowErrorView = "ver";
  		  }else if (langErrorFlag == true && latestError == "lang") {
  			document.getElementById('msg').innerHTML = '<div class="msg" id="msgbox">Failed to retrieve language file.<br>Please try again.</div>';
  			nowErrorView = "lang";
  		  }
  		}
  		window.setTimeout("curtainFade();", 500);
    },
    function () {
    	langErrorFlag = true;
    	latestError = "lang";
    	langset();
    }
  );
});
}

function sleep(msec) {
   return new Promise(function(resolve) {
      setTimeout(function() {resolve()}, msec);
   })
}

async function curtainFade() {
var opacity = 100;
for ( var i = 0;  i < 51;  i++ ) {
	$('#loadCurtain').css('opacity',opacity + '%');
	opacity -= 2;
	await sleep(5);
}
$('#loadCurtain').css('visibility','hidden');
}

async function msgMove() {
var top = 0;
nowErrorView == ''
if (window.innerWidth <= 599) {
		top = 7;
	}else{
		top = 0;
	}
for ( var i = 0;  i < 201;  i++ ) {
  if (nowErrorView == '') {
	$('#msgbox').css('top',top + 'px');
	top -= 1;
	await sleep(2.5);
  }
}
if (nowErrorView == '') { document.getElementById('msg').innerHTML = ''; }
}

var connected = false;
const socket = io.connect( address_api );
socket.on('connect',() => {
	verChecker();
	socketConnect = true;
	sendCryptLoad();
    if (connected == false) {
    	connected = true;
    	langLoad();
    	loopVerCheck();
	}
});

socket.on('disconnect',() => {
	socketConnect = false;
	socketTime = 0;
	socketTimeCounter();
});

function socketTimeCounter() {
	if (socketConnect == false) {
		socketTime += 1;
		window.setTimeout("socketTimeCounter();", 1000);
		if (socketTime >= 30) {
			serverErrorFlag = true;
			latestError = "server";
			if (nowErrorView != "server3") {
				document.getElementById('msg').innerHTML = '<div class="msg" id="msgbox">' + langjson.notconnect30_1 + '<br>' + langjson.notconnect30_2 + '</div>';
			}
			nowErrorView = "server3";
		}else if (socketTime >= 10) {
			serverErrorFlag = true;
			latestError = "server";
			if (nowErrorView != "server2") {
				document.getElementById('msg').innerHTML = '<div class="msg" id="msgbox">' + langjson.notconnect10_1 + '<br>' + langjson.notconnect_re + '</div>'
			}
			nowErrorView = "server2";
		}else{
			if (socketConnect == true) {
				serverErrorFlag = true;
				latestError = "server";
				if (nowErrorView != "server") {
					document.getElementById('msg').innerHTML = '<div class="msg" id="msgbox">' + langjson.notconnect_1 + '<br>' + langjson.notconnect_re + '</div>';
				}
				nowErrorView = "server";
			}
		}
	}else{
		serverErrorFlag = false;
		socketTime = 0;
	}
}

function langLoad() {
if (langFlag == false) {
	window.setTimeout("langLoad();", 100);
}else{
	errorCheckEnd = true;
	startView();
	if (langErrorFlag == false && verErrorFlag == false && errorCheckEnd == true) {
  		document.getElementById('msg').innerHTML = '<div class="goodmsg" id="msgbox">' + langjson.loadingviewsuc + '</div>';
  		nowErrorView = "";
  		window.setTimeout("if (nowErrorView == '') { msgMove(); }", 2000);
	}
}
}

var enc_bits = 2048;
var enc_len = 16;
var enc_str = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var enc_strLen = enc_str.length;
var enc_result = "";
var ThisIsStart = false;
var appBox = document.getElementById('box');

function verChecker() { location.href = "sh1rga://appSettingLoad";
	socket.emit( 'version' );
}

function startView() {
	appBox.innerHTML = '<h2>' + langjson.startroom + '</h2><a href="javascript:sendStart();">' + langjson.start + '</a><p /><h2>' + langjson.joinroom + '</h2><form action=""><input type="number" id="input" autocomplete="off" required maxlength="12" alt="' + langjson.entertheroomid + '" enterkeyhint="done" pattern="^[0-9]+$"><button type="submit" onClick="Button();return false;">' + langjson.join + '</button></form><br><p><a href="javascript:settingView();">' + langjson.setting + '</a></p><p>Ver: ' + version + '</p><p><a class="nobox" href="' + address_web + '/tos?lang=' + language + '">' + langjson.tos + '</a></p>';
}

function langSelectView() {
	appBox.innerHTML = '<div style="text-align:left;margin-left:5px"><a href="javascript:startView();">Back</a></div><h2 style="margin-top:-10px">Language</h2><p><select name="language" id="lang" size="12"><option value="en" selected>English</option><option value="ja">日本語</option><option value="ru">Русский</option><option value="cn">简体中文</option><option value="tw">繁體中文</option><option value="ar">عربي</option><option value="es">Español</option><option value="pt">Português</option><option value="fr">Français</option><option value="de">Deutsch</option><option value="ko">한국어</option></select></p><p><a href="javascript:langSelect();">OK</a></p>';
	if (language == "ja"){
	document.getElementById('lang').options[1].selected = true;
	}else if (language == "ru"){
	document.getElementById('lang').options[2].selected = true;
	}else if (language == "cn"){
	document.getElementById('lang').options[3].selected = true;
	}else if (language == "tw"){
	document.getElementById('lang').options[4].selected = true;
	}else if (language == "ar"){
	document.getElementById('lang').options[5].selected = true;
	}else if (language == "es"){
	document.getElementById('lang').options[6].selected = true;
	}else if (language == "pt"){
	document.getElementById('lang').options[7].selected = true;
	}else if (language == "fr"){
	document.getElementById('lang').options[8].selected = true;
	}else if (language == "de"){
	document.getElementById('lang').options[9].selected = true;
	}else if (language == "ko"){
	document.getElementById('lang').options[10].selected = true;
	}
}

function langSelect() {
	language = document.getElementById('lang').value;
	langFlag = false;
	langset();
	langLoad()
	history.replaceState('','','?lang=' + language);
}

function loopfunc() {
	if (join == true) {
		socket.emit( 'load', userID_crypt );
		window.setTimeout("loopfunc();", 3000);
	}
}

function loopVerCheck() {
verChecker();
window.setTimeout("loopVerCheck();", 600000);
}

function loadingView() {
	appBox.innerHTML = '<p><strong>' + langjson.nowloading + '</strong><br>' + langjson.loadingview1 + '<br>' + langjson.loadingview2 + '</p><br><p style="font-size:90%">' + langjson.loadingview3 + '<br><a href="javascript:preCryptRetry();">' + langjson.retry + '</a><br>' + langjson.loadingview4 + '</p>';
}

function preCrypt() {
	cryptFlag = true;
	for (var i = 0; i < enc_len; i++) {
		enc_result += enc_str[Math.floor(Math.random() * enc_strLen)];
	}
	my_decrypt = cryptico.generateRSAKey(enc_result, enc_bits);
	my_encrypt = cryptico.publicKeyString(my_decrypt);
	if (ThisIsStart == true) {
		cryptFlag = false;
		socket.emit( 'start', my_encrypt );
	}else{
		cryptFlag = false;
		$( '#input' ).val( '' ); 
		appBox.innerHTML = '<p><strong>' + langjson.loadingviewsuc + '</strong></p><p style="padding:0 10px;margin:5px 0 0;color:#ccc">' + langjson.roomid + ': ' + roomID + '</p><p><a href="javascript:joinCryptSuc();">' + langjson.join + '</a></p>';
	}
}

function joinCryptSuc() {
	var msgcrypt = cryptico.encrypt(roomID + my_encrypt, server_encrypt);
	socket.emit( 'join', msgcrypt.cipher );
}

function preCryptRetry() {
	if (cryptFlag == true) {
		appBox.innerHTML = '<p><strong>' + langjson.nowloading + '</strong><br>' + langjson.loadingview1 + '<br>' + langjson.loadingview2 + '</p><br><p style="font-size:90%">' + langjson.loadingview3 + '<br><a href="javascript:preCryptRetry();">' + langjson.retry + '</a><br>' + langjson.retrysuccess + '</p>';
		window.setTimeout("preCrypt();", 1000);
	}else{
		appBox.innerHTML = '<p><strong>' + langjson.nowloading + '</strong><br>' + langjson.loadingview1 + '<br>' + langjson.loadingview2 + '</p><br><p style="font-size:90%">' + langjson.loadingview3 + '<br><a href="javascript:preCryptRetry();">' + langjson.retry + '</a><br>' + langjson.retryfail + '</p>';
	}
}

function sendStart() {
	ThisIsStart = true;
	loadingView();
	window.setTimeout('preCrypt();',100);
}

function sendJoin() {
	roomID = $( '#input' ).val();
	ThisIsStart = false;
	loadingView();
	window.setTimeout('preCrypt();',100);
}

function sendLoad() {
	if (reloadDelay == false) {
		reloadDelay = true;
		window.setTimeout('reloadDelay = false;',1000);
		socket.emit( 'load', userID_crypt );
	}
	if (deletePress != 0) {
		document.getElementById('status').innerHTML = '';
	}
	deletePress = 0;
}

function sendFirstLoad() {
	if (yjoin == false && join == true) {
		socket.emit( 'first-load', userID_crypt );
		window.setTimeout("sendFirstLoad();", 3000);
	}
}

function sendSend() {
	if ($( '#input' ).val().length != 0) {
		inputText = cryptico.encrypt(string_to_utf8_hex_string($( '#input' ).val()), encrypt_key);
		var msgcrypt = cryptico.encrypt(userID + inputText.cipher, server_encrypt);
		socket.emit( 'send', msgcrypt.cipher );
		document.getElementById('status').innerHTML = langjson.sending;
	}
	deletePress = 0;
}

function sendDelete() {
	deletePress += 1;
	if (deletePress == 2) {
		join = false; location.href = "sh1rga://flag/join/false";
		deletePress = 0;
		socket.emit( 'delete', userID_crypt );
		appBox.innerHTML = '<p>' + langjson.deleting + '</p>';
	}else{
		document.getElementById('status').innerHTML = langjson.deletecheck;
	}
}

function sendCryptLoad() {
	socket.emit( 'cryptload' );
}

function viewChat() { location.href = "sh1rga://appSettingLoad";
	if (language == "ar") {
	appBox.innerHTML = '<p style="padding:0 10px;margin:5px 0 0;text-align:right;color:#ccc">' + langjson.roomid + ': ' + roomID + flaghtml + '</p><textarea readonly id="get-message-area" alt="' + langjson.receivemess + '" style="background-color:#033;border-radius:20px 0 20px 20px;transform:translateX(20px)"></textarea><br><form action=""><textarea id="input" placeholder="' + langjson.entermess + '" alt="' + langjson.entermess + '" required style="background-color:#023;border-radius:20px 20px 20px 0;transform:translateX(-20px)"></textarea><br><a href="javascript:Button();">' + langjson.send + '</a>&nbsp;<a href="javascript:sendLoad();">' + langjson.reload + '</a>&nbsp;<a href="javascript:sendDelete();">' + langjson.delete + '</a></form><div id="status"></div>';
	}else{
	appBox.innerHTML = '<p style="padding:0 10px;margin:5px 0 0;text-align:left;color:#ccc">' + langjson.roomid + ': ' + roomID + flaghtml + '</p><textarea readonly id="get-message-area" alt="' + langjson.receivemess + '" style="background-color:#033;border-radius:0 20px 20px 20px;transform:translateX(-20px)"></textarea><br><form action=""><textarea id="input" placeholder="' + langjson.entermess + '" alt="' + langjson.entermess + '" required style="background-color:#023;border-radius:20px 20px 0 20px;transform:translateX(20px)"></textarea><br><a href="javascript:Button();">' + langjson.send + '</a>&nbsp;<a href="javascript:sendLoad();">' + langjson.reload + '</a>&nbsp;<a href="javascript:sendDelete();">' + langjson.delete + '</a></form><div id="status"></div>';
	}
}

socket.on('version', strMessage => {
	if (strMessage != version) {
		verErrorFlag = true;
    	latestError = "ver";
	}
})

function errorloop() {
  if (serverErrorFlag == false) {
  	if (verErrorFlag == true && latestError == "ver" && nowErrorView != "ver") {
		document.getElementById('msg').innerHTML = '<div class="msg" id="msgbox">' + langjson.oldver1 + '<br>' + langjson.oldver2 + '</div>';
		nowErrorView = "ver";
  	}else if (langErrorFlag == true && latestError == "lang" && nowErrorView != "lang") {
  		document.getElementById('msg').innerHTML = '<div class="msg" id="msgbox">Failed to retrieve language file.<br>Please try again.</div>';
  		nowErrorView = "lang";
  	}
  	if (errorCheckEnd == false) {
  		document.getElementById('msg').innerHTML = '<div class="goodmsg" id="msgbox">Loading...</div>';
  	}
  }
  window.setTimeout("errorloop();", 500);
}

socket.on('get-roomid', strMessage => {
	strMessage = cryptico.decrypt(strMessage, my_decrypt).plaintext;
	roomID = strMessage;
	appBox.innerHTML = '<p><strong>' + langjson.waitjoin1 + '</strong><br><br><div style="font-size:150%">' + langjson.waitjoin2 + '</div><div style="font-size:150%"><strong style="-webkit-user-select:auto;user-select:auto;-webkit-touch-callout:auto;-webkit-user-drag:auto">' + roomID + '</strong></div><br><a href="javascript:sendFirstReload();">' + langjson.reload + '</a>&nbsp;<a href="javascript:sendDeleteForce();">' + langjson.cancel + '</a></p>';
	sendFirstLoad();
})

function sendFirstReload() {
	verChecker();
	socket.emit( 'first-load', userID_crypt );
}

socket.on('get-userid', strMessage => {
	strMessage = cryptico.decrypt(strMessage, my_decrypt).plaintext;
	userID = strMessage;
	userID_crypt = cryptico.encrypt(userID, server_encrypt).cipher;
})

socket.on('start', strMessage => {
	join = true; location.href = "sh1rga://flag/join/true";
	appBox.innerHTML = '<p><strong>' + langjson.waitjoin1 + '</strong><br><br><div style="font-size:150%">' + langjson.waitjoin2 + '</div><div style="font-size:150%"><strong>' + langjson.nowloading + '</strong></div></p>';
})

socket.on('join', strMessage => {
	join = true; location.href = "sh1rga://flag/join/true";
	encrypt_key = strMessage;
	viewChat();
	loopfunc();
})

socket.on('first-load', strMessage => {
	if (strMessage.substr( 0, 1 ) == "1") { location.href = "sh1rga://notifi/joinUser";
		yjoin = true;
		encrypt_key = strMessage.substr( 1 );
		viewChat();
		loopfunc();
	}
})

socket.on('load', strMessage => {
	if (getMess != strMessage) {
		getMess = strMessage;
		if (getMess.length != 0) { location.href = "sh1rga://notifi/getNewMessage";
			getMessDec = cryptico.decrypt(getMess, my_decrypt).plaintext;
			getMessDec = utf8_hex_string_to_string(getMessDec);	if (enableMuteWord == true) {getMessDec = getMessDec.split(muteWord).join('[MUTE]');} 
			$('#get-message-area').val(getMessDec);
		}
	}
})

socket.on('cryptload', strMessage => {
	if (server_encrypt != strMessage) {
		server_encrypt = strMessage;
		if (join == true) {
			userID_crypt = cryptico.encrypt(userID, server_encrypt);
		}
	}
})

//success
socket.on('send-success', strMessage => {
	document.getElementById('status').innerHTML = '' + langjson.sent + '';
	window.setTimeout("document.getElementById('status').innerHTML = '';", 5000);
})

socket.on('delete-success', strMessage => {
	appBox.innerHTML = '<p>' + langjson.deleted + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a>';
})

//error
socket.on('version-error', strMessage => {
	window.setTimeout("verChecker();", 5000);
})

socket.on('start-error', strMessage => {
	appBox.innerHTML = '<p>' + langjson.starterror1 + '<br>' + langjson.starterror2 + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a>';
})

socket.on('join-error', strMessage => {
	appBox.innerHTML = '<p>' + langjson.joinerror + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a>';
})

socket.on('join-notfound', strMessage => {
	join = false; location.href = "sh1rga://flag/join/false";
	appBox.innerHTML = '<p>' + langjson.joinrnf + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a>';
})

socket.on('joined', strMessage => {
	appBox.innerHTML = '<p>' + langjson.joined1 + '<br>' + langjson.joined2 + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a>';
})

socket.on('load-error', strMessage => {
	document.getElementById('status').innerHTML = '' + langjson.reloadfail + '';
})

socket.on('send-error', strMessage => {
	document.getElementById('status').innerHTML = '' + langjson.sendfail + '';
})

socket.on('delete-error', strMessage => {
	appBox.innerHTML = '<p>' + langjson.deletefail + '</p><br><a href="javascript:sendDeleteForce();">' + langjson.retry + '</a>&nbsp;<a href="javascript:Disconnect();">' + langjson.ok + '</a>';
})

function sendDeleteForce() {
	join = false; location.href = "sh1rga://flag/join/false";
	socket.emit( 'delete', userID_crypt );
}

socket.on('roomNotFound', strMessage => {
	join = false; location.href = "sh1rga://flag/join/false";
	appBox.innerHTML = '<p>' + langjson.roomnotfound1 + '<br>' + langjson.roomnotfound2 + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a>';
})

socket.on('serverIsDown', strMessage => {
	eraser();
	appBox.innerHTML = '' + langjson.serverdown1 + '<br>' + langjson.serverdown2 + '<br>' + strMessage;
})

socket.on('roomFlagged', strMessage => {
	join = false; location.href = "sh1rga://flag/join/false";
	appBox.innerHTML = '<p>' + langjson.roomflagged1 + '<br>' + langjson.roomflagged2 + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a>';
})

function Disconnect() {
	if (join == true) {
		sendDeleteForce();
	}else{
		verChecker();
		eraser();
		startView();
	}
}

function eraser() {
	my_encrypt = "";
	my_decrypt = "";
	encrypt_key = "";
	roomID = 240000000000;
	userID = 240000000000;
	userID_crypt = "";
	join = false; location.href = "sh1rga://flag/join/false";
	yjoin = false;
	deletePress = 0;
	inputText = "";
	getMess = "";
	getMessDec = "";
	ThisIsStart = false;
	exporting = false;
	exportPass = "";
	exported = "";
}

function Button() {
	if (join == false) {
		if ($( '#input' ).val().length == 12) {
			sendJoin();
			$( '#input' ).val( '' );
		}
	}else{
		if ($( '#input' ).val().length != 0) {
			sendSend();
		}
	}
}

window.onbeforeunload = function(e) {if (join == true) {return "";}}
window.document.onkeydown = function(evt){if (evt.which == 123){ evt.which = null;return false;}}

var muteWord = "";
var enableMuteWord = false;

var flaghtml = "";
function sendFlag() {
join = false; location.href = "sh1rga://flag/join/false";
appBox.innerHTML = '<p>' + langjson.nowloading + '</p>'
socket.emit( 'flag', userID_crypt );
}
socket.on('flag', strMessage => {
	appBox.innerHTML = '<p>FlagID: ' + strMessage + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a><p><a href="mailto:support@sh1r.ga">' + settingLangJson.report + '</a></p>';
})
socket.on('flag-error', strMessage => {
	appBox.innerHTML = '<p>' + langjson.reloadfail + '</p><br><a href="javascript:Disconnect();">' + langjson.ok + '</a> <a href="javascript:sendFlag();">' + langjson.retry + '</a>';
})
socket.on('flag-enable', strMessage => {
	if (strMessage == true) {
		flaghtml = ' <a class="nobox" href="javascript:sendFlag();">Flag</a>';
	}
})
