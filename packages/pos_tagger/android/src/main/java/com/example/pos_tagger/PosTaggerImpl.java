package com.example.pos_tagger;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import opennlp.tools.postag.POSModel;
import opennlp.tools.postag.POSTaggerME;
import opennlp.tools.tokenize.WhitespaceTokenizer;

public class PosTaggerImpl extends PosTagger {

    protected POSModel posModel;
    private boolean isModelLoaded = false;

    protected PosTaggerImpl(String modelPath) {
        try {
            loadModel(modelPath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void loadModel(String modelPath) throws IOException {
        assert !isModelLoaded : "The model has already been loaded.";
        File modelFile = new File(modelPath);
        if (!modelFile.exists()) {
            throw new FileNotFoundException("Model file does not exist: " + modelPath);
        }
        if (!modelFile.canRead()) {
            throw new IOException("Read permission is denied for the model file: " + modelPath);
        }
        InputStream modelInputStream = new FileInputStream(modelFile);
        posModel = new POSModel(modelInputStream);

        isModelLoaded = true;
    }

    @Override
    public String[] evaluate(String sentence) {
        POSTaggerME posTagger = new POSTaggerME(posModel);
        String[] tokens = WhitespaceTokenizer.INSTANCE.tokenize(sentence);
        return posTagger.tag(tokens);
    }
}

//public class PosTaggerImpl extends PosTagger {
//    protected static final Map<String, String> MODEL_URLS = new HashMap<String, String>() {
//        {
//            put("en",
//                    "https://opennlp.sourceforge.net/models-1.5/en-pos-perceptron.bin");
//        }
//    };
//    protected POSModel posModel;
//    private boolean isModelLoaded = false;
//
//    protected PosTaggerImpl(String langCode, String cacheDirPath) {
//        super(langCode);
//        try {
//            loadModel(cacheDirPath);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//
//    private void loadModel(String cacheDirPath) throws IOException {
//        assert MODEL_URLS.containsKey(langCode) : "The language code does not exist in the model URLs.";
//        assert !isModelLoaded : "The model has already been loaded.";
//
//        File cacheDir = new File(cacheDirPath);
//        File modelFile = new File(cacheDir, langCode + "2" + ".bin");
//
//        if (!modelFile.exists()) {
//            URL modelUrl = new URL(MODEL_URLS.get(langCode));
//            try (InputStream modelInputStream = modelUrl.openStream();
//                    ReadableByteChannel readableByteChannel = Channels.newChannel(modelInputStream);
//                    FileOutputStream fileOutputStream = new FileOutputStream(modelFile)) {
//
//                fileOutputStream.getChannel().transferFrom(readableByteChannel, 0,
//                        Long.MAX_VALUE);
//            }
//        }
//
//        try (InputStream modelInputStream = new FileInputStream(modelFile)) {
//            posModel = new POSModel(modelInputStream);
//        }
//
//        isModelLoaded = true;
//    }
//
//    @Override
//    public void evaluate(String sentence) {
//        POSTaggerME posTagger = new POSTaggerME(posModel);
//        String[] tokens = WhitespaceTokenizer.INSTANCE.tokenize(sentence);
//        String[] tags = posTagger.tag(tokens);
//
//        // Print the tokens and their tags
//        for (int i = 0; i < tokens.length; i++) {
//            Log.i("Tag: ", tokens[i] + "/ " + tags[i] + "/n");
//        }
//    }
//}
