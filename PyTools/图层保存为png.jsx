// in case we double clicked the file
app.bringToFront();

// debug level: 0-2 (0:disable, 1:break on error, 2:break at beginning)
// $.level = 0;
// debugger; // launch debugger on next line

// on localized builds we pull the $$$/Strings from a .dat file, see documentation for more details
$.localize = true;

//var docName = app.activeDocument.name;
//app.activeDocument = app.documents[docName];
var doc = app.activeDocument;
var filePath = app.activeDocument.path.fsName;
var doc = app.activeDocument.duplicate();
var layers = doc.layers;

for (var i = 0; i < layers.length; i++) {

        closeAllLayer ();
        var layer = layers[i];
        layer.visible = true;
        save (layer.name);
    }
doc.close(SaveOptions.DONOTSAVECHANGES);
alert ("finish");

// 关闭所有图层
function closeAllLayer() {
    for (var i = 0; i < doc.artLayers.length; i++) {
        doc.artLayers[i].visible = false;
    }
    for (var i = 0; i < doc.layers.length; i++) {
        doc.layers[i].visible = false;
    }
    for (var i = 0; i < doc.layerSets.length; i++) {
        var set = doc.layerSets[i];
        for (var j = 0; j < set.layers.length; j++) {
            set.layers[j].visible = false;
        }
    }
}
// 保存为png文件
function save (fileName) {
    // alert ("save -> " + fileName);
   
    var saveOptions = new PNGSaveOptions();
    saveOptions.interlaced = true;
   
    var path = filePath+"/" + fileName;
   
    doc.saveAs (new File(path), saveOptions, true, Extension.LOWERCASE);
}