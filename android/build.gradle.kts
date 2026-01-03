buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // هذا السطر ضروري جداً لتشغيل خدمات جوجل وفيربيز
        classpath("com.google.gms:google-services:4.4.0")
        
        // تأكدي أن هذا السطر موجود أيضاً (قد يختلف الإصدار لديكِ قليلاً)
        classpath("com.android.tools.build:gradle:8.1.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// إعدادات مجلد الـ Build
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}