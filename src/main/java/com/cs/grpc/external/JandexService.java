package com.cs.grpc.external;

/**
 * Created by Santosh Choudhary on 2024-10-27.
 */

import jakarta.enterprise.context.ApplicationScoped;
import org.jboss.jandex.ClassInfo;
import org.jboss.jandex.DotName;
import org.jboss.jandex.IndexView;
import jakarta.enterprise.inject.spi.CDI;


import java.util.List;
import java.util.stream.Collectors;


@ApplicationScoped
public class JandexService {

    public List<Class<?>> findEnumsImplementing(Class<?> interfaceClass) {
        // Access the Jandex index provided by Quarkus
        IndexView index = CDI.current().getBeanManager().getExtension(org.jboss.jandex.IndexView.class);

        // Use Jandex to find all implementors of the interface
        List<ClassInfo> implementors = index.getAllKnownImplementors(DotName.createSimple(interfaceClass.getName())).stream().toList();

        // Filter the results to include only enums
        return implementors.stream()
                .filter(classInfo -> classInfo.isEnum())
                .map(classInfo -> {
                    try {
                        return Class.forName(classInfo.name().toString());
                    } catch (ClassNotFoundException e) {
                        throw new RuntimeException(e);
                    }
                })
                .collect(Collectors.toList());
    }
}

