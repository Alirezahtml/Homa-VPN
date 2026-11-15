package com.arman.firefoxvpn

import android.content.Context
import android.os.Build
import android.util.Log
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Keeps this process's Java crashes in the app's own files
 * (crash-log.txt): the core's log does not carry them, and a phone's
 * "keeps stopping" dialog says nothing about where the crash came
 * from. A few crashes survive in the file; the system's own dialog
 * goes on as before. The app's logs page reads the file through the
 * "crashLog" channel call, so a crash report can name the line.
 */
object CrashLog {
    private const val FILE = "crash-log.txt"

    /** The file holds a few crashes, not the whole history. */
    private const val MAX_BYTES = 64 * 1024

    @Volatile
    private var installed = false

    /** Installs the handler once per process. Safe to call again. */
    fun install(context: Context) {
        if (installed) return
        installed = true
        val app = context.applicationContext
        val previous = Thread.getDefaultUncaughtExceptionHandler()
        Thread.setDefaultUncaughtExceptionHandler { thread, throwable ->
            try {
                append(app, thread, throwable)
            } catch (e: Exception) {
                Log.w("CrashLog", "writing the crash log failed", e)
            }
            // The system's dialog, and whatever the platform had.
            previous?.uncaughtException(thread, throwable)
        }
    }

    /** The file's text, or "" while it has none. */
    fun read(context: Context): String {
        val file = File(context.filesDir, FILE)
        if (!file.isFile) return ""
        return runCatching { file.readText() }.getOrDefault("")
    }

    private fun append(context: Context, thread: Thread, throwable: Throwable) {
        val file = File(context.filesDir, FILE)
        val stamps = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(Date())
        val entry =
            "\n----- $stamps (Android ${Build.VERSION.RELEASE}, API ${Build.VERSION.SDK_INT}) -----\n" +
                "thread: ${thread.name}\n" +
                Log.getStackTraceString(throwable)
        var kept = if (file.isFile) runCatching { file.readText() }.getOrDefault("") else ""
        if (kept.length + entry.length > MAX_BYTES) {
            // The head gives way: the newest crashes stay whole.
            kept = kept.substring((kept.length - MAX_BYTES / 2).coerceAtLeast(0))
            val at = kept.indexOf("\n----- ")
            if (at > 0) kept = kept.substring(at)
        }
        file.writeText(kept + entry)
    }
}
