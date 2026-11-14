package com.arman.firefoxvpn

import android.annotation.SuppressLint
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.TextView
import java.util.Locale
import kotlin.math.abs

/**
 * The floating island: a small dark pill at the screen's top that carries
 * the connection while the app itself is away — a dot for the state and
 * the exit country's name (the speed too, when the notification shows
 * it). It is the "dynamic island" that lives outside the app: it hides
 * while the app is open, follows the same poll as the notification, moves
 * with a finger, and a tap brings the app back. The design stays the
 * app's own: a black glass pill, white ink, a monochrome dot — white
 * connected, gray while connecting.
 */
class IslandOverlay : Service() {
    private val main = Handler(Looper.getMainLooper())
    private var windowManager: WindowManager? = null
    private var view: View? = null
    private var params: WindowManager.LayoutParams? = null
    private var label: TextView? = null

    /** The text shown now; unchanged states skip the layout pass. */
    private var shownText = ""
    private var shownState = -1
    private var shownVisible: Boolean? = null

    /** The user's last resting place, kept while the process lives. */
    private var dragX = 0f
    private var dragY = 0f

    /** Where this touch began, and whether it turned into a drag. */
    private var downX = 0f
    private var downY = 0f
    private var moved = false

    private val watch = object : Runnable {
        override fun run() {
            if (!CoreService.on || !enabled(this@IslandOverlay)) {
                stopSelf()
                return
            }
            paint()
            // The app being in front decides whether the pill is seen;
            // reconciled here too, so a hidden pill always comes back.
            val visible = !foreground
            if (shownVisible != visible) {
                shownVisible = visible
                view?.visibility = if (visible) View.VISIBLE else View.GONE
            }
            main.postDelayed(this, POLL_MS)
        }
    }

