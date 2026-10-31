import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    // ---------- 配色: ~/.config/colors/colors.css (Waybarと共通) から読み込む ----------
    property color pBackground: "#1e1e2e"
    property color pForeground: "#cdd6f4"
    property color pSelect: "#45475a"
    property color pPink: "#f5c2e7"
    property color pRed: "#f38ba8"
    property color pOrange: "#fab387"
    property color pYellow: "#f9e2af"
    property color pBlue: "#89b4fa"
    property color pPurple: "#cba6f7"
    property color pGreen: "#a6e3a1"

    readonly property color cBg: Qt.alpha(pBackground, 0.85)
    readonly property color cFg: pForeground
    readonly property color cDim: Qt.alpha(pForeground, 0.85)
    readonly property color cAccent: pPink
    readonly property color cHover: Qt.alpha(pSelect, 0.7)
    readonly property color cCard: Qt.alpha(pSelect, 0.55)
    readonly property color cBorder: pSelect
    readonly property color cCrit: pRed
    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    // GIFカードの高さ / 通知リストの最低の高さ
    readonly property int gifH: 150
    readonly property int minListH: 120

    // ---------- 状態 ----------
    property bool shown: false
    property double closedAt: 0

    // 開閉アニメーションの進行度 (0=閉, 1=開)
    property real prog: shown ? 1 : 0
    Behavior on prog {
        NumberAnimation {
            duration: root.shown ? 240 : 170
            easing.type: root.shown ? Easing.OutCubic : Easing.InCubic
        }
    }

    // アカウント
    readonly property string userName: Quickshell.env("USER") || "user"
    property string hostName: ""
    property url faceUrl: "file://" + Quickshell.env("HOME") + "/.face"

    // 天気
    property string wxText: "..."
    property string wxTemp: "-"
    property string wxKindNow: "cloudy"
    property var wxHours: []

    // クイック操作
    property bool dnd: false
    property bool hasBacklight: false
    property int brValue: 50
    property int brSent: 50
    property int volValue: 50
    property int volSent: 50

    // 通知
    property var arrivals: ({})
    property var popups: []
    property var history: buildHistory()

    function buildHistory() {
        var v = server.trackedNotifications.values;
        var out = [];
        for (var i = v.length - 1; i >= 0; i--)
            out.push(v[i]);
        return out;
    }

    // ---------- 操作 ----------
    function toggle() {
        if (shown) {
            shown = false;
            return;
        }
        // 外側クリックで閉じた直後(=ベルをクリックして閉じた直後)は再度開かない
        if (Date.now() - closedAt < 300)
            return;
        open();
    }

    function open() {
        popups = [];
        shown = true;
        colorProc.running = true;
        weatherProc.running = true;
        volGet.running = true;
        if (hasBacklight)
            brGet.running = true;

        // アイコン画像を読み直す
        var u = "file://" + Quickshell.env("HOME") + "/.face";
        faceUrl = "";
        faceUrl = u;
    }

    function setLevel(kind, frac) {
        var v = Math.round(Math.max(0, Math.min(1, frac)) * 100);
        if (kind === "bright") {
            brValue = Math.max(1, v);
            if (!brTimer.running)
                brTimer.start();
        } else {
            volValue = v;
            if (!volTimer.running)
                volTimer.start();
        }
    }

    function sendBr() {
        brSent = brValue;
        brSet.running = true;
    }

    function sendVol() {
        volSent = volValue;
        volSet.running = true;
    }

    function onIncoming(n) {
        var a = Object.assign({}, arrivals);
        a[n.id] = Date.now();
        arrivals = a;
        if (dnd && n.urgency !== NotificationUrgency.Critical)
            return;
        var p = popups.slice();
        p.push(n);
        if (p.length > 4)
            p.shift();
        popups = p;
    }

    function hidePopup(n) {
        var out = [];
        for (var i = 0; i < popups.length; i++) {
            if (popups[i] !== n)
                out.push(popups[i]);
        }
        popups = out;
    }

    // 通知の「default」アクション(多くのアプリで、アプリを開く動作)を実行する
    function activate(n) {
        for (var i = 0; i < n.actions.length; i++) {
            if (n.actions[i].identifier === "default") {
                n.actions[i].invoke();
                return;
            }
        }
    }

    function clearAll() {
        var v = server.trackedNotifications.values;
        var arr = [];
        for (var i = 0; i < v.length; i++)
            arr.push(v[i]);
        for (var j = 0; j < arr.length; j++)
            arr[j].dismiss();
    }

    function pad(n) {
        return (n < 10 ? "0" : "") + n;
    }

    function fmtTime(ms) {
        if (!ms)
            return "";
        var d = new Date(ms);
        return pad(d.getHours()) + ":" + pad(d.getMinutes());
    }

    // ---------- パース ----------
    function parseColors(t) {
        var re = /@define-color\s+([A-Za-z0-9_-]+)\s+(#[0-9a-fA-F]{6})\s*;/g;
        var c = {};
        var m;
        while ((m = re.exec(t)) !== null)
            c[m[1]] = m[2];
        if (c.background)
            pBackground = c.background;
        if (c.foreground)
            pForeground = c.foreground;
        if (c.select)
            pSelect = c.select;
        if (c.pink)
            pPink = c.pink;
        if (c.red)
            pRed = c.red;
        if (c.orange)
            pOrange = c.orange;
        if (c.yellow)
            pYellow = c.yellow;
        if (c.blue)
            pBlue = c.blue;
        if (c.purple)
            pPurple = c.purple;
        if (c.green)
            pGreen = c.green;
    }

    function wx(c) {
        if (c === 0)
            return "晴れ";
        if (c <= 2)
            return "晴れ時々曇り";
        if (c === 3)
            return "曇り";
        if (c === 45 || c === 48)
            return "霧";
        if (c >= 51 && c <= 57)
            return "霧雨";
        if (c >= 61 && c <= 67)
            return "雨";
        if (c >= 71 && c <= 77)
            return "雪";
        if (c >= 80 && c <= 82)
            return "にわか雨";
        if (c === 85 || c === 86)
            return "にわか雪";
        if (c >= 95)
            return "雷雨";
        return "-";
    }

    // 天気コード → アイコンの種類
    function wxKind(c) {
        if (c === 0)
            return "clear";
        if (c <= 2)
            return "partly";
        if (c === 3)
            return "cloudy";
        if (c === 45 || c === 48)
            return "fog";
        if (c >= 51 && c <= 67)
            return "rain";
        if (c >= 71 && c <= 77)
            return "snow";
        if (c >= 80 && c <= 82)
            return "rain";
        if (c === 85 || c === 86)
            return "snow";
        if (c >= 95)
            return "thunder";
        return "cloudy";
    }

    // 天気アイコンを図形で描く (48x48の座標系を s に拡大縮小する)
    function drawWx(ctx, kind, s) {
        ctx.reset();
        var u = s / 48;
        ctx.lineCap = "round";
        ctx.lineJoin = "round";

        function disc(x, y, r, col) {
            ctx.fillStyle = col;
            ctx.beginPath();
            ctx.arc(x * u, y * u, r * u, 0, Math.PI * 2);
            ctx.fill();
        }
        function line(x1, y1, x2, y2, w, col) {
            ctx.strokeStyle = col;
            ctx.lineWidth = w * u;
            ctx.beginPath();
            ctx.moveTo(x1 * u, y1 * u);
            ctx.lineTo(x2 * u, y2 * u);
            ctx.stroke();
        }
        function sun(cx, cy, r, ray0, ray1) {
            disc(cx, cy, r, pYellow);
            for (var i = 0; i < 8; i++) {
                var a = i * Math.PI / 4;
                line(cx + Math.cos(a) * ray0, cy + Math.sin(a) * ray0, cx + Math.cos(a) * ray1, cy + Math.sin(a) * ray1, 2.4, pYellow);
            }
        }
        function cloud(oy, col) {
            disc(16, oy + 28, 8, col);
            disc(26, oy + 22, 10, col);
            disc(35, oy + 29, 7, col);
            ctx.fillStyle = col;
            ctx.fillRect(16 * u, (oy + 26) * u, 19 * u, 10 * u);
        }

        var fg = pForeground;

        if (kind === "clear") {
            sun(24, 24, 9, 13, 19);
        } else if (kind === "partly") {
            sun(18, 17, 7, 10.5, 15);
            cloud(4, fg);
        } else if (kind === "fog") {
            cloud(-4, fg);
            line(10, 37, 38, 37, 3, Qt.alpha(fg, 0.7));
            line(14, 43, 42, 43, 3, Qt.alpha(fg, 0.7));
        } else if (kind === "rain") {
            cloud(-6, fg);
            line(15, 34, 12, 42, 2.6, pBlue);
            line(24, 34, 21, 42, 2.6, pBlue);
            line(33, 34, 30, 42, 2.6, pBlue);
        } else if (kind === "snow") {
            cloud(-6, fg);
            disc(16, 36, 2.4, fg);
            disc(25, 41, 2.4, fg);
            disc(34, 36, 2.4, fg);
        } else if (kind === "thunder") {
            cloud(-6, fg);
            ctx.fillStyle = pYellow;
            ctx.beginPath();
            ctx.moveTo(27 * u, 27 * u);
            ctx.lineTo(18 * u, 38 * u);
            ctx.lineTo(24 * u, 38 * u);
            ctx.lineTo(21 * u, 46 * u);
            ctx.lineTo(32 * u, 33 * u);
            ctx.lineTo(26 * u, 33 * u);
            ctx.lineTo(30 * u, 27 * u);
            ctx.closePath();
            ctx.fill();
        } else {
            cloud(4, fg);
        }
    }

    function parseWeather(t) {
        try {
            var j = JSON.parse(t);
            var h = new Date().getHours();
            wxText = wx(j.current.weather_code);
            wxTemp = String(Math.round(j.current.temperature_2m));
            wxKindNow = wxKind(j.current.weather_code);
            var arr = [];
            for (var i = 1; i <= 4; i++) {
                var k = h + i * 3;
                if (k < j.hourly.time.length) {
                    arr.push({
                        label: (k % 24) + "時",
                        temp: Math.round(j.hourly.temperature_2m[k]),
                        pop: j.hourly.precipitation_probability[k],
                        kind: wxKind(j.hourly.weather_code[k])
                    });
                }
            }
            wxHours = arr;
        } catch (e) {
            wxText = "取得失敗";
        }
    }

    // brightnessctl -m の出力: デバイス名,クラス,現在値,割合%,最大値
    function parseBr(t) {
        var f = t.trim().split(",");
        var p = parseInt(f[3]);
        if (!isNaN(p)) {
            brValue = p;
            brSent = p;
        }
    }

    function parseVol(t) {
        var m = /(\d+)%/.exec(t);
        if (m) {
            var p = Math.min(100, parseInt(m[1]));
            volValue = p;
            volSent = p;
        }
    }

    // ---------- 通知サーバー (swaync の代わり) ----------
    NotificationServer {
        id: server
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        persistenceSupported: true
        onNotification: n => {
            n.tracked = true;
            root.onIncoming(n);
        }
    }

    Connections {
        target: server.trackedNotifications
        function onValuesChanged() {
            root.history = root.buildHistory();
        }
    }

    // ---------- データ取得 ----------
    Process {
        id: colorProc
        running: true
        command: ["cat", Quickshell.env("HOME") + "/.config/colors/colors.css"]
        stdout: StdioCollector {
            onStreamFinished: root.parseColors(text)
        }
    }

    Process {
        id: hostProc
        running: true
        command: ["cat", "/etc/hostname"]
        stdout: StdioCollector {
            onStreamFinished: root.hostName = text.trim()
        }
    }

    // バックライトのあるマシン(=ノートPC)だけ、明るさバーを出す
    Process {
        id: blDetect
        running: true
        command: ["sh", "-c", "ls /sys/class/backlight 2>/dev/null | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: root.hasBacklight = text.trim() !== ""
        }
    }

    Process {
        id: weatherProc
        command: ["curl", "-s", "--max-time", "8", "https://api.open-meteo.com/v1/forecast?latitude=36.67&longitude=136.72" + "&current=temperature_2m,weather_code" + "&hourly=temperature_2m,precipitation_probability,weather_code" + "&timezone=Asia%2FTokyo&forecast_days=2"]
        stdout: StdioCollector {
            onStreamFinished: root.parseWeather(text)
        }
    }

    Process {
        id: brGet
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: root.parseBr(text)
        }
    }

    Process {
        id: brSet
        command: ["brightnessctl", "set", root.brSent + "%"]
        onExited: {
            if (root.brSent !== root.brValue)
                root.sendBr();
        }
    }

    Process {
        id: volGet
        command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: root.parseVol(text)
        }
    }

    Process {
        id: volSet
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", root.volSent + "%"]
        onExited: {
            if (root.volSent !== root.volValue)
                root.sendVol();
        }
    }

    // ドラッグ中に実行回数が増えすぎないよう、一定間隔でまとめて反映する
    Timer {
        id: brTimer
        interval: 70
        onTriggered: {
            if (!brSet.running)
                root.sendBr();
        }
    }

    Timer {
        id: volTimer
        interval: 70
        onTriggered: {
            if (!volSet.running)
                root.sendVol();
        }
    }

    // ---------- IPC: qs -c qs-notif ipc call notif toggle / close ----------
    IpcHandler {
        target: "notif"
        function toggle(): void {
            root.toggle();
        }
        function close(): void {
            root.shown = false;
        }
    }

    // ---------- ポップアップ (画面右上に出る通知) ----------
    PanelWindow {
        id: popWin
        visible: root.popups.length > 0 && !root.shown
        anchors.top: true
        anchors.right: true
        margins.top: 44
        margins.right: 8
        implicitWidth: 360
        implicitHeight: popCol.implicitHeight
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: popCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: 8

            Repeater {
                model: root.popups

                Rectangle {
                    id: toast
                    Layout.fillWidth: true
                    Layout.preferredHeight: toastCol.implicitHeight + 24
                    radius: 10
                    color: root.cBg
                    border.color: modelData.urgency === NotificationUrgency.Critical ? root.cCrit : root.cBorder
                    border.width: 1

                    // 一定時間で消える (緊急の通知はクリックするまで残す)
                    Timer {
                        running: modelData.urgency !== NotificationUrgency.Critical
                        interval: 5000
                        onTriggered: root.hidePopup(modelData)
                    }

                    Connections {
                        target: modelData
                        function onClosed(reason) {
                            root.hidePopup(modelData);
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.activate(modelData);
                            root.hidePopup(modelData);
                        }
                    }

                    ColumnLayout {
                        id: toastCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 12
                        spacing: 3

                        Text {
                            Layout.fillWidth: true
                            text: modelData.appName || "通知"
                            color: root.cDim
                            elide: Text.ElideRight
                            font.family: root.fontFamily
                            font.pixelSize: 11
                            font.bold: true
                        }
                        Text {
                            Layout.fillWidth: true
                            text: modelData.summary
                            color: root.cFg
                            elide: Text.ElideRight
                            font.family: root.fontFamily
                            font.pixelSize: 13
                            font.bold: true
                        }
                        Text {
                            Layout.fillWidth: true
                            visible: text !== ""
                            text: modelData.body
                            color: root.cDim
                            wrapMode: Text.WordWrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                            textFormat: Text.StyledText
                            font.family: root.fontFamily
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }
    }

    // ---------- 通知パネル (右端から出る。高さは中身に合わせて可変) ----------
    PanelWindow {
        id: panel
        visible: root.shown || root.prog > 0.001
        anchors.top: true
        anchors.right: true
        margins.top: 44
        margins.right: 8
        implicitWidth: 380
        implicitHeight: col.implicitHeight + 28
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        // 通知リスト以外の部分の高さと、リストに使える最大の高さ
        readonly property real fixedH: 96 + 132 + root.gifH + ctrlCol.implicitHeight + 24 + 26 + 50
        readonly property real screenH: panel.screen ? panel.screen.height : 1080
        readonly property real maxListH: Math.max(root.minListH, screenH - 44 - 8 - 28 - fixedH)

        HyprlandFocusGrab {
            windows: [panel]
            active: root.shown
            onCleared: {
                root.shown = false;
                root.closedAt = Date.now();
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: root.cBg
            border.color: root.cBorder
            border.width: 1

            transform: Translate {
                x: (1 - root.prog) * 400
            }
            opacity: Math.min(1, root.prog * 2)

            ColumnLayout {
                id: col
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 14
                spacing: 10

                // ===== アカウント =====
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 96
                    radius: 8
                    color: root.cCard

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 16

                        Item {
                            Layout.preferredWidth: 68
                            Layout.preferredHeight: 68
                            Layout.alignment: Qt.AlignVCenter

                            Image {
                                id: face
                                anchors.fill: parent
                                source: root.faceUrl
                                cache: false
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                visible: false
                            }

                            Rectangle {
                                id: faceMask
                                anchors.fill: parent
                                radius: width / 2
                                layer.enabled: true
                                visible: false
                            }

                            MultiEffect {
                                anchors.fill: parent
                                source: face
                                maskEnabled: true
                                maskSource: faceMask
                                visible: face.status === Image.Ready
                            }

                            // ~/.face がないときは、頭文字の丸を出す
                            Rectangle {
                                anchors.fill: parent
                                radius: width / 2
                                color: root.pPurple
                                visible: face.status !== Image.Ready

                                Text {
                                    anchors.centerIn: parent
                                    text: root.userName.charAt(0).toUpperCase()
                                    color: root.pBackground
                                    font.family: root.fontFamily
                                    font.pixelSize: 30
                                    font.bold: true
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 4

                            Text {
                                Layout.fillWidth: true
                                text: root.userName
                                color: root.cFg
                                elide: Text.ElideRight
                                font.family: root.fontFamily
                                font.pixelSize: 20
                                font.bold: true
                            }
                            Text {
                                Layout.fillWidth: true
                                text: root.hostName
                                color: root.cDim
                                elide: Text.ElideRight
                                font.family: root.fontFamily
                                font.pixelSize: 14
                            }
                        }
                    }
                }

                // ===== 天気 =====
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 132
                    radius: 8
                    color: root.cCard

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Canvas {
                                id: wxNow
                                Layout.preferredWidth: 44
                                Layout.preferredHeight: 44
                                property string kind: root.wxKindNow
                                onKindChanged: requestPaint()
                                onPaint: root.drawWx(getContext("2d"), kind, width)
                                Component.onCompleted: requestPaint()

                                Connections {
                                    target: root
                                    function onPForegroundChanged() {
                                        wxNow.requestPaint();
                                    }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Text {
                                    text: "津幡町"
                                    color: root.cDim
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                }
                                Text {
                                    text: root.wxText + "  " + root.wxTemp + "°"
                                    color: root.cFg
                                    font.family: root.fontFamily
                                    font.pixelSize: 18
                                    font.bold: true
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Repeater {
                                model: root.wxHours

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Canvas {
                                        id: wxH
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: 22
                                        Layout.preferredHeight: 22
                                        property string kind: modelData.kind
                                        onKindChanged: requestPaint()
                                        onPaint: root.drawWx(getContext("2d"), kind, width)
                                        Component.onCompleted: requestPaint()

                                        Connections {
                                            target: root
                                            function onPForegroundChanged() {
                                                wxH.requestPaint();
                                            }
                                        }
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.label
                                        color: root.cDim
                                        font.family: root.fontFamily
                                        font.pixelSize: 11
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.temp + "° / " + modelData.pop + "%"
                                        color: root.cDim
                                        font.family: root.fontFamily
                                        font.pixelSize: 11
                                    }
                                }
                            }
                        }
                    }
                }

                // ===== GIF =====
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.gifH
                    radius: 8
                    color: root.cCard

                    AnimatedImage {
                        id: gif
                        anchors.fill: parent
                        source: Qt.resolvedUrl("tgits.gif")
                        fillMode: Image.PreserveAspectCrop
                        playing: panel.visible
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            maskEnabled: true
                            maskSource: gifMask
                        }
                    }

                    Rectangle {
                        id: gifMask
                        anchors.fill: parent
                        radius: 8
                        layer.enabled: true
                        visible: false
                    }
                }

                // ===== クイック操作 (明るさ(ノートPCのみ) / 音量 / おやすみ) =====
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: ctrlCol.implicitHeight + 24
                    radius: 8
                    color: root.cCard

                    ColumnLayout {
                        id: ctrlCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 12
                        spacing: 10

                        Repeater {
                            model: root.hasBacklight ? [
                                {
                                    kind: "bright",
                                    label: "明るさ"
                                },
                                {
                                    kind: "vol",
                                    label: "音量"
                                }
                            ] : [
                                {
                                    kind: "vol",
                                    label: "音量"
                                }
                            ]

                            RowLayout {
                                id: row
                                Layout.fillWidth: true
                                spacing: 10
                                property real val: modelData.kind === "bright" ? root.brValue : root.volValue

                                Text {
                                    Layout.preferredWidth: 44
                                    text: modelData.label
                                    color: root.cDim
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                    font.bold: true
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 22

                                    Rectangle {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: Qt.alpha(root.pForeground, 0.25)

                                        Rectangle {
                                            height: parent.height
                                            radius: 3
                                            width: parent.width * row.val / 100
                                            color: root.pBlue
                                        }
                                    }

                                    Rectangle {
                                        width: 14
                                        height: 14
                                        radius: 7
                                        color: root.cFg
                                        anchors.verticalCenter: parent.verticalCenter
                                        x: (parent.width - width) * row.val / 100
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onPressed: mouse => root.setLevel(modelData.kind, mouse.x / width)
                                        onPositionChanged: mouse => root.setLevel(modelData.kind, mouse.x / width)
                                    }
                                }

                                Text {
                                    Layout.preferredWidth: 38
                                    horizontalAlignment: Text.AlignRight
                                    text: Math.round(row.val) + "%"
                                    color: root.cDim
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                }
                            }
                        }

                        // おやすみ (通知のポップアップを止める。通知はリストに溜まる)
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 34
                            radius: 8
                            color: root.dnd ? root.cAccent : (dndMa.containsMouse ? root.cHover : Qt.alpha(root.pForeground, 0.12))

                            Text {
                                anchors.centerIn: parent
                                text: "おやすみ  " + (root.dnd ? "ON" : "OFF")
                                color: root.dnd ? root.pBackground : root.cFg
                                font.family: root.fontFamily
                                font.pixelSize: 13
                                font.bold: true
                            }

                            MouseArea {
                                id: dndMa
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: root.dnd = !root.dnd
                            }
                        }
                    }
                }

                // ===== 通知ヘッダー =====
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 26

                    Text {
                        text: "通知"
                        color: root.cFg
                        font.family: root.fontFamily
                        font.pixelSize: 15
                        font.bold: true
                    }
                    Text {
                        visible: root.history.length > 0
                        text: root.history.length
                        color: root.cDim
                        font.family: root.fontFamily
                        font.pixelSize: 12
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: clearText.implicitWidth + 20
                        Layout.preferredHeight: 26
                        radius: 8
                        color: clearMa.containsMouse ? root.cHover : "transparent"
                        visible: root.history.length > 0

                        Text {
                            id: clearText
                            anchors.centerIn: parent
                            text: "すべて消去"
                            color: root.cFg
                            font.family: root.fontFamily
                            font.pixelSize: 12
                        }

                        MouseArea {
                            id: clearMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.clearAll()
                        }
                    }
                }

                // ===== 通知リスト (新しいものが上。件数に応じて高さが変わる) =====
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(root.minListH, Math.min(list.contentHeight, panel.maxListH))

                    ListView {
                        id: list
                        anchors.fill: parent
                        clip: true
                        spacing: 8
                        model: root.history

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: nCol.implicitHeight + 20
                            radius: 8
                            color: root.cCard

                            // 通知本体のクリック: アプリを開く
                            MouseArea {
                                anchors.fill: parent
                                onClicked: root.activate(modelData)
                            }

                            Rectangle {
                                visible: modelData.urgency === NotificationUrgency.Critical
                                width: 3
                                height: parent.height - 16
                                radius: 2
                                color: root.cCrit
                                anchors.left: parent.left
                                anchors.leftMargin: 4
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            ColumnLayout {
                                id: nCol
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 10
                                spacing: 3

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.appName || "通知"
                                        color: root.cDim
                                        elide: Text.ElideRight
                                        font.family: root.fontFamily
                                        font.pixelSize: 11
                                        font.bold: true
                                    }
                                    Text {
                                        text: root.fmtTime(root.arrivals[modelData.id])
                                        color: root.cDim
                                        font.family: root.fontFamily
                                        font.pixelSize: 11
                                    }

                                    // 個別に消す
                                    Rectangle {
                                        Layout.preferredWidth: 20
                                        Layout.preferredHeight: 20
                                        radius: 10
                                        color: xMa.containsMouse ? root.cHover : "transparent"

                                        Text {
                                            anchors.centerIn: parent
                                            text: "×"
                                            color: root.cFg
                                            font.family: root.fontFamily
                                            font.pixelSize: 14
                                        }

                                        MouseArea {
                                            id: xMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onClicked: modelData.dismiss()
                                        }
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.summary
                                    color: root.cFg
                                    elide: Text.ElideRight
                                    font.family: root.fontFamily
                                    font.pixelSize: 13
                                    font.bold: true
                                }

                                Text {
                                    Layout.fillWidth: true
                                    visible: text !== ""
                                    text: modelData.body
                                    color: root.cDim
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 3
                                    elide: Text.ElideRight
                                    textFormat: Text.StyledText
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: root.history.length === 0
                        text: "通知はありません"
                        color: root.cDim
                        font.family: root.fontFamily
                        font.pixelSize: 13
                    }
                }
            }
        }
    }
}
