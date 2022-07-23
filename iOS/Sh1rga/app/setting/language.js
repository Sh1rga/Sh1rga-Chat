var settingLangJson = "";
var language = "en";
function settinglangset() {
if (language == "ar") {
	document.getElementById('bdo').dir = "rtl";
	settingLangJson = {
	"back" : "خلف",
	"changeicon" : "تغيير الايقونة",
	"notification" : "إشعار",
	"notification_1" : "تلقي إشعار عند استلام رسائل جديدة.",
	"disableautosleep" : "تعطيل السكون التلقائي",
	"disableautosleep_1" : "تعطيل النوم التلقائي أثناء المحادثة.",
	"background" : "تمكين الخلفية",
	"background_1" : "العب الصمت حتى يمكن تلقي الإشعارات حتى في الخلفية لفترات طويلة من الزمن.",
	"background_2" : "ومع ذلك ، قد يستهلك المزيد من طاقة البطارية.",
	"muteword" : "كتم كلمة",
	"muteword_1" : "يكتم الكلمات المحددة.",
	"report" : "تقرير للمطور",
	"setting" : "الإعدادات"
	}
}else{
	document.getElementById('bdo').dir = "ltr";
	if (language == "en") {
		settingLangJson = {
	"back" : "Back",
	"changeicon" : "Change Icon",
	"notification" : "Notification",
	"notification_1" : "Receive notification when new messages are received.",
	"disableautosleep" : "Disable auto sleep",
	"disableautosleep_1" : "Disable auto sleep during conversation.",
	"background" : "Enable Background",
	"background_1" : "Play silence so that notifications can be received even in the background for long periods of time.",
	"background_2" : "However, it may consume more battery power.",
	"muteword" : "Mute Word",
	"muteword_1" : "Mutes the specified words.",
	"report" : "Report to developer",
	"setting" : "Settings"
		}
	}else if (language == "ja") {
		settingLangJson = {
	"back" : "戻る",
	"changeicon" : "アイコンを変更",
	"notification" : "通知",
	"notification_1" : "新しいメッセージを受信したときに通知を受け取ります。",
	"disableautosleep" : "自動スリープを無効化",
	"disableautosleep_1" : "自動スリープを無効にします。",
	"background" : "バックグラウンドを有効化",
	"background_1" : "無音を再生することにより、バックグラウンドでも長時間通知を受け取れます。",
	"background_2" : "ただし、バッテリーの消費が激しくなる可能性があります。",
	"muteword" : "ミュート",
	"muteword_1" : "指定された言葉をミュートします。",
	"report" : "開発者に報告",
	"setting" : "設定"
		}
	}else if (language == "ru") {
		settingLangJson = {
	"back" : "Назад",
	"changeicon" : "Значок изменения",
	"notification" : "Уведомление",
	"notification_1" : "Получение уведомлений о получении новых сообщений.",
	"disableautosleep" : "Отключить автоматический сон",
	"disableautosleep_1" : "Отключение автоматического перехода в спящий режим во время разговора.",
	"background" : "Включить фоновый режим",
	"background_1" : "Воспроизведение тишины, чтобы уведомления можно было получать даже в фоновом режиме в течение длительного времени.",
	"background_2" : "Однако это может потреблять больше энергии аккумулятора.",
	"muteword" : "Отключить звук слова",
	"muteword_1" : "Отключает звук указанных слов.",
	"report" : "Отчет разработчику",
	"setting" : "Настройка"
		}
	}else if (language == "cn") {
		settingLangJson = {
	"back" : "返回",
	"changeicon" : "改变图标",
	"notification" : "通知",
	"notification_1" : "当收到新邮件时接收通知。",
	"disableautosleep" : "禁用自动睡眠",
	"disableautosleep_1" : "在对话期间禁止自动睡眠。",
	"background" : "启用背景",
	"background_1" : "播放静音，这样即使长时间在后台也能收到通知。",
	"background_2" : "然而，它可能会消耗更多的电池电量。",
	"muteword" : "静音词",
	"muteword_1" : "使指定的单词静音。",
	"report" : "向开发商报告",
	"setting" : "设置"
		}
	}else if (language == "tw") {
		settingLangJson = {
	"back" : "後退",
	"changeicon" : "更改圖標",
	"notification" : "通知",
	"notification_1" : "收到新消息時收到通知。",
	"disableautosleep" : "禁用自動睡眠",
	"disableautosleep_1" : "在對話期間禁用自動睡眠。",
	"background" : "啟用背景",
	"background_1" : "播放靜音，這樣即使在後台很長一段時間也能收到通知。",
	"background_2" : "但是，它可能會消耗更多的電池電量。",
	"muteword" : "靜音詞",
	"muteword_1" : "靜音指定的單詞。",
	"report" : "向開發商報告",
	"setting" : "設定"
		}
	}else if (language == "es") {
		settingLangJson = {
	"back" : "Volver",
	"changeicon" : "Icono de cambio",
	"notification" : "Notificación",
	"notification_1" : "Recibir una notificación cuando se reciben nuevos mensajes.",
	"disableautosleep" : "Desactivar la suspensión automática",
	"disableautosleep_1" : "Desactivar la suspensión automática durante la conversación.",
	"background" : "Habilitar fondo",
	"background_1" : "Reproducir el silencio para poder recibir notificaciones incluso en segundo plano durante largos periodos de tiempo.",
	"background_2" : "Sin embargo, puede consumir más batería.",
	"muteword" : "Silenciar palabra",
	"muteword_1" : "Silencia las palabras especificadas.",
	"report" : "Informe al promotor",
	"setting" : "Ajustes"
		}
	}else if (language == "pt") {
		settingLangJson = {
	"back" : "Voltar",
	"changeicon" : "Mudar Ícone",
	"notification" : "Notificação",
	"notification_1" : "Receber notificação quando novas mensagens são recebidas.",
	"disableautosleep" : "Desactivar o sono automático",
	"disableautosleep_1" : "Desactivar o sono automático durante a conversa.",
	"background" : "Habilitar fundo",
	"background_1" : "Tocar o silêncio para que as notificações possam ser recebidas mesmo em segundo plano durante longos períodos de tempo.",
	"background_2" : "No entanto, pode consumir mais energia da bateria.",
	"muteword" : "Palavra mudo",
	"muteword_1" : "Muda as palavras especificadas.",
	"report" : "Relatório para o desenvolvedor",
	"setting" : "Ajustes"
		}
	}else if (language == "fr") {
		settingLangJson = {
	"back" : "Retour",
	"changeicon" : "Changer l'icône",
	"notification" : "Notification",
	"notification_1" : "Recevez une notification lorsque vous recevez de nouveaux messages.",
	"disableautosleep" : "Désactiver la veille automatique",
	"disableautosleep_1" : "Désactivez la mise en veille automatique pendant la conversation.",
	"background" : "Activer le fond",
	"background_1" : "Joue le silence afin que les notifications puissent être reçues même en arrière-plan pendant de longues périodes.",
	"background_2" : "Cependant, cela peut consommer davantage de batterie.",
	"muteword" : "Mot muet",
	"muteword_1" : "Met en sourdine les mots spécifiés.",
	"report" : "Rapport au développeur",
	"setting" : "Réglages"
		}
	}else if (language == "de") {
		settingLangJson = {
	"back" : "Zurück",
	"changeicon" : "Symbol ändern",
	"notification" : "Benachrichtigung",
	"notification_1" : "Erhalten Sie eine Benachrichtigung, wenn neue Nachrichten eingegangen sind.",
	"disableautosleep" : "Schlafautomatik deaktivieren",
	"disableautosleep_1" : "Deaktivieren Sie den automatischen Ruhezustand während eines Gesprächs.",
	"background" : "Hintergrund aktivieren",
	"background_1" : "Stille wiedergeben, damit Benachrichtigungen auch über längere Zeiträume im Hintergrund empfangen werden können.",
	"background_2" : "Dies kann jedoch mehr Akkuleistung verbrauchen.",
	"muteword" : "Wort stummschalten",
	"muteword_1" : "Schaltet die angegebenen Wörter stumm.",
	"report" : "Bericht an den Entwickler",
	"setting" : "Einstellungen"
		}
	}else if (language == "ko") {
		settingLangJson = {
	"back" : "뒤",
	"changeicon" : "아이콘 변경",
	"notification" : "공고",
	"notification_1" : "새 메시지가 수신되면 알림을 받습니다.",
	"disableautosleep" : "자동 절전 비활성화",
	"disableautosleep_1" : "대화 중 자동 절전을 비활성화합니다.",
	"background" : "배경 활성화",
	"background_1" : "백그라운드에서 오랜 시간 동안 알림을 받을 수 있도록 무음으로 재생합니다.",
	"background_2" : "그러나 더 많은 배터리 전력을 소모할 수 있습니다.",
	"muteword" : "음소거 단어",
	"muteword_1" : "지정된 단어를 음소거합니다.",
	"report" : "개발자에게 보고",
	"setting" : "설정"
		}
	}else if (language == "tok") {
		settingLangJson = {
	"back" : "monsi",
	"changeicon" : "ante e sitelen",
	"notification" : "sona sin",
	"notification_1" : "sina kama jo e sin toki la sina kama jo e sona sin.",
	"disableautosleep" : "pini e lape",
	"disableautosleep_1" : "pini e ilo li lape.",
	"background" : "ken e ilo ni li pali tenpo suli",
	"background_1" : "ilo ni li pali tenpo suli kepeken kalama musi.",
	"background_2" : "taso ilo wawa li ken wile moku.",
	"muteword" : "kalama ala",
	"muteword_1" : "kalama ala e toki.",
	"report" : "toki lon jan pali ni",
	"setting" : "ante e ken"
		}
	}
}
if (language == "cn") {
	document.getElementById('html').lang = "zh-CN";
}else if (language == "tw") {
	document.getElementById('html').lang = "zh-TW";
}else{
	document.getElementById('html').lang = language;
}
view();
}