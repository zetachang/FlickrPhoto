/*
 * Jakefile
 * FlickrPhoto
 *
 * Created by You on April 30, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

var ENV = require("system").env,
    FILE = require("file"),
    JAKE = require("jake"),
    task = JAKE.task,
    FileList = JAKE.FileList,
    app = require("cappuccino/jake").app,
    configuration = ENV["CONFIG"] || ENV["CONFIGURATION"] || ENV["c"] || "Debug",
    OS = require("os");

app ("FlickrPhoto", function(task)
{
    task.setBuildIntermediatesPath(FILE.join("Build", "FlickrPhoto.build", configuration));
    task.setBuildPath(FILE.join("Build", configuration));

    task.setProductName("FlickrPhoto");
    task.setIdentifier("com.yourcompany.FlickrPhoto");
    task.setVersion("1.0");
    task.setAuthor("Your Company");
    task.setEmail("feedback @nospam@ yourcompany.com");
    task.setSummary("FlickrPhoto");
    task.setSources((new FileList("**/*.j")).exclude(FILE.join("Build", "**")));
    task.setResources(new FileList("Resources/**"));
    task.setIndexFilePath("index.html");
    task.setInfoPlistPath("Info.plist");
    task.setNib2CibFlags("-R Resources/");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});

task ("default", ["FlickrPhoto"], function()
{
    printResults(configuration);
});

task ("build", ["default"]);

task ("debug", function()
{
    ENV["CONFIGURATION"] = "Debug";
    JAKE.subjake(["."], "build", ENV);
});

task ("release", function()
{
    ENV["CONFIGURATION"] = "Release";
    JAKE.subjake(["."], "build", ENV);
});

task ("run", ["debug"], function()
{
    OS.system(["open", FILE.join("Build", "Debug", "FlickrPhoto", "index.html")]);
});

task ("run-release", ["release"], function()
{
    OS.system(["open", FILE.join("Build", "Release", "FlickrPhoto", "index.html")]);
});

task ("deploy", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Deployment", "FlickrPhoto"));
    OS.system(["press", "-f", FILE.join("Build", "Release", "FlickrPhoto"), FILE.join("Build", "Deployment", "FlickrPhoto")]);
    printResults("Deployment")
});

task ("desktop", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Desktop", "FlickrPhoto"));
    require("cappuccino/nativehost").buildNativeHost(FILE.join("Build", "Release", "FlickrPhoto"), FILE.join("Build", "Desktop", "FlickrPhoto", "FlickrPhoto.app"));
    printResults("Desktop")
});

task ("run-desktop", ["desktop"], function()
{
    OS.system([FILE.join("Build", "Desktop", "FlickrPhoto", "FlickrPhoto.app", "Contents", "MacOS", "NativeHost"), "-i"]);
});

function printResults(configuration)
{
    print("----------------------------");
    print(configuration+" app built at path: "+FILE.join("Build", configuration, "FlickrPhoto"));
    print("----------------------------");
}
