package com.example.flutter_image_clipboard
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import android.net.Uri

/** FlutterImageClipboardPlugin */
class FlutterImageClipboardPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "clipboard_image")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "copyImageToClipboard") {
            val args = call.arguments as? Map<String, Any>
            val path = args?.get("path") as? String
            if (!path.isNullOrBlank()) {
                try {
                    val imageFile = File(path)
                    if (imageFile.exists()) {
                        val fis = FileInputStream(imageFile)
                        val bitmap = BitmapFactory.decodeStream(fis)
                        fis.close()

                        copyImageToClipboard(bitmap)
                        result.success(null)
                    } else {
                        result.error("UNAVAILABLE", "Image file does not exist", null)
                    }
                } catch (e: IOException) {
                    result.error("UNAVAILABLE", "Failed to read image", null)
                }
            } else {
                result.error("INVALID_ARGUMENT", "Path argument is missing or empty", null)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun copyImageToClipboard(bitmap: Bitmap) {
        val clipboard = applicationContext.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val uri = saveImageToCache(bitmap)
        val clip = ClipData.newUri(applicationContext.contentResolver, "image", uri)
        clipboard.setPrimaryClip(clip)
    }

    private fun saveImageToCache(bitmap: Bitmap): Uri {
        val cachePath = File(applicationContext.cacheDir, "images")
        cachePath.mkdirs()
        val file = File(cachePath, "image.png")
        val fos = FileOutputStream(file)
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos)
        fos.close()
        return FileProvider.getUriForFile(applicationContext, "${applicationContext.packageName}.fileprovider", file)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
