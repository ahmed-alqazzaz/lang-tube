package helloworld

import java.io.InputStream
import opennlp.tools.postag.POSModel
import opennlp.tools.postag.POSTaggerME
import opennlp.tools.tokenize.WhitespaceTokenizer

class App {
    val greeting: String
        get() {
            return "Hello World!"
        }
}

fun main() {
    println(App().greeting)

    // Load the POS model
    val modelInputStream: InputStream =
            {}.javaClass.getResourceAsStream("/opennlp-en-ud-ewt-pos-1.0-1.9.3.bin")
    val posModel = POSModel(modelInputStream)

    // Create a POSTaggerME object
    val posTagger = POSTaggerME(posModel)

    // Tokenize the sentence
    val sentence = "The quick brown fox jumps over the lazy dog."
    val tokens = WhitespaceTokenizer.INSTANCE.tokenize(sentence)

    // Tag the tokens
    val tags = posTagger.tag(tokens)

    // Print the tokens and their tags
    tokens.zip(tags).forEach { (token, tag) -> println("$token/$tag") }
}
