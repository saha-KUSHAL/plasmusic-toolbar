import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

PlasmaCore.DataSource {
    property string sourceName: "@multiplex"
    readonly property bool ready: (data[sourceName] !== undefined) && (data[sourceName].Metadata !== undefined)

    readonly property var artists: ready ? data[sourceName].Metadata["xesam:artist"] : []
    readonly property string title: ready ? data[sourceName].Metadata["xesam:title"] : ""
    readonly property string playbackStatus: ready ? data[sourceName].PlaybackStatus : ""
    readonly property bool shuffle: ready && data[sourceName].Shuffle ? data[sourceName].Shuffle : false
    readonly property string artUrl: ready ? data[sourceName].Metadata["mpris:artUrl"] : ""
    readonly property string loopStatus: ready && data[sourceName].LoopStatus ? data[sourceName].LoopStatus : "None"
    readonly property var lastSongPositionUpdate: ready ? data[sourceName]["Position last updated (UTC)"] : new Date()
    readonly property int songPosition: ready ? data[sourceName].Position : 0
    readonly property int songLength: ready ? data[sourceName].Metadata["mpris:length"] : 0
    readonly property real volume: ready ? data[sourceName].Volume : 0

    readonly property bool canGoNext: ready ? data[sourceName].CanGoNext : false
    readonly property bool canGoPrevious: ready ? data[sourceName].CanGoPrevious : false
    readonly property bool canPlay: ready ? data[sourceName].CanPlay : false
    readonly property bool canPause: ready ? data[sourceName].CanPause : false
    readonly property bool canSeek: ready ? data[sourceName].CanSeek : false

    // To know whether Shuffle and Loop can be changed we have to check if the property is defined,
    // unlike the other commands, LoopStatus and Shuffle hasn't a specific property such as
    // CanPause, CanSeek, etc.
    readonly property bool canChangeShuffle: ready ? data[sourceName].Shuffle != undefined : false
    readonly property bool canChangeLoopStatus: ready ? data[sourceName].LoopStatus != undefined : false

    engine: "mpris2"
    connectedSources: []

    Component.onCompleted: () => {
        if (this.sources.find(s => this.sourceName)) {
            this.connectSource(this.sourceName)
        }
    }

    onSourceNameChanged: () => {
        if (this.sources.find(s => this.sourceName)) {
            this.connectSource(this.sourceName)
        }
    }

    onSourceAdded: (source) => {
        if (source === this.sourceName) {
            this.connectSource(source);
        }
    }

    function startOperation(op, params = {}) {
        const service = this.serviceForSource(this.sourceName);
        const operation = service.operationDescription(op);
        Object.assign(operation, params);
        service.startOperationCall(operation);
    }
}