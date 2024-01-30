package com.example.pos_tagger;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
    public List<List<String>> evaluate(String sentence) {
        POSTaggerME posTagger = new POSTaggerME(posModel);
        String[] tokens = WhitespaceTokenizer.INSTANCE.tokenize(sentence);
        String[] tags = posTagger.tag(tokens);

        List<List<String>> wordTagList = new ArrayList<>();
        for (int i = 0; i < tokens.length; i++) {
            System.out.print("putting " + tokens[i] + "  " + tags[i] + "\n");
            wordTagList.add(Arrays.asList(tokens[i], tags[i]));
        }

        return wordTagList;
    }

}
