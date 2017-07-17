/*
* GameLogic.qml
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
    id: app
    height: width
    focus: true
    color: UbuntuColors.warmGrey

    property var numbers: []
    property var board: new Array(app.rows*app.cols)
    property string boardString: ""
    property int cols: 6
    property int rows: 6
    property int finalValue: 8192
    property int score: 0
    property int highscore: 0
    property bool won: false

    signal victory
    signal defeat

    function getNumber(col, row) {
        for (var i = 0; i < numbers.length; i++) {
            if (numbers[i].col == col && numbers[i].row == row)
            return numbers[i]
        }
    }

    function popNumber(col, row) {
        var tmp = numbers
        for (var i = 0; i < tmp.length; i++) {
            if (tmp[i].col == col && tmp[i].row == row) {
                tmp[i].disappear()
                tmp.splice(i, 1)
            }
        }
        numbers = tmp
    }

    function purge() {
        score = 0
        won = false
        var tmp = numbers
        for (var i = 0; i < tmp.length; i++) {
            tmp[i].destroy()
        }
        tmp = new Array()
        numbers = tmp
        new_number()
        new_number()
        console.log("New board")
        save()
    }

    function load() {
        board = JSON.parse(boardString)
        var newNumber
        for (var i = 0; i < board.length; i++) {
            if (board[i]) {
                newNumber = number.createObject(gameGrid,{"number": board[i],"col": i / app.cols,"row": i % app.cols})
                numbers.push(newNumber)
            }
        }
    }

    function save() {
        for (var i = 0; i < app.cols; i++) {
            for (var j = 0; j < app.rows; j++) {
                if (getNumber(i, j)) {
                    app.board[(i * app.cols) + j] = getNumber(i,j).number
                } else {
                    app.board[(i * app.cols) + j] = 0
                }
            }
        }
        boardString = JSON.stringify(board)
    }

    function checkNotStuck() {
        for (var i = 0; i < app.cols; i++) {
            for (var j = 0; j < app.rows; j++) {
                if (!getNumber(i, j))
                return true
                if (getNumber(i+1,j) && getNumber(i,j).number == getNumber(i+1,j).number)
                return true
                if (getNumber(i-1,j) && getNumber(i,j).number == getNumber(i-1,j).number)
                return true
                if (getNumber(i,j+1) && getNumber(i,j).number == getNumber(i,j+1).number)
                return true
                if (getNumber(i,j-1) && getNumber(i,j).number == getNumber(i,j-1).number)
                return true
            }
        }
        return false
    }

    Component {
        id: number

        UbuntuShape {
            id: colorRect
            color: number <=    1 ? "transparent" :
            number <=    2 ? "#eee4da"     :
            number <=    4 ? "#ede0c8"     :
            number <=    8 ? "#f2b179"     :
            number <=   16 ? "#f59563"     :
            number <=   32 ? "#f67c5f"     :
            number <=   64 ? "#f65e3b"     :
            number <=  128 ? "#edcf72"     :
            number <=  256 ? "#edcc61"     :
            number <=  512 ? "#edc850"     :
            number <= 1024 ? "#edc53f"     :
            number <= 2048 ? "#edc22e"     :
            number <= 4096 ? "#E95420"     :
            number <= 8192 ? "#77216F"     :
            "#2C001E"

            property int col
            property int row

            property int number: Math.random() > 0.8 ? 4 : 2

            x: cells.getTile(col, row).x
            y: cells.getTile(col, row).y
            width: cells.getTile(col, row).width
            height: cells.getTile(col, row).height

            Timer {
                id: newNumTimer
                running: false
                interval: 100
                onTriggered: zoomIn.xScale = zoomIn.yScale = 1
                onRunningChanged: if (running) zoomIn.xScale = zoomIn.yScale = 1.2
            }

            function move(h, v) {
                if (h == col && v == row)
                return false
                if (app.getNumber(h, v)) {
                    number += app.getNumber(h, v).number
                    app.score += number
                    if (number == finalValue && !won) {
                        won = true
                        app.victory()
                    }
                    app.popNumber(h, v)
                    newNumTimer.start()
                }
                col = h
                row = v
                return true
            }

            function disappear() {
                disappearAnimation.start()
            }


            Label {
                id: text

                width: parent.width * 0.9
                height: parent.height * 0.9
                anchors.centerIn: parent

                font.pixelSize: parent.height / 2.5
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: number <= 4 ? "#656565" : "#f2f3f4"

                text: parent.number > 1 ? parent.number : ""
            }

            Behavior on x {
                NumberAnimation {
                    duration: 60
                    easing {
                        type: Easing.InOutQuad
                    }
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: 60
                    easing {
                        type: Easing.InOutQuad
                    }
                }
            }

            NumberAnimation on opacity {
                id: disappearAnimation
                duration: 80
                running: false
                to: 0
                onStopped: colorRect.destroy()
            }

            transform: Scale {
                id: zoomIn
                origin.x: colorRect.width / 2
                origin.y: colorRect.height / 2
                xScale: 0
                yScale: 0

                Behavior on xScale {
                    NumberAnimation {
                        duration: 150
                        easing {
                            type: Easing.InOutQuad
                        }
                    }
                }

                Behavior on yScale {
                    NumberAnimation {
                        duration: 150
                        easing {
                            type: Easing.InOutQuad
                        }
                    }
                }
            }

            Component.onCompleted: {
                zoomIn.xScale = 1
                zoomIn.yScale = 1
            }
        }
    }

    Grid {
        id: gameGrid
        anchors.centerIn: parent
        height: parent.height - spacing * 2
        width: parent.width - spacing * 2
        rows: app.rows
        columns: app.cols
        spacing: units.gu(1)

        property real cellWidth: (width - (columns - 1) * spacing) / columns
        property real cellHeight: (height - (rows - 1) * spacing) / rows

        Repeater {
            id: cells
            model: app.cols * app.rows
            function getTile(h, v) {
                return itemAt(h + v * app.cols)
            }

            function getRandom() {
                return itemAt(Math.floor((Math.random() * 16)%16))
            }

            function getRandomFree() {
                var free = new Array()
                for (var i = 0; i < app.cols; i++) {
                    for (var j = 0; j < app.rows; j++) {
                        if (!getNumber(i, j)) {
                            free.push(getTile(i, j))
                        }
                    }
                }
                return free[Math.floor(Math.random()*free.length)]
            }

            UbuntuShape {
                width: parent.cellWidth
                height: parent.cellHeight
                color: "#F0F0F0"
                opacity: 0.3

                property int col : index % app.cols
                property int row : index / app.cols
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        property int minimumLength: app.width < app.height ? app.width / 6 : app.height / 6
        property int startX
        property int startY
        onPressed: {
            startX = mouse.x
            startY = mouse.y
        }

        onReleased: {
            var length = Math.sqrt(Math.pow(mouse.x - startX, 2) + Math.pow(mouse.y - startY, 2))
            if (length < minimumLength)
            return
            var diffX = mouse.x - startX
            var diffY = mouse.y - startY
            if (Math.abs(Math.abs(diffX) - Math.abs(diffY)) < minimumLength / 2)
            return
            if (Math.abs(diffX) > Math.abs(diffY))
            if (diffX > 0)
            app.move(1, 0)
            else
            app.move(-1, 0)
            else
            if (diffY > 0)
            app.move(0, 1)
            else
            app.move(0, -1)
        }
    }

    function new_number() {
        var tmp = numbers
        var cell = cells.getRandomFree()
        var newNumber = number.createObject(gameGrid,{"col":cell.col,"row":cell.row})
        tmp.push(newNumber)
        numbers = tmp
    }

    function move(col, row) {
        var somethingMoved = false
        var tmp = numbers
        if (col > 0) {
            for (var j = 0; j < app.rows; j++) {
                var filled = 0
                var canMerge = false
                for (var i = app.cols - 1; i >= 0; i--) {
                    if (getNumber(i,j)) {
                        if (canMerge) {
                            if (getNumber(i,j).number == getNumber(app.cols-filled,j).number) {
                                canMerge = false
                                filled--
                            }
                        }
                        else {
                            canMerge = true
                        }
                        if (getNumber(i,j).move(app.cols-1-filled,j))
                        somethingMoved = true
                        filled++
                    }
                }
            }
        }

        if (col < 0) {
            for (var j = 0; j < app.rows; j++) {
                var filled = 0
                var canMerge = false
                for (var i = 0; i < app.cols; i++) {
                    if (getNumber(i,j)) {
                        if (canMerge) {
                            if (getNumber(i,j).number == getNumber(filled-1,j).number) {
                                canMerge = false
                                filled--
                            }
                        }
                        else {
                            canMerge = true
                        }
                        if (getNumber(i,j).move(filled,j))
                        somethingMoved = true
                        filled++
                    }
                }
            }
        }

        if (row > 0) {
            for (var i = 0; i < app.cols; i++) {
                var filled = 0
                var canMerge = false
                for (var j = app.rows - 1; j >= 0; j--) {
                    if (getNumber(i,j)) {
                        if (canMerge) {
                            if (getNumber(i,j).number == getNumber(i,app.rows-filled).number) {
                                canMerge = false
                                filled--
                            }
                        }
                        else {
                            canMerge = true
                        }
                        if (getNumber(i,j).move(i,app.rows-1-filled))
                        somethingMoved = true
                        filled++
                    }
                }
            }
        }

        if (row < 0) {
            for (var i = 0; i < app.cols; i++) {
                var filled = 0
                var canMerge = false
                for (var j = 0; j < app.rows; j++) {
                    if (getNumber(i,j)) {
                        if (canMerge) {
                            if (getNumber(i,j).number == getNumber(i,filled-1).number) {
                                canMerge = false
                                filled--
                            }
                        }
                        else {
                            canMerge = true
                        }
                        if (getNumber(i,j).move(i,filled))
                        somethingMoved = true
                        filled++
                    }
                }
            }
        }

        if (somethingMoved) {
            new_number()
        }

        if (!checkNotStuck()) {
            app.defeat()
        } else {
            save()
        }
    }
}
