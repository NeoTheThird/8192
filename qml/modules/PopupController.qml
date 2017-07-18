/*
* PopupController.qml
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

Item {
    id: popupController

    function restart() {
        PopupUtils.open(restartDiaComponent)
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

    function about() {
        PopupUtils.open(aboutDiaComponent)
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

    function victory() {
        PopupUtils.open(victoryDiaComponent)
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
        }
    }

    function defeat() {
        PopupUtils.open(defeatDiaComponent)
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
        }
    }
}
