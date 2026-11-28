package com.arman.firefoxvpn

import android.Manifest
import android.app.ActivityManager
import android.app.AppOpsManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.usage.NetworkStats
import android.app.usage.NetworkStatsManager
import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.WindowManager
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executor
import java.util.concurrent.Executors
import android.net.Uri
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.VpnService
import android.os.Build
import android.os.PowerManager
import android.os.Process
import android.provider.OpenableColumns
import android.provider.Settings
import android.service.quicksettings.TileService
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import androidx.core.content.FileProvider
import androidx.webkit.ProxyConfig
import androidx.webkit.ProxyController
import androidx.webkit.WebViewFeature
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/**
 * The Flutter UI. Channel "app/android": dataDir, startCore (with the proxy
 * off), setOn, isRunning, openUrl. The UI talks to the core itself through
 * its HTTP API on loopback, as on the desktop.
 */
class MainActivity : FlutterActivity() {
    private var androidChannel: MethodChannel? = null
    /** Waits for the user's answer to the VPN permission. */
    private var pendingOn: Result? = null
    // A backup waiting for the place the user picks to save it.
    private var pendingSave: Pair<ByteArray, Result>? = null
    // A backup being picked to open.
    private var pendingOpen: Result? = null
    // A launcher shortcut tapped before the app could hear.
    private var pendingShortcut: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        holdPhoneUpright(resources.configuration)
        super.onCreate(savedInstanceState)
        removeOtherCards()
        takeShortcut(intent)
    }



    /** A tile long-press returns an already open UI to its home page. */
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        if (intent.action == TileService.ACTION_QS_TILE_PREFERENCES) {
            androidChannel?.invokeMethod("openHome", null)
        }
        takeShortcut(intent)
    }

    /** A launcher shortcut's country: handed to the app once it can hear. */
    private fun takeShortcut(intent: Intent?) {
        val country = intent?.getStringExtra("shortcut_country") ?: return
        if (country.isEmpty()) return
        val channel = androidChannel
        if (channel != null) {
            channel.invokeMethod("openShortcut", mapOf("country" to country))
        } else {
            pendingShortcut = country
        }
    }

    /**
     * One card in the recent apps. A card stays there after Back, and with no
     * task affinity (the manifest's, against task hijacking) Android keeps it
     * beside a new task opened with another intent: from the notification,
     * the tile, the widget, or the installer's Open.
     */
    private fun removeOtherCards() {
        for (task in getSystemService(ActivityManager::class.java).appTasks) {
            try {
                @Suppress("DEPRECATION") // taskId came only with Android 10.
                if (task.taskInfo.persistentId != taskId) task.finishAndRemoveTask()
            } catch (e: IllegalArgumentException) {
                // That task went by itself meanwhile.
            }
        }
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        holdPhoneUpright(newConfig)
    }

    /**
     * A phone stays upright (its layout is made for it); a tablet, whose
     * shorter side is 600 dp or more, turns freely. Asked again when the
     * screen changes, so a foldable follows its folding. A TV (960 x 540 dp,
     * so "short" too) cannot turn: it keeps its own orientation.
     */
    private fun holdPhoneUpright(config: Configuration) {
        val wanted = if (config.smallestScreenWidthDp < 600 && !isTv(config)) {
            ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        } else {
            ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
        }
        if (requestedOrientation != wanted) requestedOrientation = wanted
    }

    /** Whether this is a TV (Android TV, Google TV), worked with a remote. */
    private fun isTv(config: Configuration) =
        config.uiMode and Configuration.UI_MODE_TYPE_MASK == Configuration.UI_MODE_TYPE_TELEVISION

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        CrashLog.install(this)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app/android")
        androidChannel = channel
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "dataDir" -> result.success(CoreService.dataDir(this).absolutePath)
                "startCore" -> result.success(CoreService.startCore(this, on = false))
                "dashboardAddress" -> result.success(mobile.Mobile.dashboardAddress())
                "routingEnabled" -> result.success(CoreService.routingEnabled(this))
                "setRoutingEnabled" -> {
                    CoreService.setRoutingEnabled(this, call.argument<Boolean>("on") == true)
                    result.success(null)
                }
                "setOn" -> {
                    if (call.argument<Boolean>("on") != true) {
                        CoreService.turnOff(this)
                        result.success(null)
                    } else {
                        askForNotifications()
                        // The first time, Android asks the user to allow the
                        // VPN; proxy mode needs no VPN.
                        val consent = if (CoreService.usesVpn(this)) VpnService.prepare(this) else null
                        if (consent == null) {
                            turnOn(result)
                        } else {
                            pendingOn?.error("vpn_denied", "superseded", null)
                            pendingOn = result
                            startActivityForResult(consent, VPN_REQUEST)
                        }
                    }
                }
                "isRunning" -> result.success(mobile.Mobile.running())
                "autoConnectBoot" -> result.success(CoreService.autoConnectOnBoot(this))
                "setAutoConnectBoot" -> {
                    CoreService.setAutoConnectOnBoot(this, call.argument<Boolean>("on") == true)
                    result.success(null)
                }
                "lastError" -> result.success(mobile.Mobile.lastError())
                // This process's Java crashes (CrashLog): the logs page
                // shows them, so a crash report can name its line.
                "crashLog" -> result.success(CrashLog.read(this))
                // A newer version, announced on the phone's own bell: the
                // app's side says when (once per release) and what (the
                // title and body in the app's language). The system posts
                // what it may — a permission kept closed stays closed.
                "notifyUpdate" -> {
                    notifyUpdate(
                        call.argument<String>("title") ?: "",
                        call.argument<String>("body") ?: "",
                    )
                    result.success(null)
                }
                "connectionMode" -> result.success(CoreService.connectionMode(this))
                "showSpeed" -> result.success(CoreService.showSpeed(this))
                "setShowSpeed" -> {
                    CoreService.setShowSpeed(this, call.argument<Boolean>("on") == true)
                    result.success(null)
                }
                // The notification's country flag: on (the SVG flag as the
                // card's art, the emoji until it arrives) or off (the
                // country's name alone).
                "notifFlag" -> result.success(CoreService.notifFlag(this))
                "setNotifFlag" -> {
                    CoreService.setNotifFlag(this, call.argument<Boolean>("on") == true)
                    CoreService.poke()
                    result.success(null)
                }
                // The flag's own art, rendered by the UI (its SVG rastered
                // to a rounded PNG), kept for the service's headless
                // refreshes; the service rebuilds its card at once.
                "setFlagBitmap" -> {
                    val code = call.argument<String>("code") ?: ""
                    val bytes = call.argument<ByteArray>("bytes")
                    inBackground(result) {
                        if (bytes != null) CoreService.saveFlagBitmap(this, code, bytes)
                        CoreService.poke()
                        null
                    }
                }
                // The kill switch: with it on, a broken path keeps the VPN
                // up and dark — the traffic is held, nothing leaks — while
                // the app puts the path back.
                "killSwitch" -> result.success(CoreService.killSwitch(this))
                "setKillSwitch" -> {
                    CoreService.setKillSwitch(this, call.argument<Boolean>("on") == true)
                    result.success(null)
                }
                // Android's own, stronger guard: always-on for this VPN and
                // "block connections without VPN" live in the system's page.
                "openVpnSettings" -> {
                    runCatching {
                        startActivity(Intent(Settings.ACTION_VPN_SETTINGS))
                    }.onFailure {
                        runCatching { startActivity(Intent(Settings.ACTION_SETTINGS)) }
                    }
                    result.success(null)
                }
                // Keeps the screen awake while the VPN is on (the setting's
                // flag on this window).
                "setKeepScreenOn" -> {
                    if (call.argument<Boolean>("on") == true) {
                        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    } else {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    }
                    result.success(null)
                }
                "setConnectionMode" -> {
                    val mode = call.argument<String>("mode") ?: CoreService.MODE_VPN
                    // A running proxy switched to the VPN needs the permission
                    // first; the app turns it off and on again to ask.
                    if (CoreService.on && mode == CoreService.MODE_VPN && VpnService.prepare(this) != null) {
                        result.error("vpn_denied", "the VPN is not allowed yet", null)
                    } else {
                        CoreService.setConnectionMode(this, mode)
                        result.success(null)
                    }
                }
                "installedApps" -> inBackground(result) { installedApps() }
                "appIcon" -> {
                    val pkg = call.argument<String>("package") ?: ""
                    inBackground(result) { appIcon(pkg) }
                }
                "appRouting" -> inBackground(result) {
                    // The page shows the region's apps installed since the
                    // last look checked; the VPN takes them at once.
                    if (CoreService.appMode(this) == CoreService.MODE_EXCLUDE &&
                        CoreService.suggest(this, force = true)
                    ) {
                        CoreService.reconnect(this)
                    }
                    mapOf(
                        "mode" to CoreService.appMode(this),
                        "bypass" to CoreService.appSet(this, CoreService.BYPASS).toList(),
                        "only" to CoreService.appSet(this, CoreService.ONLY).toList(),
                        "declined" to CoreService.appSet(this, CoreService.DECLINED).toList(),
                        "region" to CoreService.regionAppList(),
                    )
                }
                "setAppRouting" -> {
                    fun set(key: String) = (call.argument<List<String>>(key) ?: emptyList()).toSet()
                    CoreService.setAppRouting(
                        this,
                        call.argument<String>("mode") ?: CoreService.MODE_EXCLUDE,
                        mapOf(
                            CoreService.BYPASS to set("bypass"),
                            CoreService.ONLY to set("only"),
                            CoreService.DECLINED to set("declined"),
                        ),
                    )
                    if (call.argument<Boolean>("apply") == true) CoreService.reconnect(this)
                    result.success(null)
                }
                // The browser sign-in's WebView goes through the core's
                // sign-in proxy (an address), or straight out again (null).
                // The override covers every WebView of this app, and takes
                // effect once the callback runs.
                "setWebViewProxy" -> {
                    if (!WebViewFeature.isFeatureSupported(WebViewFeature.PROXY_OVERRIDE)) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    val address = call.argument<String>("address")
                    val proxies = ProxyController.getInstance()
                    val done = Runnable { result.success(true) }
                    val onMain = Executor { main.post(it) }
                    if (address.isNullOrEmpty()) {
                        proxies.clearProxyOverride(onMain, done)
                    } else {
                        proxies.setProxyOverride(
                            ProxyConfig.Builder().addProxyRule(address).build(),
                            onMain,
                            done,
                        )
                    }
                }
                // Saves a file (a backup) where the user picks, with the
                // system's own dialog: no storage permission. Answers the
                // file's name, or null when the user backs out.
                "saveFile" -> {
                    val bytes = call.argument<ByteArray>("bytes")
                    if (bytes == null) {
                        result.error("no_data", "nothing to save", null)
                        return@setMethodCallHandler
                    }
                    pendingSave?.second?.success(null)
                    pendingSave = bytes to result
                    val create = Intent(Intent.ACTION_CREATE_DOCUMENT)
                        .addCategory(Intent.CATEGORY_OPENABLE)
                        .setType(call.argument<String>("mime") ?: "application/octet-stream")
                        .putExtra(Intent.EXTRA_TITLE, call.argument<String>("name") ?: "backup")
                    try {
                        startActivityForResult(create, SAVE_REQUEST)
                    } catch (e: ActivityNotFoundException) {
                        pendingSave = null
                        result.error("no_picker", "this device has no file picker", null)
                    }
                }
                // Opens a file (a backup) the user picks, with the system's
                // own dialog, and answers its bytes, or null when the user
                // backs out. It reads to the end: the size a provider
                // reports can be wrong (0 for a file written through it).
                "openFile" -> {
                    pendingOpen?.success(null)
                    pendingOpen = result
                    val open = Intent(Intent.ACTION_OPEN_DOCUMENT)
                        .addCategory(Intent.CATEGORY_OPENABLE)
                        .setType("*/*")
                        .putExtra(Intent.EXTRA_MIME_TYPES, call.argument<List<String>>("mimes")?.toTypedArray())
                    try {
                        startActivityForResult(open, OPEN_REQUEST)
                    } catch (e: ActivityNotFoundException) {
                        pendingOpen = null
                        result.error("no_picker", "this device has no file picker", null)
                    }
                }
                // The phone's main processor type (arm64-v8a, armeabi-v7a, ...).
                "abi" -> result.success(Build.SUPPORTED_ABIS.firstOrNull() ?: "")
                "isTv" -> result.success(isTv(resources.configuration))
                // The update package's own folder: on the shared storage when
                // there is one, so the system's installer reads it there.
                "updateDir" -> {
                    val dir = getExternalFilesDir("updates") ?: File(filesDir, "updates")
                    result.success(dir.absolutePath)
                }
                // Android 8 and later: this app may install packages, asked
                // once in its own settings page.
                "canInstallPackages" -> result.success(
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        packageManager.canRequestPackageInstalls()
                    } else {
                        true
                    }
                )
                "openInstallPermissionSettings" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        try {
                            startActivity(
                                Intent(
                                    Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                                    Uri.parse("package:$packageName")
                                )
                            )
                        } catch (e: Exception) {
                            // A rare system without the page: the app's own
                            // settings page at least opens nearby.
                            startActivity(Intent(Settings.ACTION_SETTINGS))
                        }
                    }
                    result.success(null)
                }
                // The downloaded update's APK goes to the system's installer,
                // which asks the user; no other app's page, no browser.
                "installApk" -> {
                    val path = call.argument<String>("path") ?: ""
                    val file = File(path)
                    if (!file.exists()) {
                        result.error("no_apk", "the package is not there", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val uri = FileProvider.getUriForFile(
                            this, "$packageName.updates", file
                        )
                        val install = Intent(Intent.ACTION_INSTALL_PACKAGE).apply {
                            data = uri
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(install)
                        result.success(true)
                    } catch (e: ActivityNotFoundException) {
                        // A TV without an installer: the notice falls back to
                        // the download in a browser.
                        result.success(false)
                    } catch (e: Exception) {
                        result.error("install_failed", e.message, null)
                    }
                }
                "routingCountries" -> inBackground(result) { routingCountries() }
                "openUrl" -> {
                    val url = call.argument<String>("url") ?: ""
                    val view = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                    try {
                        // A TV without a browser does not throw: its stub
                        // "browser" only shows Android's "no app" message.
                        val handlers = packageManager.queryIntentActivities(view, 0)
                            .filter { it.activityInfo.packageName != "com.android.tv.frameworkpackagestubs" }
                        if (handlers.isEmpty()) {
                            result.success(false)
                            return@setMethodCallHandler
                        }
                        startActivity(view)
                        result.success(true)
                    } catch (e: ActivityNotFoundException) {
                        result.success(false)
                    }
                }
                // The home screen's long-press shortcuts: the countries the
                // user pinned, so "connect to Germany" starts without
                // opening the app.
                "setShortcuts" -> {
                    @Suppress("UNCHECKED_CAST")
                    val entries =
                        call.argument<List<Map<String, Any>>>("shortcuts") ?: emptyList()
                    setShortcuts(entries)
                    result.success(null)
                }
                // The diagnostics report leaves through the phone's own
                // share sheet; where there is none (a desktop) the app
                // keeps the clipboard.
                "shareText" -> {
                    val text = call.argument<String>("text") ?: ""
                    val title = call.argument<String>("title") ?: ""
                    val send = Intent(Intent.ACTION_SEND).apply {
                        type = "text/plain"
                        putExtra(Intent.EXTRA_TEXT, text)
                        putExtra(Intent.EXTRA_TITLE, title)
                    }
                    try {
                        startActivity(Intent.createChooser(send, title))
                        result.success(true)
                    } catch (e: ActivityNotFoundException) {
                        result.success(false)
                    }
                }
                // The hotspot's own page: the share page's one tap. The
                // tether row has no public constant; the vendor builds
                // answer to its name, and a phone that does not falls
                // back to the wireless settings.
                "openTetherSettings" -> {
                    try {
                        startActivity(
                            Intent("android.settings.TETHER_SETTINGS")
                                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        )
                        result.success(true)
                    } catch (e: Exception) {
                        runCatching {
                            startActivity(
                                Intent(Settings.ACTION_WIRELESS_SETTINGS)
                                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            )
                        }.onSuccess { result.success(true) }
                            .onFailure { result.success(false) }
                    }
                }
                // Battery optimization: whether this app already stands
                // outside it, the direct ask, and the system's own page
                // for the OEMs' killers the direct ask cannot reach.
                "batteryIgnored" -> {
                    val power = getSystemService(PowerManager::class.java)
                    result.success(power?.isIgnoringBatteryOptimizations(packageName) == true)
                }
                "requestIgnoreBattery" -> {
                    askForNotifications()
                    @Suppress("BatteryLife")
                    val intent = Intent(
                        Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                        Uri.parse("package:$packageName"),
                    )
                    result.success(runCatching { startActivity(intent) }.isSuccess)
                }
                "openBatterySettings" -> {
                    val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                    result.success(runCatching { startActivity(intent) }.isSuccess)
                }
                // Per-app data usage: the system's own accounting, which
                // already knows which app's traffic the VPN carried. The
                // Usage access permission is the user's to grant; without
                // it, "granted" is false and the app explains.
                "usageApps" -> inBackground(result) { usageApps(call.argument<Int>("days") ?: 1) }
                "openUsageAccess" -> {
                    val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                    result.success(runCatching { startActivity(intent) }.isSuccess)
                }
                else -> result.notImplemented()
            }
        }
        // A shortcut tapped before the engine answered: speak it now.
        pendingShortcut?.let { code ->
            pendingShortcut = null
            channel.invokeMethod("openShortcut", mapOf("country" to code))
        }
    }

    private val worker = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())

    /** Country codes for first-run routing; no phone or location permissions. */
    private fun routingCountries(): Map<String, String> {
        if (!packageManager.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)) {
            return emptyMap()
        }
        val service = getSystemService(TelephonyManager::class.java) ?: return emptyMap()
        // On dual-SIM devices use the subscription selected for mobile data.
        val phone = runCatching {
            val subscription = SubscriptionManager.getDefaultDataSubscriptionId()
            if (subscription >= 0) {
                service.createForSubscriptionId(subscription)
            } else {
                service
            }
        }.getOrDefault(service)
        return mapOf(
            "network_country" to runCatching { phone.networkCountryIso ?: "" }.getOrDefault(""),
            "sim_country" to runCatching { phone.simCountryIso ?: "" }.getOrDefault("")
        )
    }

    /**
     * Runs [work] off the UI thread and answers with its value. A body whose
     * last line is a void call (a poke, a save) comes back kotlin.Unit,
     * which the message codec refuses — the "Unsupported value: 'kotlin.Unit'"
     * crash of release builds: a Unit is folded to null, the codec's own
     * "nothing", so no handler can trip on it again.
     */
    private fun inBackground(result: Result, work: () -> Any?) {
        worker.execute {
            val value = try {
                when (val v = work()) {
                    Unit -> null
                    else -> v
                }
            } catch (e: Exception) {
                null
            }
            main.post { result.success(value) }
        }
    }

    /**
     * The installed apps but this one: package, name, and whether it has a
     * launcher icon, on a phone's home screen or a TV's (the others are
     * mostly the system's). Packages without code (overlays, resources) use
     * no network and are left out.
     */
    private fun installedApps(): List<Map<String, Any>> {
        val pm = packageManager
        val withIcon = listOf(Intent.CATEGORY_LAUNCHER, Intent.CATEGORY_LEANBACK_LAUNCHER)
            .flatMap { pm.queryIntentActivities(Intent(Intent.ACTION_MAIN).addCategory(it), 0) }
            .map { it.activityInfo.packageName }
            .toSet()
        @Suppress("DEPRECATION")
        return pm.getInstalledApplications(0)
            .filter { it.packageName != packageName && (it.flags and ApplicationInfo.FLAG_HAS_CODE) != 0 }
            .map {
                mapOf(
                    "package" to it.packageName,
                    "label" to it.loadLabel(pm).toString(),
                    "launcher" to (it.packageName in withIcon),
                )
            }
    }

    /** The pinned countries as the launcher's long-press shortcuts. */
    private fun setShortcuts(entries: List<Map<String, Any>>) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N_MR1) return
        val manager = getSystemService(ShortcutManager::class.java) ?: return
        val shortcuts = entries.take(4).mapIndexedNotNull { index, entry ->
            val code = entry["code"] as? String ?: return@mapIndexedNotNull null
            val name = entry["name"] as? String ?: code
            val intent = Intent(this, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                putExtra("shortcut_country", code)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            }
            ShortcutInfo.Builder(this, "country_$code")
                .setShortLabel(name)
                .setLongLabel(name)
                .setRank(index)
                .setIntent(intent)
                .build()
        }
        runCatching { manager.setDynamicShortcuts(shortcuts) }
    }

    /**
     * Per-app data usage for the last [days] days, the system's own
     * accounting (Wi-Fi and mobile together, the VPN's carried traffic
     * already attributed to the app that made it). Needs Usage access.
     */
    private fun usageApps(days: Int): Map<String, Any> {
        val ops = getSystemService(AppOpsManager::class.java)
        val mode = ops?.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(), packageName,
        )
        if (mode != AppOpsManager.MODE_ALLOWED) {
            return mapOf("granted" to false, "apps" to emptyList<Map<String, Any>>())
        }
        val manager = getSystemService(NetworkStatsManager::class.java)
            ?: return mapOf("granted" to true, "apps" to emptyList<Map<String, Any>>())
        val end = System.currentTimeMillis()
        val start = end - days.coerceAtLeast(1) * 24L * 60 * 60 * 1000
        val totals = HashMap<Int, Long>()
        for (type in intArrayOf(
            ConnectivityManager.TYPE_WIFI,
            ConnectivityManager.TYPE_MOBILE,
        )) {
            try {
                @Suppress("DEPRECATION") // the per-uid buckets have no modern call
                val stats = manager.querySummary(type, null, start, end)
                val bucket = NetworkStats.Bucket()
                while (stats.hasNextBucket()) {
                    stats.getNextBucket(bucket)
                    val uid = bucket.uid
                    if (uid < Process.FIRST_APPLICATION_UID) continue
                    totals[uid] = (totals[uid] ?: 0L) + bucket.rxBytes + bucket.txBytes
                }
                stats.close()
            } catch (e: Exception) {
                // One carrier's subscriberId rule keeps its own type away;
                // the other type still answers.
            }
        }
        val pm = packageManager
        val apps = totals.entries.mapNotNull { (uid, bytes) ->
            val pkg = pm.getPackagesForUid(uid)?.firstOrNull() ?: return@mapNotNull null
            if (pkg == packageName) return@mapNotNull null
            val info = runCatching { pm.getApplicationInfo(pkg, 0) }.getOrNull()
                ?: return@mapNotNull null
            mapOf(
                "package" to pkg,
                "label" to pm.getApplicationLabel(info).toString(),
                "bytes" to bytes,
            )
        }.sortedByDescending { (it["bytes"] as Long) }
            .take(50)
        return mapOf("granted" to true, "apps" to apps)
    }

    /** An app's icon as a small PNG. */
    private fun appIcon(pkg: String): ByteArray {
        val drawable = packageManager.getApplicationIcon(pkg)
        val size = 96
        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        drawable.setBounds(0, 0, size, size)
        drawable.draw(Canvas(bitmap))
        return ByteArrayOutputStream().also { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }.toByteArray()
    }

    private fun turnOn(result: Result) {
        try {
            CoreService.turnOn(this)
            result.success(null)
        } catch (e: Exception) {
            result.error("start_failed", e.message, null)
        }
    }

    @Deprecated("The VPN permission is asked with startActivityForResult.")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SAVE_REQUEST) {
            saved(resultCode, data?.data)
            return
        }
        if (requestCode == OPEN_REQUEST) {
            opened(resultCode, data?.data)
            return
        }
        if (requestCode != VPN_REQUEST) return
        val result = pendingOn ?: return
        pendingOn = null
        if (resultCode == RESULT_OK) turnOn(result) else result.error("vpn_denied", "the VPN was not allowed", null)
    }

    /** Writes the pending file to [uri], the place the user picked. */
    private fun saved(resultCode: Int, uri: Uri?) {
        val (bytes, result) = pendingSave ?: return
        pendingSave = null
        if (resultCode != RESULT_OK || uri == null) {
            result.success(null)
            return
        }
        worker.execute {
            val name = try {
                contentResolver.openOutputStream(uri, "wt")?.use { it.write(bytes) }
                    ?: throw IllegalStateException("the file could not be opened")
                displayName(uri)
            } catch (e: Exception) {
                main.post { result.error("write_failed", e.message, null) }
                return@execute
            }
            main.post { result.success(name) }
        }
    }

    /** Reads the picked file at [uri], to the end. */
    private fun opened(resultCode: Int, uri: Uri?) {
        val result = pendingOpen ?: return
        pendingOpen = null
        if (resultCode != RESULT_OK || uri == null) {
            result.success(null)
            return
        }
        worker.execute {
            val bytes = try {
                contentResolver.openInputStream(uri)?.use { input ->
                    val out = ByteArrayOutputStream()
                    val buf = ByteArray(64 * 1024)
                    while (true) {
                        val n = input.read(buf)
                        if (n < 0) break
                        out.write(buf, 0, n)
                        // A backup is a few kilobytes; nothing sensible is this big.
                        if (out.size() > MAX_OPEN_BYTES) throw IllegalStateException("the file is too large")
                    }
                    out.toByteArray()
                } ?: throw IllegalStateException("the file could not be opened")
            } catch (e: Exception) {
                main.post { result.error("read_failed", e.message, null) }
                return@execute
            }
            main.post { result.success(bytes) }
        }
    }

    private fun displayName(uri: Uri): String =
        contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use {
            if (it.moveToFirst()) it.getString(0) else null
        } ?: uri.lastPathSegment ?: ""

    override fun onDestroy() {
        // Off, nothing needs the core once the UI is gone.
        if (isFinishing && !CoreService.on) CoreService.stopCore()
        super.onDestroy()
    }

    /** The service's notification needs this on Android 13 and later. */
    private fun askForNotifications() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1)
        }
    }

    /**
     * The update's own notification: a newer version is out, from the app's
     * side (the check runs there). Its own channel, at an importance that
     * actually shows — the service's state card stays quiet, a release
     * should not. One id for all releases: the next one takes the card
     * over instead of stacking.
     */
    private fun notifyUpdate(title: String, body: String) {
        try {
            val manager = getSystemService(NotificationManager::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                manager.createNotificationChannel(
                    NotificationChannel(
                        UPDATES_CHANNEL,
                        getString(R.string.updates_channel),
                        NotificationManager.IMPORTANCE_DEFAULT,
                    ),
                )
            }
            val launch = packageManager.getLaunchIntentForPackage(packageName)
            val open = if (launch != null) PendingIntent.getActivity(
                this, 0, launch,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
            ) else null
            val notification = Notification.Builder(this, UPDATES_CHANNEL)
                .setSmallIcon(R.drawable.ic_stat_logo)
                .setContentTitle(title)
                .setContentText(body)
                .setStyle(Notification.BigTextStyle().bigText(body))
                .setAutoCancel(true)
                .also { if (open != null) it.setContentIntent(open) }
                .build()
            manager.notify(UPDATES_NOTIFICATION_ID, notification)
        } catch (e: Exception) {
            // No permission, no channel, no bell: the home page's notice
            // carries the release either way.
            android.util.Log.w("MainActivity", "the update notification did not post", e)
        }
    }

    companion object {
        private const val VPN_REQUEST = 7
        private const val SAVE_REQUEST = 8
        private const val OPEN_REQUEST = 9
        private const val MAX_OPEN_BYTES = 16 * 1024 * 1024

        /** The update notices' own channel and the one id they share. */
        private const val UPDATES_CHANNEL = "updates"
        private const val UPDATES_NOTIFICATION_ID = 41
    }
}
