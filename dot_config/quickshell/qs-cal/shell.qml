import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Mpris

ShellRoot {
    id: root

    // ---------- 配色: ~/.config/colors/colors.css (Waybarと共通) から読み込む ----------
    // 読み込めなかった色は、下の初期値のまま使う
    property color pBackground: "#1e1e2e"
    property color pForeground: "#cdd6f4"
    property color pSelect: "#45475a"
    property color pPink: "#f5c2e7"
    property color pRed: "#f38ba8"
    property color pOrange: "#fab387"
    property color pBlue: "#89b4fa"
    property color pPurple: "#cba6f7"
    property color pGreen: "#a6e3a1"

    // Waybarの指定をベースに、パネル上で読みやすいよう不透明度を上げた派生色
    readonly property color cBg: Qt.alpha(pBackground, 0.85)
    readonly property color cFg: pForeground
    readonly property color cDim: Qt.alpha(pForeground, 0.85)
    readonly property color cAccent: pPink
    readonly property color cHover: Qt.alpha(pSelect, 0.7)
    readonly property color cCard: Qt.alpha(pSelect, 0.55)
    readonly property color cBorder: pSelect
    readonly property color cWarn: pOrange
    readonly property color cCrit: pRed
    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    // 写真カードとステータス行の共通の高さ
    readonly property int bottomH: 112

    // ---------- 状態 ----------
    property bool shown: false
    property double closedAt: 0

    // 開閉アニメーションの進行度 (0=閉, 1=開)
    property real prog: shown ? 1 : 0
    Behavior on prog {
        NumberAnimation {
            duration: root.shown ? 280 : 160
            easing.type: root.shown ? Easing.OutBack : Easing.InCubic
            easing.overshoot: 1.5
        }
    }

    property date today: new Date()
    property date selected: new Date()
    property int viewYear: today.getFullYear()
    property int viewMonth: today.getMonth()
    readonly property int firstOffset: (new Date(viewYear, viewMonth, 1).getDay() + 6) % 7
    readonly property int daysInMonth: new Date(viewYear, viewMonth + 1, 0).getDate()

    property var events: []

    property int cpuTemp: -1
    property int memPct: 0
    property string memText: "-"
    property int diskPct: 0
    property string diskText: "-"

    // メディア: 再生中のプレイヤーを優先し、なければ最初のプレイヤーを使う
    property var player: pickPlayer()
    readonly property real progress: (player !== null && player.length > 0)
        ? Math.min(1, Math.max(0, player.position / player.length)) : 0

    readonly property var dow: ["月", "火", "水", "木", "金", "土", "日"]
    readonly property var dowFull: ["日", "月", "火", "水", "木", "金", "土"]

    // ゲージ3つの表示内容
    readonly property var gauges: [
        {
            label: "CPU温度",
            ring: cpuTemp < 0 ? 0 : Math.min(cpuTemp, 100),
            main: cpuTemp < 0 ? "-" : cpuTemp + "°",
            sub: "",
            col: level(cpuTemp, 60, 80, pBlue)
        },
        {
            label: "メモリ",
            ring: memPct,
            main: memPct + "%",
            sub: memText,
            col: level(memPct, 70, 90, pPurple)
        },
        {
            label: "ストレージ",
            ring: diskPct,
            main: diskPct + "%",
            sub: diskText,
            col: level(diskPct, 70, 90, pGreen)
        }
    ]

    function level(v, warn, crit, base) {
        if (v >= crit)
            return cCrit;
        if (v >= warn)
            return cWarn;
        return base;
    }

    function pickPlayer() {
        var ps = Mpris.players.values;
        for (var i = 0; i < ps.length; i++) {
            if (ps[i].isPlaying)
                return ps[i];
        }
        return ps.length > 0 ? ps[0] : null;
    }

    function fmt(sec) {
        if (!(sec >= 0))
            return "--:--";
        var s = Math.floor(sec);
        var m = Math.floor(s / 60);
        s = s % 60;
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
    }

    // ---------- 操作 ----------
    function toggle() {
        if (shown) {
            shown = false;
            return;
        }
        // 外側クリックで閉じた直後(=時計クリックで閉じた直後)は再度開かない
        if (Date.now() - closedAt < 300)
            return;
        open();
    }

    function open() {
        today = new Date();
        selected = today;
        viewYear = today.getFullYear();
        viewMonth = today.getMonth();
        shown = true;
        colorProc.running = true;
        refreshEvents();
        statusProc.running = true;
        if (player !== null)
            player.positionChanged();
    }

    function shiftMonth(d) {
        var m = viewMonth + d;
        var y = viewYear;
        if (m < 0) { m = 11; y -= 1; }
        if (m > 11) { m = 0; y += 1; }
        viewMonth = m;
        viewYear = y;
    }

    function selectDay(d) {
        selected = new Date(viewYear, viewMonth, d);
        refreshEvents();
    }

    function refreshEvents() {
        if (!evProc.running)
            evProc.running = true;
    }

    // ---------- パース ----------
    // colors.css の「@define-color 名前 #RRGGBB;」を読む
    function parseColors(t) {
        var re = /@define-color\s+([A-Za-z0-9_-]+)\s+(#[0-9a-fA-F]{6})\s*;/g;
        var c = {};
        var m;
        while ((m = re.exec(t)) !== null)
            c[m[1]] = m[2];
        if (c.background) pBackground = c.background;
        if (c.foreground) pForeground = c.foreground;
        if (c.select) pSelect = c.select;
        if (c.pink) pPink = c.pink;
        if (c.red) pRed = c.red;
        if (c.orange) pOrange = c.orange;
        if (c.blue) pBlue = c.blue;
        if (c.purple) pPurple = c.purple;
        if (c.green) pGreen = c.green;
    }

    function parseEvents(t) {
        var out = [];
        var lines = t.split("\n");
        for (var i = 0; i < lines.length; i++) {
            var l = lines[i];
            if (l.trim() === "")
                continue;
            var p = l.split("\t");
            var time = p[0].trim() === "" ? "終日" : p[0].trim();
            out.push({ time: time, title: p.length > 1 ? p[1] : p[0] });
        }
        events = out;
    }

    // 1行目: CPU温度 / 2行目: メモリ(使用率 使用GiB 合計GiB) / 3行目: ストレージ(使用率 使用GiB 合計GiB)
    function parseStatus(t) {
        var l = t.split("\n");
        var tv = parseInt(l[0]);
        cpuTemp = isNaN(tv) ? -1 : tv;

        var m = (l[1] || "").trim().split(/\s+/);
        memPct = parseInt(m[0]) || 0;
        memText = (m[1] || "-") + "GiB / " + (m[2] || "-") + "GiB";

        var d = (l[2] || "").trim().split(/\s+/);
        diskPct = parseInt(d[0]) || 0;
        diskText = (d[1] || "-") + "GiB / " + (d[2] || "-") + "GiB";
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
        id: evProc
        command: ["khal", "list", "--day-format", "", "--format", "{start-time}\t{title}",
                  Qt.formatDate(root.selected, "yyyy/MM/dd"), "1d"]
        stdout: StdioCollector {
            onStreamFinished: root.parseEvents(text)
        }
    }

    Process {
        id: statusProc
        command: ["sh", "-c",
            "t=''; for h in /sys/class/hwmon/hwmon*; do n=$(cat $h/name); "
            + "if [ \"$n\" = k10temp ] || [ \"$n\" = coretemp ]; then "
            + "t=$(( $(cat $h/temp1_input) / 1000 )); break; fi; done; echo \"$t\"; "
            + "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%d %.1f %.1f\\n\", "
            + "(t-a)*100/t, (t-a)/1048576, t/1048576}' /proc/meminfo; "
            + "df -B1 --output=pcent,used,size / | awk 'NR==2{printf \"%d %.0f %.0f\\n\", "
            + "$1, $2/1073741824, $3/1073741824}'"]
        stdout: StdioCollector {
            onStreamFinished: root.parseStatus(text)
        }
    }

    // 再生位置は自動では更新されないので、再生中は定期的に更新を通知する
    Timer {
        interval: 500
        repeat: true
        running: root.shown && root.player !== null && root.player.isPlaying
        onTriggered: root.player.positionChanged()
    }

    // ---------- IPC: qs -c qs-cal ipc call cal toggle ----------
    IpcHandler {
        target: "cal"
        function toggle(): void {
            root.toggle();
        }
        function close(): void {
            root.shown = false;
        }
    }

    // ---------- パネル ----------
    PanelWindow {
        id: win
        visible: root.shown || root.prog > 0.001
        anchors.top: true
        margins.top: 44
        implicitWidth: 660
        implicitHeight: 416
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        HyprlandFocusGrab {
            windows: [win]
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

            transformOrigin: Item.Top
            scale: 0.55 + 0.45 * root.prog
            opacity: Math.min(1, root.prog * 1.8)

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                // ===== 左: カレンダー + 写真 (幅は260に固定) =====
                ColumnLayout {
                    Layout.minimumWidth: 260
                    Layout.preferredWidth: 260
                    Layout.maximumWidth: 260
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    spacing: 8

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 4

                        Rectangle {
                            Layout.preferredWidth: 30
                            Layout.preferredHeight: 30
                            radius: 8
                            color: prevMa.containsMouse ? root.cHover : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "<"
                                color: root.cFg
                                font.family: root.fontFamily
                                font.pixelSize: 16
                                font.bold: true
                            }
                            MouseArea {
                                id: prevMa
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: root.shiftMonth(-1)
                            }
                        }

                        Text {
                            Layout.preferredWidth: 120
                            horizontalAlignment: Text.AlignHCenter
                            text: root.viewYear + "年" + (root.viewMonth + 1) + "月"
                            color: root.cFg
                            font.family: root.fontFamily
                            font.pixelSize: 16
                            font.bold: true
                        }

                        Rectangle {
                            Layout.preferredWidth: 30
                            Layout.preferredHeight: 30
                            radius: 8
                            color: nextMa.containsMouse ? root.cHover : "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: ">"
                                color: root.cFg
                                font.family: root.fontFamily
                                font.pixelSize: 16
                                font.bold: true
                            }
                            MouseArea {
                                id: nextMa
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: root.shiftMonth(1)
                            }
                        }
                    }

                    GridLayout {
                        Layout.alignment: Qt.AlignHCenter
                        columns: 7
                        rowSpacing: 2
                        columnSpacing: 2

                        Repeater {
                            model: root.dow
                            Text {
                                Layout.preferredWidth: 32
                                horizontalAlignment: Text.AlignHCenter
                                text: modelData
                                color: root.cDim
                                font.family: root.fontFamily
                                font.pixelSize: 13
                                font.bold: true
                            }
                        }

                        Repeater {
                            model: 42
                            Rectangle {
                                id: cell
                                property int dayNum: index - root.firstOffset + 1
                                property bool valid: dayNum >= 1 && dayNum <= root.daysInMonth
                                property bool isSel: valid
                                    && root.selected.getFullYear() === root.viewYear
                                    && root.selected.getMonth() === root.viewMonth
                                    && root.selected.getDate() === dayNum
                                property bool isToday: valid
                                    && root.today.getFullYear() === root.viewYear
                                    && root.today.getMonth() === root.viewMonth
                                    && root.today.getDate() === dayNum

                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 32
                                radius: 8
                                color: isSel ? root.cAccent
                                       : (cellMa.containsMouse && valid ? root.cHover : "transparent")
                                border.width: isToday && !isSel ? 1 : 0
                                border.color: root.cAccent

                                Text {
                                    anchors.centerIn: parent
                                    text: cell.valid ? cell.dayNum : ""
                                    color: cell.isSel ? root.pBackground : root.cFg
                                    font.family: root.fontFamily
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                MouseArea {
                                    id: cellMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: cell.valid
                                    onClicked: root.selectDay(cell.dayNum)
                                }
                            }
                        }
                    }

                    // 余白 (写真カードを下端に寄せる)
                    Item { Layout.fillHeight: true }

                    // 写真ウィジェット (角丸にクロップして表示)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: false
                        Layout.preferredHeight: root.bottomH
                        radius: 8
                        color: root.cCard

                        Image {
                            id: photo
                            anchors.fill: parent
                            source: Qt.resolvedUrl("seri_orihime.png")
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            visible: false
                        }

                        Rectangle {
                            id: photoMask
                            anchors.fill: parent
                            radius: 8
                            layer.enabled: true
                            visible: false
                        }

                        MultiEffect {
                            anchors.fill: parent
                            source: photo
                            maskEnabled: true
                            maskSource: photoMask
                        }
                    }
                }

                // ===== 右: メディア / 予定 / ステータス =====
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10

                    // メディアウィジェット
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 130
                        radius: 8
                        color: root.cCard
                        clip: true

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 14

                            // アートワーク
                            Item {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: Math.min(parent.height, 120)
                                Layout.preferredHeight: Math.min(parent.height, 120)

                                Image {
                                    id: artImg
                                    anchors.fill: parent
                                    source: root.player !== null ? root.player.trackArtUrl : ""
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    visible: false
                                }

                                Rectangle {
                                    id: artMask
                                    anchors.fill: parent
                                    radius: 8
                                    layer.enabled: true
                                    visible: false
                                }

                                MultiEffect {
                                    anchors.fill: parent
                                    source: artImg
                                    maskEnabled: true
                                    maskSource: artMask
                                    visible: artImg.status === Image.Ready
                                }

                                // アートワークがないときの代わり
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 8
                                    color: Qt.alpha(root.pBackground, 0.5)
                                    visible: artImg.status !== Image.Ready

                                    Text {
                                        anchors.centerIn: parent
                                        text: "♪"
                                        color: root.cDim
                                        font.family: root.fontFamily
                                        font.pixelSize: 34
                                    }
                                }

                                // Spotifyのときだけ出すバッジ
                                Rectangle {
                                    visible: root.player !== null && /spotify/i.test(root.player.identity || "")
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 6
                                    width: 22
                                    height: 22
                                    radius: 11
                                    color: root.pGreen

                                    Text {
                                        anchors.centerIn: parent
                                        text: "\uf1bc"
                                        color: root.pBackground
                                        font.family: root.fontFamily
                                        font.pixelSize: 14
                                    }
                                }
                            }

                            // 曲情報 / 操作 / シークバー
                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 0

                                Text {
                                    Layout.fillWidth: true
                                    text: root.player !== null && root.player.trackTitle !== ""
                                          ? root.player.trackTitle : "再生中のメディアなし"
                                    color: root.cFg
                                    elide: Text.ElideRight
                                    font.family: root.fontFamily
                                    font.pixelSize: 15
                                    font.bold: true
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: {
                                        if (root.player === null)
                                            return "";
                                        var a = root.player.trackArtist || "";
                                        var b = root.player.trackAlbum || "";
                                        if (a !== "" && b !== "")
                                            return a + " - " + b;
                                        return a + b;
                                    }
                                    color: root.cDim
                                    elide: Text.ElideRight
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                }

                                Item { Layout.fillHeight: true }

                                // 前へ / 再生・停止 / 次へ (図形で描画)
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 6
                                    opacity: root.player !== null ? 1 : 0.4

                                    Repeater {
                                        model: ["prev", "toggle", "next"]

                                        Item {
                                            id: btn
                                            property string kind: modelData
                                            property bool playing: root.player !== null && root.player.isPlaying

                                            Layout.preferredWidth: 36
                                            Layout.preferredHeight: 36

                                            onPlayingChanged: icon.requestPaint()

                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 18
                                                color: btnMa.containsMouse ? root.cHover : "transparent"
                                            }

                                            Canvas {
                                                id: icon
                                                anchors.fill: parent

                                                onPaint: {
                                                    var ctx = getContext("2d");
                                                    ctx.reset();
                                                    ctx.fillStyle = root.cFg;

                                                    function tri(x1, y1, x2, y2, x3, y3) {
                                                        ctx.beginPath();
                                                        ctx.moveTo(x1, y1);
                                                        ctx.lineTo(x2, y2);
                                                        ctx.lineTo(x3, y3);
                                                        ctx.closePath();
                                                        ctx.fill();
                                                    }

                                                    if (btn.kind === "next") {
                                                        tri(8, 11, 8, 25, 18, 18);
                                                        tri(18, 11, 18, 25, 28, 18);
                                                    } else if (btn.kind === "prev") {
                                                        tri(28, 11, 28, 25, 18, 18);
                                                        tri(18, 11, 18, 25, 8, 18);
                                                    } else if (btn.playing) {
                                                        ctx.fillRect(11, 9, 5, 18);
                                                        ctx.fillRect(20, 9, 5, 18);
                                                    } else {
                                                        tri(12, 8, 12, 28, 28, 18);
                                                    }
                                                }
                                                Component.onCompleted: requestPaint()

                                                Connections {
                                                    target: root
                                                    function onCFgChanged() {
                                                        icon.requestPaint();
                                                    }
                                                }
                                            }

                                            MouseArea {
                                                id: btnMa
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                onClicked: {
                                                    if (root.player === null)
                                                        return;
                                                    if (btn.kind === "prev")
                                                        root.player.previous();
                                                    else if (btn.kind === "next")
                                                        root.player.next();
                                                    else
                                                        root.player.togglePlaying();
                                                }
                                            }
                                        }
                                    }
                                }

                                Item { Layout.fillHeight: true }

                                // シークバー (クリックでシーク)
                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 14

                                    Rectangle {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width
                                        height: 4
                                        radius: 2
                                        color: Qt.alpha(root.pForeground, 0.25)

                                        Rectangle {
                                            height: parent.height
                                            radius: 2
                                            width: parent.width * root.progress
                                            color: root.pBlue
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: mouse => {
                                            var p = root.player;
                                            if (p !== null && p.canSeek && p.length > 0)
                                                p.position = mouse.x / width * p.length;
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        text: root.player !== null ? root.fmt(root.player.position) : "--:--"
                                        color: root.cDim
                                        font.family: root.fontFamily
                                        font.pixelSize: 10
                                    }
                                    Item { Layout.fillWidth: true }
                                    Text {
                                        text: (root.player !== null && root.player.length > 0)
                                              ? "-" + root.fmt(root.player.length - root.player.position) : "--:--"
                                        color: root.cDim
                                        font.family: root.fontFamily
                                        font.pixelSize: 10
                                    }
                                }
                            }
                        }
                    }

                    // 予定 (予定がなくても枠は残す。最大3件まで表示)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: false
                        Layout.preferredHeight: 100
                        radius: 8
                        color: root.cCard
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 3

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Rectangle {
                                    Layout.preferredWidth: 3
                                    Layout.preferredHeight: 14
                                    radius: 2
                                    color: root.cAccent
                                }

                                Text {
                                    text: (root.selected.getMonth() + 1) + "/" + root.selected.getDate()
                                          + "(" + root.dowFull[root.selected.getDay()] + ") の予定"
                                    color: root.cFg
                                    font.family: root.fontFamily
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    visible: root.events.length > 3
                                    text: "+" + (root.events.length - 3)
                                    color: root.cDim
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                    font.bold: true
                                }
                            }

                            Text {
                                visible: root.events.length === 0
                                text: "予定なし"
                                color: root.cDim
                                font.family: root.fontFamily
                                font.pixelSize: 12
                            }

                            Repeater {
                                model: root.events.slice(0, 3)
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 10
                                    Text {
                                        Layout.preferredWidth: 46
                                        text: modelData.time
                                        color: root.cDim
                                        font.family: root.fontFamily
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.title
                                        color: root.cFg
                                        elide: Text.ElideRight
                                        font.family: root.fontFamily
                                        font.pixelSize: 12
                                    }
                                }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // システムステータス (円形ゲージ x3)
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: false
                        Layout.preferredHeight: root.bottomH
                        spacing: 8

                        Repeater {
                            model: root.gauges

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 8
                                color: root.cCard

                                // 上端基準で配置 (下段の文字の有無でゲージの位置が変わらないようにする)
                                ColumnLayout {
                                    anchors.top: parent.top
                                    anchors.topMargin: 10
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    spacing: 2

                                    Canvas {
                                        id: ring
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredWidth: 62
                                        Layout.preferredHeight: 62

                                        onPaint: {
                                            var ctx = getContext("2d");
                                            ctx.reset();
                                            var cx = width / 2;
                                            var cy = height / 2;
                                            var r = width / 2 - 5;
                                            ctx.lineWidth = 6;
                                            ctx.lineCap = "round";

                                            ctx.strokeStyle = root.pSelect;
                                            ctx.beginPath();
                                            ctx.arc(cx, cy, r, 0, Math.PI * 2);
                                            ctx.stroke();

                                            if (modelData.ring > 0) {
                                                var s = -Math.PI / 2;
                                                ctx.strokeStyle = modelData.col;
                                                ctx.beginPath();
                                                ctx.arc(cx, cy, r, s, s + Math.PI * 2 * Math.min(modelData.ring, 100) / 100);
                                                ctx.stroke();
                                            }
                                        }
                                        Component.onCompleted: requestPaint()

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.main
                                            color: modelData.col
                                            font.family: root.fontFamily
                                            font.pixelSize: 14
                                            font.bold: true
                                        }
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: modelData.label
                                        color: root.cFg
                                        font.family: root.fontFamily
                                        font.pixelSize: 12
                                        font.bold: true
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: modelData.sub
                                        color: root.cDim
                                        font.family: root.fontFamily
                                        font.pixelSize: 10
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
