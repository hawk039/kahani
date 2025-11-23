// Root-level build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.2.1") // make sure this matches your AGP
        classpath("com.google.gms:google-services:4.4.2")  // Firebase plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: your custom build directories
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
