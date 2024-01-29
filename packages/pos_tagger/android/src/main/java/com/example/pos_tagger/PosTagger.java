package com.example.pos_tagger;

import java.util.HashMap;
import java.util.Map;

public abstract class PosTagger {
    private static final Map<String, PosTagger> instances = new HashMap<>();



    public abstract String[] evaluate(String sentence);

    public static synchronized PosTagger getInstance(String modelPath) {
        if (!instances.containsKey(modelPath)) {
            PosTagger instance = new PosTaggerImpl(modelPath);
            instances.put(modelPath, instance);
        }
        return instances.get(modelPath);
    }
}


