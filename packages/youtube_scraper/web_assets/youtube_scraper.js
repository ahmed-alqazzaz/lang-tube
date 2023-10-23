const YOUTUBE_LOGO_QUERY =  'ytm-home-logo';
const TAB_CONTAINER_QUERY = 'div.chip-container';
const VIDEO_ITEM_QUERY = 'ytm-media-item';
const ITEM_DETAILS_QUERY = 'div.details';
const ITEM_TITLE_QUERY = 'h3.media-item-headline';
const ITEM_BADGES_QUERY = 'ytm-badge-and-byline-renderer';
const THUMBNAIL_QUERY = 'a.media-item-thumbnail-container';
const ITEM_DURATION_QUERY = 'ytm-thumbnail-overlay-time-status-renderer';
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
  console.log(`recommended videos length ${videoItemsData.length}`);
  return JSON.stringify(videoItemsData);
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
        // observedVideosError Invalid argument (urlOrUrl): Invalid YouTube video ID or URL: "RS7IzU2VJIQ&t=15s"
        return console.log(`click video by Id input must match ${VIDEO_ITEM_QUERY}`);
      }
    }
    console.log(`Requested id ${id} is not within the current page: pushing state manually`);
    window.history.pushState(null, null, `/watch?v=${id}`);
    return window.dispatchEvent(new PopStateEvent('popstate'));
  }
  console.log(`click video by url input must be a string`);

}
function clickTabByName(tabName) {
  document.querySelectorAll(TAB_CONTAINER_QUERY).forEach(tab => {
    if (tab.textContent.toLowerCase() === tabName.toLowerCase()) {
      tab.scrollIntoView({ behavior: 'smooth' });
      return sleep(1200).then(() => {
        return tab.click();
      })
      
    }
    console.log(`tab name: ${tabName} is not available`);
  });
}

function getSelectedTab() {
  const tabs = document.querySelectorAll(TAB_CONTAINER_QUERY);

  for (let i = 1; i < tabs.length; i++) {
    const tab = tabs[i];
    const parentElement = tab.parentElement;
    if (parentElement && parentElement.ariaSelected === 'true') {
      return tab.textContent;
    }
  }

  return null;
}

const getTabs = () =>
  Array.from(document.querySelectorAll(TAB_CONTAINER_QUERY)).slice(1).map(
    element => element.textContent
  );
const isDocumentFullyLoaded = () => document.readyState === "complete";
const scrollToBottom = () => window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
const currentUrl = () => window.location.href;
const navigateBack = () => window.history.back();
const navigateHome = () => document.querySelector(YOUTUBE_LOGO_QUERY).firstElementChild.click();


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
    const videoUrl = getVideoUrl(videoThumbnail);
    
    if(videoThumbnail && videoDetails  && videoChannelIcon && !videoUrl.includes('shorts')){
      const videoItemJson = {
        'element': videoItem,
        'id': getVideoId(videoUrl),
        'title': getVideoTitle(videoDetails),
        'badges': getVideoBadges(videoDetails),
        'channelIconUrl': getFirstImageUrlFromElement(videoChannelIcon),
        'thumbnailUrl': getFirstImageUrlFromElement(videoThumbnail),
        'duration': getVideoDuration(videoItem),
        'sourceTab' : getSelectedTab()
      };
      VIDEO_ITEMS_LIST.push(videoItemJson);
    }
    
  }
  return VIDEO_ITEMS_LIST;
}

function getVideoUrl(element){
  if (element instanceof Element) {
    if (element.matches(THUMBNAIL_QUERY)) {
      return element.getAttribute('href');
    }
    return console.log(`get video url input must match ${THUMBNAIL_QUERY}`);
  }
  console.log(`get video url input must be an Element`);
}
// Unhandled Exception: Invalid argument (urlOrUrl): Invalid YouTube video ID or URL: "LBudghsdByQ&pp=ygULa3VyeiBnZXNhZ3Q%3D"

function getVideoId(url) {
  const id = url.split('watch?v=')[1]
  if(id === undefined){
    console.log(`anomaly ${url}`);
  }
  if(id.includes('&')){   
    return id.split('&')[0]; 
  }
  return id;
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

function getVideoDuration(element){
  if (element instanceof Element) {
    if (element.matches(VIDEO_ITEM_QUERY)) {
      return element.querySelector(ITEM_DURATION_QUERY).textContent;
    }
    return console.log(`get video duration input must match ${VIDEO_ITEM_QUERY}`);
  }
  console.log(`get video duration input must be an Element`);
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
      return element.querySelector(THUMBNAIL_QUERY);
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



function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
