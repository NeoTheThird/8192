/*
* Main.qml
*
* Copyright (C) 2017 Jan Sprinz aka. NeoTheThird <neo@neothethird.de>
* This file is part of 8192, a game about squares. <http://neothethird.de/8192/>
*
* This game was shamelessly ripped of from Gabriele Cirulli's game "2048",
* wich was inspired by Jason Saxon's game "1024!". If you enjoy this game
* and you ever happen to meet them, please consider treating them for a decent
* cup of coffe, they really deserve it!
*
* 8192 is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License version 3 as
* published by the Free Software Foundation.
*
* 8192 is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with 8192. If not, see <http://www.gnu.org/licenses/>.
*
*/

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.0
import Qt.labs.settings 1.0
import QtQuick.Window 2.2
import "modules"

Window {
    id: mainWindow
    title: "Welcome to UBports"
    width: units.gu(360)
    height: units.gu(530)
    minimumWidth: units.gu(45)
    minimumHeight: units.gu(45)
    maximumWidth: Screen.width
    maximumHeight: Screen.height

    MainView {
        id: mainView
        objectName: "mainView"
        applicationName: "8192.neothethird"
        focus: true
        automaticOrientation: true
        anchorToKeyboard: true
        anchors.fill: parent


        property string version: "0.2"
        property bool activeState: Qt.application.active
        property bool firstStart: true

        Component.onCompleted: {
            console.log("8192 started")
        }

        Component.onDestruction: {
            console.log("8192 closed")
        }

        Settings {
            category: "General"
            property alias firstStart: mainView.firstStart
        }

        Settings {
            category: "Window"
            property alias width: mainWindow.width
            property alias height: mainWindow.height
        }

        Settings {
            category: "Game"
            property alias boardString: game.boardString
            property alias cols: game.cols
            property alias rows: game.rows
            property alias score: game.score
            property alias highscore: game.highscore
            property alias won: game.won
        }

        Page {
            id: gamePage
            title: "8192"
            visible: true

            header: PageHeader {
                id: pageHeader
                title: i18n.tr("Welcome to 8192")
                StyleHints {
                    foregroundColor: UbuntuColors.orange
                    backgroundColor: UbuntuColors.porcelain
                    dividerColor: UbuntuColors.slate
                }
            }

            Column {
                id: gameColumn
                width: parent.width - units.gu(2)
                height: width * 1.5
                anchors.fill: parent
                anchors.topMargin: units.gu(7)
                anchors.leftMargin: units.gu(1)
                anchors.rightMargin: units.gu(1)
                anchors.bottomMargin: units.gu(1)
                spacing: units.gu(1)

                Row {
                    id: topMenue
                    width: parent.width
                    height: parent.height / 9
                    spacing: units.gu(1)

                    UbuntuShape {
                        id: logo
                        width: parent.height
                        height: width
                        source: Image {
                            source: "../assets/logo.png"
                        }
                    }

                    Column {
                        id: scores
                        width: parent.width - parent.height - units.gu(1)
                        height: parent.height
                        spacing: units.gu(1)

                        Button {
                            width: parent.width
                            height: (parent.height - parent.spacing) / 2
                            color: UbuntuColors.warmGrey
                            text: "<center><small>" + i18n.tr("YOUR SCORE") + ":</small> <b>" + game.score + "</b></center>"
                        }
                        Button {
                            width: parent.width
                            height: (parent.height - parent.spacing) / 2
                            color: UbuntuColors.warmGrey
                            text: "<center><small>" + i18n.tr("HIGHSCORE") + ":</small> <b>" + game.highscore + "</b></center>"
                        }
                    }
                }

                Game_8192 {
                    id: game
                    width: gameColumn.width

                    onVictory: winTimer.start()
                    onDefeat: failTimer.start()
                    onScoreChanged: if (score > highscore) highscore = score

                    Component.onCompleted: {
                        if(mainView.firstStart) {
                            purge()
                            mainView.firstStart = false
                        } else {
                            load()
                        }
                    }
                }

                Row {
                    id: controls
                    width: game.width
                    height: units.gu(6)
                    spacing: units.gu(1)

                    Button {
                        text: i18n.tr("Restart")
                        width: (parent.width - units.gu(1)) / 2
                        height: parent.height
                        color: UbuntuColors.warmGrey
                        onClicked: PopupUtils.open(restartDiaComponent)
                    }

                    Button {
                        text: i18n.tr("About")
                        width: (parent.width - units.gu(1)) / 2
                        height: parent.height
                        color: UbuntuColors.warmGrey
                        onClicked: PopupUtils.open(aboutDiaComponent)
                    }
                }
            }

            Timer {
                id: winTimer
                running: false
                interval: 300
                onTriggered: PopupUtils.open(victoryDiaComponent)
            }

            Timer {
                id: failTimer
                running: false
                interval: 600
                onTriggered: PopupUtils.open(defeatDiaComponent)
            }

            Component {
                id: restartDiaComponent
                Dialog {
                    id: restartDia
                    title: i18n.tr("Restart")
                    text: i18n.tr("Are you sure you want to restart the game?")
                    Button {
                        text: i18n.tr("Yes")
                        onClicked: {
                            game.purge()
                            PopupUtils.close(restartDia)
                        }
                    }
                    Button {
                        text: i18n.tr("No")
                        color: UbuntuColors.warmGrey
                        onClicked: {
                            PopupUtils.close(restartDia)
                        }
                    }
                    Component.onCompleted: mainView.focus = false
                    Component.onDestruction: mainView.focus = true
                }
            }

            Component {
                id: victoryDiaComponent
                Dialog {
                    id: victoryDia
                    title: i18n.tr("Victory")
                    Button {
                        text: i18n.tr("Keep going")
                        onClicked: {
                            PopupUtils.close(victoryDia)
                        }
                    }
                    Button {
                        text: i18n.tr("Restart")
                        color: UbuntuColors.warmGrey
                        onClicked: {
                            game.purge()
                            PopupUtils.close(victoryDia)
                        }
                    }
                    Component.onCompleted: mainView.focus = false
                    Component.onDestruction: mainView.focus = true
                }
            }

            Component {
                id: defeatDiaComponent
                Dialog {
                    id: defeatDia
                    title: i18n.tr("Game over. :(")
                    text: i18n.tr("Score") + ": " + game.score

                    Button {
                        text: i18n.tr("Restart")
                        color: UbuntuColors.green
                        onClicked: {
                            game.purge()
                            PopupUtils.close(defeatDia)
                        }
                    }
                    Button {
                        text: i18n.tr("Quit")
                        color: UbuntuColors.red
                        onClicked: {
                            game.purge()
                            Qt.quit()
                        }
                    }
                    Component.onCompleted: mainView.focus = false
                    Component.onDestruction: mainView.focus = true
                }
            }

            Component {
                id: aboutDiaComponent
                Dialog {
                    id: aboutDia
                    title: "8192"
                    text: "<b>" + i18n.tr("Version") + ":</b> " + mainView.version + "<br><br>" + i18n.tr("This game was shamelessly ripped of from Gabriele Cirulli's game \"2048\", which was inspired by Jason Saxon's game \"1024!\". If you enjoy this game and you ever happen to meet them, please consider treating them for a decent cup of coffee, they really deserve it!") + "<br><br><b>"+ i18n.tr("Copyright") + " (c) 2017 Jan Sprinz <br>neo@neothethird.de</b>"

                    Button {
                        text: i18n.tr("Donate")
                        onClicked: {
                            Qt.openUrlExternally("https://paypal.me/neothethird")
                            PopupUtils.close(aboutDia)
                        }
                    }
                    Button {
                        text: i18n.tr("Report a bug")
                        color: UbuntuColors.warmGrey
                        onClicked: {
                            Qt.openUrlExternally("https://github.com/neothethird/8192/issues")
                            PopupUtils.close(aboutDia)
                        }
                    }
                    Button {
                        text: i18n.tr("Close")
                        color: UbuntuColors.slate
                        onClicked: {
                            PopupUtils.close(aboutDia)
                        }
                    }
                    Component.onCompleted: mainView.focus = false
                    Component.onDestruction: mainView.focus = true
                }
            }
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Left)
            game.move(-1, 0)
            if (event.key == Qt.Key_Right)
            game.move(1, 0)
            if (event.key == Qt.Key_Up)
            game.move(0, -1)
            if (event.key == Qt.Key_Down)
            game.move(0, 1)
        }
    }
}
