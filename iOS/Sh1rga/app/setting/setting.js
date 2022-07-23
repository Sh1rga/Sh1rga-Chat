var appBox = document.getElementById('box');
window.onload = function(){
document.addEventListener('touchmove', (e) => { if (e.touches.length > 1) { e.preventDefault();}}, { passive: false });
document.addEventListener("dblclick", function(e){ e.preventDefault();}, { passive: false });
location.href = 'sh1rga://settingViewLoad';
}

function view(){
appBox.innerHTML = '<h1>' + settingLangJson.setting + '</h1><div class="setbox"><h3 style="margin:5px">' + settingLangJson.changeicon + '</h3><button onclick="location.href=\'sh1rga://setting/icon/0\'" class="nobox"><img src="./icon.png" style="width:64px;border-radius:16px" aria-label="Default"></button><button onclick="location.href=\'sh1rga://setting/icon/1\'" class="nobox"><img src="./appicon.png" style="width:64px;border-radius:16px" aria-label="Simple"></button><button onclick="location.href=\'sh1rga://setting/icon/2\'" class="nobox"><img src="./blackicon.png" style="width:64px;border-radius:16px" aria-label="Black"></button></div><h2 aria-label="Shirga Chat">Sh1rga Chat</h2><div class="setbox"><h3 style="margin:5px">' + settingLangJson.notification + '</h3><div style="padding:5px;color:#ccc">' + settingLangJson.notification_1 + '<br></div><button onclick="location.href=\'sh1rga://setting/notifi\'">' + settingLangJson.setting + '</button></div><br><div class="setbox"><h3 style="margin:5px">' + settingLangJson.disableautosleep + '</h3><div style="padding:5px;color:#ccc">' + settingLangJson.disableautosleep_1 + '<br></div><div id="setting-autoSleepDisable"><button>&nbsp; &nbsp; &nbsp;</button></div></div><br><div id="setting-altchange"></div><a href="mailto:sh1rga@tsg0o0.com">' + settingLangJson.report + '</a><br><br>';
location.href = 'sh1rga://settingViewLoad';
}
