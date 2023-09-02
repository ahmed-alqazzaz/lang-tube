const elementSelectors = 'p, h1, h2, h3, h4, h5, h6';
const skipElements = ['iframe', 'img', 'audio', 'video', 'br', 'hr', 'input', 'button', 'select', 'textarea', 'svg', 'canvas', 'link', 'meta', 'style', 'script'];
const idAttribute = 'unique-wordspan-id';

let uniqueIdCounter = 0;

window.addEventListener('DOMContentLoaded', () => {
    console.log("loaded");
    return document.querySelectorAll(elementSelectors).forEach(wordsSpanifier);
});

// Function to wrap words in elements
function wordsSpanifier(element) {
    const nodes = Array.from(element.childNodes);

    // Clear existing content
    element.innerHTML = '';

    nodes.forEach(node => {
        // Check if the node is an element that should be skipped
        if (node.nodeType === Node.ELEMENT_NODE && skipElements.includes(node.tagName.toLowerCase())) {
            return;
        }
        if (node.nodeType === Node.TEXT_NODE) {
            const words = node.textContent.split(' ');
            try {
                words.forEach((word, index) => {
                    const uniqueId = `word-${uniqueIdCounter++}`; // Generate a unique ID and increment the counter
                    const span = document.createElement('span');
                    span.textContent = word;
                    span.style.cursor = 'pointer';
                    span.style.backgroundColor = 'transparent'; // Set initial background color
                    span.setAttribute(idAttribute, uniqueId); // Set the unique ID as a data attribute
                    span.addEventListener('click', onTap);
                    element.appendChild(span);
    
                    if (index < words.length - 1) {
                        // Add a space between words
                        element.appendChild(document.createTextNode(' '));
                    }

                });
            } catch (error) {
                console.log(`an error occured while spanifying.
                 text: ${words},
                 error: ${error},
                `);
            }
           
        } else {
            // If the node is not a text node, append it as is
            const clonedNode = node.cloneNode(true);
            element.appendChild(clonedNode);
            wordsSpanifier(clonedNode);
            console.log('Appended child:', clonedNode);
        }
    });
}


function onTap(event){
    const boundingRect = event.target.getBoundingClientRect();
    console.log('tapped');
    window.flutter_inappwebview.callHandler(
        'clickedWordHandler',
        {
            'clickedWord': event.target.textContent,
            'id': event.target.getAttribute(idAttribute),
            'boundingRect': {
                top: boundingRect.top,
                right: boundingRect.right,
                bottom: boundingRect.bottom,
                left: boundingRect.left,
                width: boundingRect.width,
                height: boundingRect.height
            }
        }
       );
  
  }
  
function highglightWord(id, backgroundColor, textColor){
    console.log(id)
    const span = document.querySelector(`[${idAttribute}="${id}"]`);
    span.style.backgroundColor = backgroundColor;
    span.style.color = textColor;
}

function removeHighlight(id) {
    const span = document.querySelector(`[${idAttribute}="${id}"]`);
    
    if (span) {
        span.style.backgroundColor = 'transparent'; // Reset background color
        span.style.color = ''; // Reset text color to default (empty string)
    }
}

function removeAllHighlights() {
    for (let i = 0; i < uniqueIdCounter; i++) {
        const uniqueId = `word-${i}`;
        removeHighlight(uniqueId);
    }
}
