import QtQuick 2.0

Rectangle {

    property size tileSize: Qt.size(400, 400)

    id: root
    width: 100
    height: 62

    QtObject {
        id: d

        property var tiles
    }


    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: 10000
        contentHeight: 10000

        property var mapTileComponent

        Component.onCompleted: {
            mapTileComponent = Qt.createComponent("MapTile.qml");
            updateTiles();
        }

        onContentXChanged: updateTiles()
        onContentYChanged: updateTiles()
        onWidthChanged: updateTiles()
        onHeightChanged: updateTiles()

        MapTile {}

        function updateTiles() {

            if (!mapTileComponent)
                return;

            if (!d.tiles)
                d.tiles = {};

            var left = Math.floor(flickable.contentX / root.tileSize.width);
            var top = Math.floor(flickable.contentY / root.tileSize.height);
            var right = Math.ceil((flickable.contentX + flickable.width) / root.tileSize.width) - 1
            var bottom = Math.ceil((flickable.contentY + flickable.height) / root.tileSize.height) - 1

            function updateRowTiles(index, row) {

                var i, tile;

                // remove old
                for (i in row) {
                    tile = row[i];
                    if (i < left || i > right) {
                        tile.destroy();
                        delete row[i];
                    }
                }

                // create new
                for (i = left; i <= right; i++) {
                    tile = row[i];
                    if (tile)
                        continue;

                    tile = mapTileComponent.createObject(flickable.contentItem);
                    row[i] = tile;
                    tile.x = i * root.tileSize.width;
                    tile.y = index * root.tileSize.height;
                    tile.width = root.tileSize.width;
                    tile.height = root.tileSize.height;
                }
            }

            function clearRow(row) {
                var tile;
                for (var i in row) {
                    tile = row[i];
                    tile.destroy();
                }
            }

            var row, i;

            // remove old
            for (i in d.tiles) {
                row = d.tiles[i];
                if (i < top || i > bottom) {
                    clearRow(row);
                    delete d.tiles[i];
                }
            }

            // create new
            for (i = top; i <= bottom; i++) {
                row = d.tiles[i];
                if (!row) {
                    row = {};
                    d.tiles[i] = row;
                }
                updateRowTiles(i, row);
            }
        }

    }

}
