package pos_tagger_executable;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.net.URL;

public class PosTagger extends AsyncTask<Void, Void, Void> {
    private String modelPath;

    public PosTagger() {
        this.modelPath = System.getProperty("user.home") + "/model.bin";
        File file = new File(modelPath);
        if (!file.exists()) {
            this.execute();
        }
    }

    public String getModelPath() {
        return modelPath;
    }

    @Override
    protected Void doInBackground(Void... voids) {
        try {
            URL url = new URL(
                    "https://dlcdn.apache.org/opennlp/models/ud-models-1.0/opennlp-en-ud-ewt-pos-1.0-1.9.3.bin");
            File file = new File(modelPath);
            FileUtils.copyURLToFile(url, file);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
