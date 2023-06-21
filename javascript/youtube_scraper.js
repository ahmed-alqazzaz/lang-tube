const VIDEO_ITEM_QUERY = 'ytm-media-item';
const ITEM_DETAILS_QUERY = 'div.details';
const ITEM_TITLE_QUERY = 'h3.media-item-headline';
const ITEM_BADGES_QUERY = 'ytm-badge-and-byline-renderer';
const THUMBNAIL_QUERY = 'a.media-item-thumbnail-container';
const CHANNEL_ICON_QUERY = 'ytm-channel-thumbnail-with-link-renderer';
const IMAGE_QUERY = 'img';

// CAN BE USED IN DART
// returns a json string of all the video items
// that have been collected (without their element object)
function fetchRecommendedVideosData() {
  const videoItemsData = fetchVideoItems().map((videoItemJson) => {
    delete videoItemJson['element'];
    return videoItemJson;
  });
  console.log(videoItemsData.length);
  return JSON.stringify(videoItemsData);
}

// MUST NOT BE EXPOSED TO DART
// fetches all the video items that have been collected
// along with their elements
function fetchVideoItems() {
  const VIDEO_ITEMS_LIST = [];

  const videoItems = document.querySelectorAll(VIDEO_ITEM_QUERY);
  for (let i = 0; i < videoItems.length; i++) {
    const videoItem = videoItems[i];
    const videoDetails = getVideoDetails(videoItem);
    const videoThumbnail = getVideoThumbnail(videoItem);
    const videoChannelIcon = getChannelIcon(videoDetails);
    const videoItemJson = {
      'element': videoItem,
      'id': getVideoId(videoThumbnail),
      'title': getVideoTitle(videoDetails),
      'badges': getVideoBadges(videoDetails),
      'channel_icon_url': getFirstImageUrlFromElement(videoChannelIcon),
      'thumbnail_url': getFirstImageUrlFromElement(videoThumbnail),
    };
    VIDEO_ITEMS_LIST.push(videoItemJson);
  }
  return VIDEO_ITEMS_LIST;
}

function getVideoId(element) {
  if (element instanceof Element) {
    if (element.matches(THUMBNAIL_QUERY)) {
      const url = element.getAttribute('href');
      if (url !== null) {
        return url.split('watch?v=')[1];
      }
      return log('video url not found');
    }
    return console.log(`get video details input must match ${THUMBNAIL_QUERY}`);
  }
  console.log(`get video details input must be an Element`);
}

function getVideoDetails(element) {
  if (element instanceof Element) {
    if (element.matches(VIDEO_ITEM_QUERY)) {
      return element.querySelector(ITEM_DETAILS_QUERY);
    }
    return console.log(`get video details input must match ${VIDEO_ITEM_QUERY}`);
  }
  console.log(`get video details input must be an Element`);
}
function getVideoTitle(element) {
  if (element instanceof Element) {
    if (element.matches(ITEM_DETAILS_QUERY)) {
      return element.querySelector(ITEM_TITLE_QUERY).textContent;
    }
    return console.log(`get video title input must match ${ITEM_DETAILS_QUERY}`)
  }
  console.log(`get video title input must be an Element`)
}

function getChannelIcon(element) {
  if (element instanceof Element) {
    if (element.matches(ITEM_DETAILS_QUERY)) {
      return element.querySelector(CHANNEL_ICON_QUERY);
    }
    return console.log(`get video title input must match ${ITEM_DETAILS_QUERY}`)
  }
  console.log(`get video title input must be an Element`)
}

function getVideoBadges(element) {
  if (element instanceof Element) {
    if (element.matches(ITEM_DETAILS_QUERY)) {
      return Array.from(element.querySelector(ITEM_BADGES_QUERY).children).map(
        (element) => element.textContent,
      );

    }
    return console.log(`get video badges input must match ${ITEM_BADGES_QUERY}`);
  }
  console.log(`get badges must be an Element`);
}
function getVideoThumbnail(element) {
  if (element instanceof Element) {
    if (element.matches(VIDEO_ITEM_QUERY)) {
      let x =  element.querySelector(THUMBNAIL_QUERY);
      console.log(`get video thumbnail ${x ==null}`);
      return x;
    }
    return console.log(`get video thumbnail input must match ${VIDEO_ITEM_QUERY}`);
  }
  console.log(`click video input must be an Element`);
}

function getFirstImageUrlFromElement(element) {
  if (element instanceof Element) {
    const image = element.querySelector(IMAGE_QUERY).src;
    if (image != null) {
      return image
    }
    return console.log(`get first image input must match ${THUMBNAIL_QUERY}`);
  }
  console.log(`get image input must be an Element`)
  console.log(`get image is null ${element == null}`)
  console.log(`get image is  ${element instanceof Element}`)
  

}
function clickVideoById(id) {
  if (id !== '') {
    var presentVideoItems = fetchVideoItems();
    for (var i = 0; i < presentVideoItems.length; i++) {
      var item = presentVideoItems[i];
      if (item['id'] == id) {
        var element = item['element']
        if (element.matches(VIDEO_ITEM_QUERY)) {
          element.scrollIntoView({ behavior: 'smooth' });
          return sleep(1200).then(() => {
            return clickVideo(element);
          })
        }
        return console.log(`click video by Id input must match ${VIDEO_ITEM_QUERY}`);
      }
    }
    console.log(`Requested id ${id} is not within the current page: pushing state manually`);
    window.history.pushState(null, null, `/watch?v=${id}`);
    return window.dispatchEvent(new PopStateEvent('popstate'));
  }
  console.log(`click video by url input must be a string`);

}
function clickVideo(element) {
  if (element instanceof Element) {
    if (element.matches(VIDEO_ITEM_QUERY)) {
      return element.querySelector(THUMBNAIL_QUERY).click();
    }
    return console.log(`click video input must match ${VIDEO_ITEM_QUERY}`);
  }
  console.log(`click video input must be an Element`)
}


function isDocumentFullyLoaded() {
  return document.readyState === "complete";
}
function scrollToBottom() {
  window.scrollTo({ top: 0, behavior: 'smooth' });
}
function currentUrl() {
  return window.location.href;
}
function navigateBack() {
  window.history.back();
}
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
