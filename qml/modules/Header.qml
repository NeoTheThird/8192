/*
* Header.qml
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


UbuntuShape {
    id: header
    width: parent.width
    height: (width - 5 * spacing) / 6 + spacing * 2
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

    UbuntuShape {
        id: logo
        width: parent.height
        height: width
        source: Image {
            source: header.logo
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
}
