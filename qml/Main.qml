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
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import QtQuick.Window 2.2
import "modules"

Window {
    id: mainWindow
    title: i18n.tr("Welcome to 8192")
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

        property string version: "0.3"
        property bool activeState: Qt.application.active
        property bool firstStart: true

        Component.onCompleted: {
            console.log("8192 started")
        }

        Component.onDestruction: {
            console.log("8192 closed")
            game.save()
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
                trailingActionBar {
                    actions: [
                        Action {
                            iconName: "info"
                            text: i18n.tr("About")
                            onTriggered: popupController.about()
                        }, Action {
                            iconName: "reload"
                            text: i18n.tr("Restart")
                            onTriggered: popupController.restart()
                        }, Action {
                            iconName: "undo"
                            enabled: game.reversible
                            text: i18n.tr("Undo")
                            onTriggered: game.load()
                        }
                    ]
                }
            }

            Column {
                id: gameColumn
                width: height * .638
                height: parent.height - units.gu(8)
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: pageHeader.bottom
                    topMargin: units.gu(1)
                }
                spacing: units.gu(1)

                Header {
                    id: header
                    score: game.score
                    highscore: game.highscore
                    spacing: units.gu(1)
                    logo: Qt.resolvedUrl("../assets/logo.png")
                }

                Game {
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

                Footer {
                    id: footer
                }
            }

            Timer {
                id: winTimer
                running: false
                interval: 300
                onTriggered: popupController.victory()
            }

            Timer {
                id: failTimer
                running: false
                interval: 600
                onTriggered: popupController.defeat()
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

        PopupController {
            id: popupController
        }
    }
}
