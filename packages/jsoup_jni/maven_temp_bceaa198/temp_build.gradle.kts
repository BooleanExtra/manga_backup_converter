    plugins {
        java
    }
    
    repositories {
        mavenCentral()
        google()
    }
    
    java {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    tasks.register<Copy>("copyJars") {
      from(configurations.runtimeClasspath)
      into("B:\\dev\\GitHub\\manga_backup_converter\\packages\\jsoup_jni\\mvn_java")
    }

    tasks.register<Copy>("extractSourceJars") {
      duplicatesStrategy = DuplicatesStrategy.INCLUDE
      val sourcesDir = fileTree("B:\\dev\\GitHub\\manga_backup_converter\\packages\\jsoup_jni\\mvn_java")
      sourcesDir.forEach {
        if (it.name.endsWith(".jar")) {
          from(zipTree(it))
          into("B:\\dev\\GitHub\\manga_backup_converter\\packages\\jsoup_jni\\mvn_java")
        }
      }      
      from(configurations.runtimeClasspath)
      into("B:\\dev\\GitHub\\manga_backup_converter\\packages\\jsoup_jni\\mvn_java")
    }
    
    dependencies {
        implementation("org.jsoup:jsoup:1.18.3")
    }