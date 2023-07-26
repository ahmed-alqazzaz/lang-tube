var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
var player;
var timerId;
function onYouTubeIframeAPIReady() {
    player = new YT.Player('player', {
        height: '100%',
        width: '100%',
        videoId: 'VIDEO_ID',
        playerVars: {
            'controls': 1,
            'playsinline': 1,
            'enablejsapi': 1,
            'fs': 0,
            'rel': 0,
            'showinfo': 0,
            'iv_load_policy': 3,
            'cc_load_policy': 'CC_LOAD_POLICY',
            'cc_lang_pref': 'CC_LANG_PREF',
            'autoplay': 'AUTOPLAY',
            'start': 'START',
            'end': 'END',
        },
        events: {
            onReady: function(event) {
                hideControls();
                //hideHeader();
                window.flutter_inappwebview.callHandler('Ready'); 
            },
            onStateChange: function(event) { sendPlayerStateChange(event.data); },
            onPlaybackQualityChange: function(event) { window.flutter_inappwebview.callHandler('PlaybackQualityChange', event.data); },
            onPlaybackRateChange: function(event) { window.flutter_inappwebview.callHandler('PlaybackRateChange', event.data); },
            onError: function(error) { window.flutter_inappwebview.callHandler('Errors', error.data); }
        },
    });
}
function sendPlayerStateChange(playerState) {
    clearTimeout(timerId);
    window.flutter_inappwebview.callHandler('StateChange', playerState);
    if (playerState == 1) {
        startSendCurrentTimeInterval();
        sendVideoData(player);
    }
}
function sendVideoData(player) {
    var videoData = {
        'duration': player.getDuration(),
        'title': player.getVideoData().title,
        'author': player.getVideoData().author,
        'videoId': player.getVideoData().video_id
    };
    window.flutter_inappwebview.callHandler('VideoData', videoData);
}
function startSendCurrentTimeInterval() {
    timerId = setInterval(function () {
        window.flutter_inappwebview.callHandler('VideoTime', player.getCurrentTime(), player.getVideoLoadedFraction());
    }, 100);
}
function play() {
    player.playVideo();
    return '';
}
function pause() {
    player.pauseVideo();
    return '';
}
function loadById(loadSettings) {
    player.loadVideoById(loadSettings);
    return '';
}
function cueById(cueSettings) {
    player.cueVideoById(cueSettings);
    return '';
}
function loadPlaylist(playlist, index, startAt) {
    player.loadPlaylist(playlist, 'playlist', index, startAt);
    return '';
}
function cuePlaylist(playlist, index, startAt) {
    player.cuePlaylist(playlist, 'playlist', index, startAt);
    return '';
}
function mute() {
    player.mute();
    return '';
}
function unMute() {
    player.unMute();
    return '';
}
function setVolume(volume) {
    player.setVolume(volume);
    return '';
}
function seekTo(position, seekAhead) {
    player.seekTo(position, seekAhead);
    return '';
}
function setSize(width, height) {
    player.setSize(width , height);
    return '';
}
function setPlaybackRate(rate) {
    player.setPlaybackRate(rate);
    return '';
}
function setTopMargin(margin) {
    document.getElementById("player").style.marginTop = margin;
    return '';
}
function hideControls() {
    let iframeDocument = getIFrameDocument();
    let controlsBar = iframeDocument.querySelector('.ytp-chrome-bottom')
    controlsBar.style.display = 'none'
}
function showControls(){
    let iframeDocument = getIFrameDocument();
    let controlsBar = iframeDocument.querySelector('.ytp-chrome-bottom')
    controlsBar.style.display = 'block'
}
function hideHeader(){
    let iframeDocument = getIFrameDocument();
    let header = iframeDocument.querySelector('.ytp-chrome-top');
    header.style.display = 'none'
}
function displayHeader(){
    let iframeDocument = getIFrameDocument();
    let header = iframeDocument.querySelector('.ytp-chrome-top');
    header.style.display = 'block'
}
function setVideoQuality(quality) {
    let iframeDocument = getIFrameDocument();
    let settingsButton = iframeDocument.querySelector('.ytp-settings-button')
    let settingsMenu = iframeDocument.querySelector('.ytp-settings-menu')
    try {
        console.assert(!JSON.parse(settingsButton.ariaExpanded), "setting menu is already expanded")
        settingsButton.click();
        settingsMenu.style.display = 'none';
        console.assert(clickMenuItem('Quality'), "unable to locate 'Quality' setting button")
        if(!clickMenuItem(quality)) console.error(`Quality unavailable ${quality}`)   
    } finally {
        setTimeout(() => {
            if (JSON.parse(settingsButton.ariaExpanded)) {
                settingsButton.click()
            }
        }, 300
        )
    }
}

function clickMenuItem(menuItemLabel) {
    let menuItems = getMenuItems();
    for (const menuItem of menuItems) {
        let itemLabel = menuItem.querySelector('.ytp-menuitem-label');
        if (itemLabel.textContent.includes(menuItemLabel)) {
            menuItem.click();
            return true; // Return true if the menu item is found and clicked.
        }
    }
    return false; // Return false if the menu item is not found.
}
function getMenuItems() {
    let iframeDocument = getIFrameDocument();
    let settingsMenu = iframeDocument.querySelector('.ytp-settings-menu')
    return settingsMenu.querySelectorAll('.ytp-menuitem')
}
function getIFrameDocument() {
    var iframeElement = document.querySelector('iframe');

    if (iframeElement) {
        // If the iframe element is found, return its contentWindow.document
        return iframeElement.contentWindow.document;
    } else {
        // If the iframe element is not found, you can return an alternative document object.
        // In this example, we'll return the main document, but you can decide what suits your use case.
        return document;
    }
}