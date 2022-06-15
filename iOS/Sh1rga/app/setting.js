var settingLangJson = "";

function settinglangset() {
$(function() {
  $.ajax({
    type: 'GET',
    url: 'https://chat.sh1r.ga/ios/lang/' + language + '.json',
    dataType: 'json'
  })
  .then(
    function (json) {
    	settingLangJson = json;
    },
    function () {
    	settinglangset();
    }
  );
});
}

function settingView() {
if (language == "ar") {
appBox.innerHTML = '<div style="text-align:right;margin-right:5px"><a href="javascript:startView();">' + settingLangJson.back + '</a></div><h2>' + langjson.setting + '</h2><div class="setbox"><h3 style="margin:5px">' + settingLangJson.changeicon + '</h3><a href="sh1rga://setting/icon/0" class="nobox"><img src="./icon.png" style="width:64px;border-radius:16px"></a><a href="sh1rga://setting/icon/1" class="nobox"><img src="./appicon.png" style="width:64px;border-radius:16px"></a><a href="sh1rga://setting/icon/2" class="nobox"><img src="./blackicon.png" style="width:64px;border-radius:16px"></a></div><br><div class="setbox"><h3 style="margin:5px">' + settingLangJson.notification + '</h3><div style="padding:5px;color:#ccc">' + settingLangJson.notification_1 + '<br></div><a href="sh1rga://setting/notifi">' + langjson.setting + '</a></div><br><div class="setbox"><h3 style="margin:5px">' + settingLangJson.disableautosleep + '</h3><div style="padding:5px;color:#ccc">' + settingLangJson.disableautosleep_1 + '<br></div><div id="setting-autoSleepDisable"><a>&nbsp; &nbsp; &nbsp;</a></div></div><br><div id="setting-altchange"></div><a href="mailto:support@sh1r.ga">' + settingLangJson.report + '</a><br><br>';
}else{
appBox.innerHTML = '<div style="text-align:left;margin-left:5px"><a href="javascript:startView();">' + settingLangJson.back + '</a></div><h2>' + langjson.setting + '</h2><div class="setbox"><h3 style="margin:5px">' + settingLangJson.changeicon + '</h3><a href="sh1rga://setting/icon/0" class="nobox"><img src="./icon.png" style="width:64px;border-radius:16px"></a><a href="sh1rga://setting/icon/1" class="nobox"><img src="./appicon.png" style="width:64px;border-radius:16px"></a><a href="sh1rga://setting/icon/2" class="nobox"><img src="./blackicon.png" style="width:64px;border-radius:16px"></a></div><br><div class="setbox"><h3 style="margin:5px">' + settingLangJson.notification + '</h3><div style="padding:5px;color:#ccc">' + settingLangJson.notification_1 + '<br></div><a href="sh1rga://setting/notifi">' + langjson.setting + '</a></div><br><div class="setbox"><h3 style="margin:5px">' + settingLangJson.disableautosleep + '</h3><div style="padding:5px;color:#ccc">' + settingLangJson.disableautosleep_1 + '<br></div><div id="setting-autoSleepDisable"><a>&nbsp; &nbsp; &nbsp;</a></div></div><br><div id="setting-altchange"></div><a href="mailto:support@sh1r.ga">' + settingLangJson.report + '</a><br><br>';
}
    location.href = 'sh1rga://settingViewLoad';
}
