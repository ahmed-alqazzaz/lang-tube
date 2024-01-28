package com.example.pos_tagger;

import android.util.Log;
import opennlp.tools.postag.POSModel;
import opennlp.tools.postag.POSTaggerME;
import opennlp.tools.tokenize.WhitespaceTokenizer;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public abstract class PosTagger {
    private static final Map<String, PosTagger> instances = new HashMap<>();

    protected String langCode;

    protected PosTagger(String langCode) {
        this.langCode = langCode;
    }

    public abstract void evaluate(String sentence);

    public static synchronized PosTagger getInstance(String langCode) {
        if (!instances.containsKey(langCode)) {
            PosTagger instance = new PosTaggerImpl(langCode, "/Users/snonosystems/Projects/lang-tube/packages/pos_tagger/android/src/main/java/com/example/pos_tagger");
            instances.put(langCode, instance);
        }
        return instances.get(langCode);
    }
}


