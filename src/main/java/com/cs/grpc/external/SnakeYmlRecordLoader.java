package com.cs.grpc.external;

import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.nodes.MappingNode;
import org.yaml.snakeyaml.nodes.Node;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.ScalarNode;

import java.io.InputStream;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Created by Santosh Choudhary on 2024-10-25.
 */
public class SnakeYmlRecordLoader {
    public static void main(String[] args) throws Exception {
        // Custom constructor that knows how to construct records
        Yaml yaml = new Yaml(new RecordConstructor(new LoaderOptions()));

        // Load the YAML file as an InputStream
        InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("data.yml");

        // Load the YAML data into a Map<String, MyRecord>
        Map<String, MyRecord> records = yaml.load(inputStream);

        // Output the loaded data
        records.forEach((key, value) -> {
            System.out.println("Key: " + key);
            System.out.println("Value: Name: " + value.name() + ", Age: " + value.age());
        });
    }
}

record MyRecord(String name, Integer age) {
}

class RecordConstructor extends org.yaml.snakeyaml.constructor.Constructor {

    public RecordConstructor(LoaderOptions loadingConfig) {
        super(loadingConfig);
    }

    @Override
    protected Object constructObject(Node node) {
        if (node.getType().isRecord()) {
            return constructRecord(node);
        }
        return super.constructObject(node);
    }

    private Object constructRecord(Node node) {
        try {
            Class<?> recordClass = node.getType();
            var constructor = recordClass.getDeclaredConstructors()[0]; // Use the single record constructor

            // Extract values from YAML and map them to constructor parameters
            Map<String, Object> values = extractValues((MappingNode) node);
            Object[] parameters = Arrays.stream(recordClass.getRecordComponents())
                    .map(comp -> values.get(comp.getName()))
                    .toArray();

            return constructor.newInstance(parameters); // Instantiate the record
        } catch (Exception e) {
            throw new RuntimeException("Failed to construct record", e);
        }
    }

    private Map<String, Object> extractValues(MappingNode node) {
        Map<String, Object> values = new LinkedHashMap<>();
        for (NodeTuple tuple : node.getValue()) {
            String key = ((ScalarNode) tuple.getKeyNode()).getValue();
            Object value = constructObject(tuple.getValueNode());
            values.put(key, value);
        }
        return values;
    }

}

