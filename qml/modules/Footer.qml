/*
* Footer.qml
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

UbuntuShape {
    id: footer
    width: parent.width
    height: (width - 5 * spacing) / 6 + spacing * 2.5
    color: UbuntuColors.warmGrey

    property int score
    property int highscore
    property int spacing
    property string logo

    Row {
        anchors.centerIn: parent
        height: parent.height - spacing * 2
        width: parent.width - spacing * 2
        spacing: units.gu(1)

        Button {
            width: (parent.width - units.gu(1)) / 2
            height: parent.height
            color: "#eee4da"
            onClicked: PopupUtils.open(restartDiaComponent)
            Label {
                width: parent.width * 0.9
                height: parent.height * 0.9
                anchors.centerIn: parent
                font.pixelSize: parent.height / 2.5
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#656565"
                text: i18n.tr("Restart")
            }
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
            }
        }

        Button {
            width: (parent.width - units.gu(1)) / 2
            height: parent.height
            color: "#eee4da"
            onClicked: PopupUtils.open(aboutDiaComponent)
            Label {
                width: parent.width * 0.9
                height: parent.height * 0.9
                anchors.centerIn: parent
                font.pixelSize: parent.height / 2.5
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#656565"
                text: i18n.tr("About")
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
            }
        }
    }
}
