import org.gradle.internal.impldep.bsh.commands.dir

android {
    namespace = "com.applovin.godot"
    compileSdk = 34

    defaultConfig {
//        applicationId = "com.slabgames.applovinmaxgodot"
        minSdk = 24
        targetSdk = 34
//        versionCode = 1
//        versionName = "1.0"

        testInstrumentationRunner = "android.support.test.runner.AndroidJUnitRunner"

    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

//    compileSdkVersion(libraryVersions["compileSdk"] as Int)

    defaultConfig {
//        minSdkVersion(libraryVersions["minSdk"] as Int)

        consumerProguardFiles("proguard-rules.pro")

//        buildConfigField("String", "VERSION_NAME", "\"${libraryVersionName}\"")
//        buildConfigField("int", "VERSION_CODE", libraryVersionCode.toString())+
        android.buildFeatures.buildConfig = true
    }

    flavorDimensions("default")
    productFlavors {
        // Flavor when building Unity Plugin as a standalone product
        create("standalone") {
            buildConfigField("boolean", "IS_TEST_APP", "false")
            dimension = "default"
        }
        // Flavor from the test app
        create("app") {
            buildConfigField("boolean", "IS_TEST_APP", "true")
        }
    }
    buildToolsVersion = "34.0.0"

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
        }
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

dependencies {

    implementation("com.android.support:appcompat-v7:28.0.0")
    implementation("com.applovin:applovin-sdk:13.3.1")
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("com.android.support.test:runner:1.0.2")
    androidTestImplementation("com.android.support.test.espresso:espresso-core:3.0.2")

    // AppLovin Workspace SDK
    if (file("../../AppLovin-MAX-SDK-Android/Android-SDK/build.gradle.kts").exists()) {
        compileOnly(project(":Android-SDK"))
    } else {
//        compileOnly("com.applovin:applovin-sdk:+")
//        compileOnly(files("./libs/applovin-sdk-13.0.1.aar"))
    }

    // Godot Engine
    // compileOnly("org.godotengine.godot:godot-lib:+@aar")
    compileOnly(files("./libs/godot-lib.3.6.stable.release.aar"))
//    compileOnly(files("./libs/applovin-sdk-13.0.1-sources"))
}


plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
//    id("applovin-quality-service")
}

//applovin {
//    apiKey = "«your-ad-review-key»"
//}

private val versionMajor = 1
private val versionMinor = 0
private val versionPatch = 3

var libraryVersionName by extra("${versionMajor}.${versionMinor}.${versionPatch}")
var libraryVersionCode by extra((versionMajor * 10000) + (versionMinor * 100) + versionPatch)
var libraryArtifactId by extra("applovin-max-godot-plugin")
var libraryArtifactName by extra("${libraryArtifactId}-${libraryVersionName}.aar")

//var libraryVersions = rootProject.extra["versions"] as Map<*, *>


repositories {
//    mavenCentral()

//    flatDir {
//        dirs("libs")
//    }
}