    override fun onCreate() {
        super.onCreate()
        if (!canDraw(this)) {
            stopSelf()
            return
        }
        instance = this
        windowManager = getSystemService(Context.WINDOW_SERVICE) as? WindowManager
        val pad = px(16)
        val root = TextView(this).also { label = it }
        root.typeface = Typeface.create("sans-serif-medium", Typeface.NORMAL)
        root.setTextColor(Color.WHITE)
        root.textSize = 13f
        root.setPadding(pad + px(6), px(9), pad + px(6), px(9))
        // The pill and its dot: a rounded black glass, the state's light
        // beside the words. The dot rides inside the text as a colored
        // bullet, so the pill is one view and moves as one.
        root.background = GradientDrawable().apply {
            setColor(0xEE0B0B0B.toInt())
            cornerRadius = px(26).toFloat()
            setStroke(px(1), 0x24FFFFFF)
        }
        @SuppressLint("ClickableViewAccessibility")
        root.setOnTouchListener { _, event ->
            val p = params
            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    downX = event.rawX
                    downY = event.rawY
                    moved = false
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    if (p != null) {
                        if (abs(event.rawX - downX) > px(6) ||
                            abs(event.rawY - downY) > px(6)
                        ) {
                            moved = true
                        }
                        if (moved) {
                            dragX += event.rawX - downX
                            dragY += event.rawY - downY
                            downX = event.rawX
                            downY = event.rawY
                            p.x = dragX.toInt()
                            p.y = (statusBarHeight() + px(10) + dragY.toInt())
                                .coerceIn(0, 2400)
                            runCatching {
                                view?.let { v ->
                                    windowManager?.updateViewLayout(v, p)
                                }
                            }
                        }
                    }
                    true
                }
                MotionEvent.ACTION_UP -> {
                    // A tap, not a drag: the app comes back.
                    if (!moved) openApp()
                    true
                }
                else -> false
            }
        }
        view = root
        params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                @Suppress("DEPRECATION")
                WindowManager.LayoutParams.TYPE_PHONE
            },
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT,
        ).apply {
            gravity = Gravity.TOP or Gravity.CENTER_HORIZONTAL
            x = dragX.toInt()
            y = statusBarHeight() + px(10) + dragY.toInt()
        }
        runCatching {
            windowManager?.addView(root, params)
        }.onFailure {
            view = null
            stopSelf()
            return
        }
        main.post(watch)
    }

    /** A tap, not a drag, opens the app. */

    private fun openApp() {
        runCatching {
            startActivity(
                Intent(this, MainActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
            )
        }
    }

    /** Paints the state now: the words, the dot, and whether it shows
     *  at all (the app being in front hides it). */
    fun paint() {
        val l = label ?: return
        val state = when {
            !CoreService.on -> 0
            CoreService.connected -> 2
            else -> 1
        }
        val text = when {
            !CoreService.on -> ""
            CoreService.connected -> runCatching {
                val code = mobile.Mobile.exitCountry()
                val place = if (code.length == 2) {
                    "${CoreService.flag(code)}  ${Locale.Builder().setRegion(code).build().displayCountry}"
                } else {
                    ""
                }
                val speed = if (CoreService.showSpeed(this)) {
                    "  ·  ${CoreService.speedText(mobile.Mobile.speed())}"
                } else {
                    ""
                }
                "$place$speed"
            }.getOrDefault("")
            else -> getString(R.string.notification_connecting)
        }
        if (state == shownState && text == shownText) return
        shownState = state
        shownText = text
        val bullet = when (state) {
            2 -> "●" // connected: the design's own light, white on black
            1 -> "◐" // connecting: half light
            else -> "○"
        }
        l.text = if (text.isEmpty()) "$bullet  ${getString(R.string.app_name)}" else "$bullet  $text"
    }

    /** Hides the pill at once, without stopping the service. */
    fun hide() {
        shownVisible = false
        view?.visibility = View.GONE
    }

    private fun statusBarHeight(): Int {
        val id = resources.getIdentifier("status_bar_height", "dimen", "android")
        return if (id > 0) resources.getDimensionPixelSize(id) else px(28)
    }

    private fun px(dp: Int) = (dp * resources.displayMetrics.density).toInt()

    override fun onDestroy() {
        main.removeCallbacks(watch)
        view?.let { v ->
            runCatching { windowManager?.removeView(v) }
        }
        view = null
        label = null
        if (instance == this) instance = null
        super.onDestroy()
    }

    override fun onBind(intent: Intent?) = null

    companion object {
        private const val PREFS = "vpn"
        private const val ISLAND = "floating_island"
        private const val POLL_MS = 3000L

        /** The service alive now, for the instant hide when the app opens. */
        private var instance: IslandOverlay? = null

        /** Whether the app's own window is in front (then no pill). */
        @Volatile
        var foreground = false
            private set

        fun setForeground(inForeground: Boolean) {
            foreground = inForeground
        }

        /** Whether the user asked for the island at all. */
        fun enabled(context: Context) =
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .getBoolean(ISLAND, false)

        /** Keeps the choice; a running pill follows it at once. */
        fun setEnabled(context: Context, on: Boolean) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit().putBoolean(ISLAND, on).apply()
            refresh(context)
        }

        /** Whether this app may draw over other apps. */
        fun canDraw(context: Context) =
            Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
                Settings.canDrawOverlays(context)

        /**
         * Starts or stops the pill for the state now. Cheap when nothing
         * changed, so CoreService may call it on every poll — and its
         * calls start the service from a foreground process, where
         * Android allows it.
         */
        fun refresh(context: Context) {
            val app = context.applicationContext
            val want = enabled(app) && CoreService.on && !foreground && canDraw(app)
            if (want) {
                runCatching {
                    app.startService(Intent(app, IslandOverlay::class.java))
                }
            } else {
                runCatching { app.stopService(Intent(app, IslandOverlay::class.java)) }
            }
        }

        /** The app came to the front: the pill goes at once. */
        fun hideNow() {
            foreground = true
            instance?.hide()
        }

        /** The app went away: the pill returns at once (the poll keeps it). */
        fun wentBackground() {
            foreground = false
            val live = instance
            if (live != null) live.main.post { live.paint() }
        }
    }
}
