// Function to log the clicked word, its bounding rect, and its unique ID
function logWord(event) {
    const word = event.target.textContent;
    const boundingRect = event.target.getBoundingClientRect();
    const uniqueId = event.target.getAttribute('data-id'); // Get the unique ID

    console.log('Clicked word:', word);
    console.log('Bounding rect:', boundingRect);
    console.log('Unique ID:', uniqueId);

    event.target.style.backgroundColor = 'purple'; // Change background color to purple
    event.target.style.color = 'white'; // Change text color to white for better visibility
}

// Function to wrap words in elements
function wrapWordsInElements(element) {
    const nodes = Array.from(element.childNodes);

    // Clear existing content
    element.innerHTML = '';

    nodes.forEach(node => {
        // Check if the node is an element that should be skipped
        if (node.nodeType === Node.ELEMENT_NODE && shouldSkipElement(node)) {
            // If it's an element in the skip list, skip it and continue to the next node
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
                    span.setAttribute('data-id', uniqueId); // Set the unique ID as a data attribute
                    span.addEventListener('click', logWord);
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
            wrapWordsInElements(clonedNode);
            console.log('Appended child:', clonedNode);
        }
    });
}

// Initialize a counter for generating unique IDs
let uniqueIdCounter = 0;

// Function to check if an element should be skipped
function shouldSkipElement(element) {
    const skipElements = ['iframe', 'img', 'audio', 'video', 'br', 'hr', 'input', 'button', 'select', 'textarea', 'svg', 'canvas', 'link', 'meta', 'style', 'script'];
    return skipElements.includes(element.tagName.toLowerCase());
}
// Define the list of element selectors
const elementSelectors = 'p, h1, h2, h3, h4, h5, h6';

// Convert each word to a <span> element with a unique ID while preserving spaces and hyperlinks
const elements = document.querySelectorAll(elementSelectors);

// Call the function to wrap words in elements
elements.forEach(wrapWordsInElements);
