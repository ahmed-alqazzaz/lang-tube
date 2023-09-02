document.addEventListener('mouseup', function(event) {
  clearHighlights();
  const clientX = event.clientX;
  const clientY = event.clientY;
  const clickedWord = getClickedWord(clientX, clientY);
  if (clickedWord) {
    highlightClickedWord(clickedWord, clientX, clientY);
    scrollToFirstQuarter(clickedWord);
    window.flutter_inappwebview.callHandler(
      'clickedWordHandler',
       {
        'clickedWord': clickedWord,
        'clientX': clientX,
        'clientY': clientY,
       }
     
     );
  }
  
});

function clearHighlights() {
  const highlights = document.querySelectorAll('.highlight');
  highlights.forEach(element => {
    element.classList.remove('highlight');
  });
}

function getClickedWord(clientX, clientY) {
  const range = document.caretRangeFromPoint(clientX, clientY);
  const clickedNode = range.startContainer;
  const clickedOffset = range.startOffset;

  if (clickedNode.nodeType === Node.TEXT_NODE) {
    const text = clickedNode.textContent;
    const wordRegex = /\S+/g; // Matches sequences of non-whitespace characters
    let match;
    let clickedWord = '';

    while ((match = wordRegex.exec(text)) !== null) {
      if (match.index <= clickedOffset && wordRegex.lastIndex >= clickedOffset) {
        clickedWord = match[0];
        break;
      }
    }

    return clickedWord;
  }

  return null;
}

function highlightClickedWord(clickedWord, clientX, clientY) {
  const range = document.caretRangeFromPoint(clientX, clientY);
  const clickedNode = range.startContainer;
  const clickedOffset = range.startOffset;
  const text = clickedNode.textContent;
  const start = text.lastIndexOf(' ', clickedOffset) + 1;
  const end = text.indexOf(' ', clickedOffset);
  
  const span = document.createElement('span');
  span.className = 'highlight';
  span.textContent = clickedWord;
  
  const newRange = document.createRange();
  newRange.setStart(clickedNode, start);
  newRange.setEnd(clickedNode, end === -1 ? text.length : end);
  newRange.deleteContents();
  newRange.insertNode(span);
}

const INJECTED_SPACE_CLASS = 'injected-space';
function injectSpaceAtBottom(height) {
  const spaceDiv = document.createElement('div');
  spaceDiv.style.height = height + 'px';
  spaceDiv.classList.add(INJECTED_SPACE_CLASS); // Add the class
  document.body.appendChild(spaceDiv);
}

function removeInjectedSpace() {
  const injectedSpace = document.querySelector('.' + INJECTED_SPACE_CLASS);
  if (injectedSpace) {
    injectedSpace.parentNode.removeChild(injectedSpace);
  }
}
function scrollToFirstQuarter(clickedWord) {
  const span = document.querySelector('.highlight');
  const rect = span.getBoundingClientRect();
  const windowHeight = window.innerHeight;
  const firstQuarter = windowHeight * 0.25;
  
  
  
  if (rect.bottom > firstQuarter) {
    const scrollOffset = rect.bottom - firstQuarter;
    const documentHeight = document.body.scrollHeight;
    const currentScroll = window.scrollY;
    const availableHeight = documentHeight - currentScroll - windowHeight;
    if(availableHeight < scrollOffset){
      injectSpaceAtBottom(availableHeight + scrollOffset)
    }else {
      removeInjectedSpace(); // Remove the injected space if not needed anymore
    }
    
    window.scrollBy({
      top: scrollOffset,
      behavior: 'smooth',
    });
  }
  return;
}

