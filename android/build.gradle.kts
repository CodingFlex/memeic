allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Fix namespace for Flutter plugins that don't have it set (required for AGP 8+)
// Apply to all projects, including Flutter plugins loaded dynamically
allprojects {
    plugins.withId("com.android.library") {
        // Configure namespace immediately when plugin is applied
        val manifestFile = project.file("src/main/AndroidManifest.xml")
        if (manifestFile.exists()) {
            try {
                val manifestText = manifestFile.readText()
                val packageMatch = Regex("package=[\"']([^\"']+)[\"']").find(manifestText)
                packageMatch?.groupValues?.get(1)?.let { packageName ->
                    project.afterEvaluate {
                        extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                            // Only set if not already set
                            if (namespace.isNullOrBlank()) {
                                namespace = packageName
                            }
                        }
                    }
                    // Also try to set it immediately (before afterEvaluate)
                    try {
                        extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                            namespace = packageName
                        }
                    } catch (e: Exception) {
                        // Extension might not be ready yet, afterEvaluate will handle it
                    }
                }
            } catch (e: Exception) {
                // Ignore errors
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
