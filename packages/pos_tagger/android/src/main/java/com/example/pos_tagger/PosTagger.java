package com.example.pos_tagger;

import android.util.Log;
import opennlp.tools.postag.POSModel;
import opennlp.tools.postag.POSTaggerME;
import opennlp.tools.tokenize.WhitespaceTokenizer;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

public abstract class PosTaggerInterface {
    protected static final String MODEL_URL = "https://dlcdn.apache.org/opennlp/models/ud-models-1.0/opennlp-en-ud-ewt-pos-1.0-1.9.3.bin";
    protected POSModel posModel;
    private static PosTagger instance;

    protected abstract void loadModel() throws IOException;
    public abstract void evaluate(String sentence);

    public static synchronized PosTagger getInstance() {
        if (instance == null) {
            instance = new PosTagger();
        }
        return instance;
    }
}

public class PosTagger extends AbstractPosTagger {

    @Override
    protected void loadModel() throws IOException {
        URL modelUrl = new URL(MODEL_URL);
        InputStream modelInputStream = modelUrl.openStream();
        posModel = new POSModel(modelInputStream);
        modelInputStream.close();
    }

    @Override
    public void evaluate(String sentence) {
        // Create a POSTaggerME object
        POSTaggerME posTagger = new POSTaggerME(posModel);

        // Tokenize the sentence
        String[] tokens = WhitespaceTokenizer.INSTANCE.tokenize(sentence);

        // Tag the tokens
        String[] tags = posTagger.tag(tokens);

        // Print the tokens and their tags
        for (int i = 0; i < tokens.length; i++) {
            Log.i("Tag", tokens[i] + "/" + tags[i]);
        }
    }
}
